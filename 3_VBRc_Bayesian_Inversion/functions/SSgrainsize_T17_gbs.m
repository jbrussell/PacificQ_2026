function [ gs_ss ] = SSgrainsize_T17_gbs( sigma,T,p,P )
% Calculate steady-state grain size from Turner et al. (2017) using
% grain-boundary sliding (GBS) rather than dislocation creep.
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
% In flow law, stress in MPa and grainsize in microns. In grainsize
% evolution equation stress in Pa and grainsize output in m.
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

% GBS parameters
n = 2.9; % stress exponent
m = 0.7; % grain size exponent
% A_dis = 1.1e5/1e6/1e6; % [MPa^-n * s^-1]
A_gbs = 10^(4.8);% * 10^(-n); % [um^-m MPa^-n * s^-1]
E_gbs = 4.45e5; % [J mol^-1]
V_gbs = 1.6e-5; % [m^3 mol^-1]

P = P*1e6; % convert MPa -> Pa

% Calculate steady state grain size
gs_ss = (K_g.* exp((E_gbs+P*V_gbs-E_g-P*V_g)./R./T)./(p*psi*A_gbs.*sigma_MPa.^(n).*sigma_Pa*(1e6)^(-m))).^(1./(1+p-m));
    

% % Calculate strain rate for gbs
% % (Grain size dependence, m, is included in exponent of final equation)
% sr_gbs = A_gbs .* sigma.^n * exp(-(E_gbs+P*V_gbs)/R/T);
% 
% num = K_g * exp(-(E_g+P*V_g)/R/T);
% denom = p * psi * sigma .* sr_gbs;
% gs_ss = (num ./ denom).^(1/(1+p-m));
end

