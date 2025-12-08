% Function to read in the initial model card and plot it to double check
% that everything looks ok
%
% varargin used to take in name of model card for iteration step.
% if no name is given then the model is named init_model
% NJA, 2014

function qmod=read_qmod2(QMOD)

% Parameters spcefic to the format of these files
hlines1 = 1;

% Read model QMOD information
% cardname = [datapath,QMOD];

% QMOD = [QMOD,'.card'];
fid = fopen(QMOD,'r');
A=textscan...
    (fid,'%f %f %f','headerlines',hlines1);

qmod.fname=QMOD;
qmod.z = 6371-A{1};
qmod.rad = A{1}*1000;
qmod.qmu = A{2};
qmod.qmu_inv = 1./A{2};
qmod.qkap = A{3};
qmod.qkap_inv = 1./A{3};



end
