function [ gs_ss ] = SSgrainsize_Behn09( sigma,T,P )
% Calculate steady-state grain size from Behn et al. (2009)
% They use wet flow laws and model "dry" by making water content low (C_OH = 50) 
%
% IN
% sigma: Stress [MPa]
%     T: Temperature [K]
%     P: Pressure [MPa]
%
% OUT
% gs_ss: Steady-state grain size [m]
%
% jbrussell 6/2020

% Thermodynamic constants
R = 8.314; % [J * K^-1 * mol^-1]

% sigma = sigma/2;

% Grain size parameters
p = 3;
G0 = 1.5e-5;% (Dry C_OH=50) * 10^(p); % [m^p * s^-1]
% G0 = 4.5e-4;% (Wet C_OH=1000) [m^p * s^-1];
E_g = 350e3; % [J * mol^-1]
V_g = 8e-6; % [m^3 mol^-1]
c = 3;
% gamma = 1; % [J m^-2]
gamma = 1 * 1e-6; % [m MPa]
chi = 0.1;

% Dislocation creep parameters (Hirth & Kholstedt 2003)
% A_dis = 1.1e5/1e6/1e6; % [MPa^-n * s^-1]
% A_dis = 1.1e5; % (Dry) [MPa^-n * s^-1]
A_dis = 30; % (Wet) [MPa^-3.5 * s^-1]
n = 3.5;
E_dis = 480e3; % [J mol^-1]
V_dis = 1.1e-5; % [m^3 mol^-1]
r_dis = 1.2; % Water exponent
C_OH = 50; % water concentration [H/10^6Si]

% % Dislocation creep parameters (Hansen et al. 2011)
% n = 3.5;
% % A_dis = 1.1e5/1e6/1e6; % [MPa^-n * s^-1]
% A_dis = 1.1e5;% * 10^(-n); % [MPa^-n * s^-1]
% E_dis = 530e3; % [J mol^-1]
% V_dis = 1.6e-5; % [m^3 mol^-1]
% r_dis = 1.2; % Water exponent
% C_OH = 50; % water concentration [H/10^6Si]

P = P*1e6; % convert MPa -> Pa

% Calculate strain rate for dislocation creep
sr_dis = A_dis * C_OH^r_dis * sigma.^n * exp(-(E_dis+P*V_dis)/R/T);

% gs_ss = (K_g.*exp(-E_g./R./T)./(p*psi*A_dis.*sigma.^(n+1).*exp(-E_dis./R./T))).^(1./(1+p));
num = G0 * exp(-(E_g+P*V_g)/R/T) * c * gamma;
denom = p * 2 * sigma * chi .* sr_dis;
gs_ss = (num ./ denom).^(1/(1+p));
    
end

