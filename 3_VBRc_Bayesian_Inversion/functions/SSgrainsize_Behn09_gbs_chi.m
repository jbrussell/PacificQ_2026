function [ gs_ss ] = SSgrainsize_Behn09_gbs_chi( sigma,T,P,chi )
% Calculate steady-state grain size from Behn et al. (2009) using grain
% boundary sliding (GBS) rather than dislocation creep.
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
sigma_Pa = sigma*1e6;
sigma_MPa = sigma;

% Grain size parameters
p = 3;
G0 = 1.5e-5;% (Dry C_OH=50) * 10^(p); % [m^p * s^-1]
% G0 = 4.5e-4;% (Wet C_OH=1000) [m^p * s^-1];
E_g = 350e3; % [J * mol^-1]
V_g = 8e-6; % [m^3 mol^-1]
c = 3;
gamma = 1; % [J m^-2]
% gamma = 1 * 1e-6; % [m MPa]
%chi = 0.1;

% % GBS parameters (Hirth & Kohlstedt 2003)
% n = 3.5;
% m = 2;
% % A_dis = 1.1e5/1e6/1e6; % [MPa^-n * s^-1]
% % A_dis = 1.1e5; % (Dry) [MPa^-n * s^-1]
% % A_dis = 30; % (Wet) [MPa^-3.5 * s^-1]
% A_gbs = 6.5e3; % (DRY) [um^-m MPa^-3.5 * s^-1]
% E_gbs = 4e5; % [J mol^-1]
% V_gbs = 1.6e-5; % [m^3 mol^-1]
% r_gbs = 0; % Water exponent

% GBS parameters (Hansen et al. 2011)
n = 2.9; % stress exponent
m = 0.7; % grain size exponent
% A_dis = 1.1e5/1e6/1e6; % [MPa^-n * s^-1]
A_gbs = 10^(4.8);% * 10^(-n); % [um^-m MPa^-n * s^-1]
E_gbs = 4.45e5; % [J mol^-1]
V_gbs = 1.6e-5; % [m^3 mol^-1]
r_gbs = 0; % Water exponent

C_OH = 1; % water concentration [H/10^6Si]

P = P*1e6; % convert MPa -> Pa

% Calculate strain rate for gbs
% (Grain size dependence, m, is included in exponent of final equation)
sr_gbs = A_gbs * C_OH^r_gbs .* sigma_MPa.^n * (1e6)^(-m) * exp(-(E_gbs+P*V_gbs)/R/T);

num = G0 * exp(-(E_g+P*V_g)/R/T) * c * gamma;
denom = p * 2 * sigma_Pa * chi .* sr_gbs;
gs_ss = (num ./ denom).^(1/(1+p-m));
    
end

