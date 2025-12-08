function [ gs_ss ] = SSgrainsize_AE07( sigma,T,p,P )
% Calculate steady-state grain size from Turner et al. (2017)
%
% IN
% sigma: Stress [MPa]
%     T: Temperature [K]
%     p: Grain growth exponent [2 for single phase; >2 for multiphase; 4-6] (Turner et al. 2017 uses 5)
%     P: Pressure [MPa]
%
% OUT
% gs_ss: Steady-state grain size [m]
%
% jbrussell 1/20

% Thermodynamic constants
R = 8.314; % [J * K^-1 * mol^-1]

% sigma = sigma/2;
sigma_MPa = sigma;
sigma_Pa = sigma*1e6; 

% Grain size parameters
K_g = 6.67e-11; % [m^5 * s^-1]
E_g = 3.35e5; % [J * mol^-1]
V_g = 8e-6; % [m^3 mol^-1]
% p = 5;
psi = 0.0625; % [m^2 * J^-1]
% psi = 0.0625 * 1e6; % [m^-1 MPa^-1]

% Dislocation creep parameters (Hansen et al. 2011)
n = 3.5;
% A_dis = 1.1e5/1e6/1e6; % [MPa^-n * s^-1]
A_dis = 1.1e5;% * 10^(-n); % [MPa^-n * s^-1]
E_dis = 530e3; % [J mol^-1]
V_dis = 1.6e-5; % [m^3 mol^-1]

P = P*1e6; % convert MPa -> Pa

% gs_ss = (K_g.*exp(-E_g./R./T)./(p*psi*A_dis.*sigma.^(n+1).*exp(-E_dis./R./T))).^(1./(1+p));
gs_ss = (K_g.*exp((E_dis+P*V_dis-E_g-P*V_g)./R./T)./(p*psi*A_dis.*sigma_MPa.^(n).*sigma_Pa)).^(1./(1+p));
    
end

