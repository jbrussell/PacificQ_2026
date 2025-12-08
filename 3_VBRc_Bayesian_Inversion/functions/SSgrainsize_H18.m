function [ gs_ss, g_att ] = SSgrainsize_H18( sigma,T )
% Calculate steady-state grain size from equation 57 of 
% Holtzman et al. (2018) JGR
%
% IN
% sigma: Stress [Pa]
%     T: Temperature [K]
%
% OUT
%  gs_ss: Stead-state grain size [µm]
% gs_att: Grainsize attractor (subgrain piezometer of Toriumi 1979)
%
% jbrussell 1/20

% Thermodynamic constants
R = 8.314; % [J * K^-1 * mol^-1]

% Grain size parameters
Q_sd = 200e3; % [J * mol^-1]
C_sd0 = 4e-22; % [Pa^(1-a) * m^2 * s^-1]
Q_gg = 200e3; % [J * mol^-1]
% Q_gg = 200e3*1.1; % [J * mol^-1]
C_gg0 = 2e-8; % [m^v * s^-1]
a = 1;
c_sg = 15;
c_2 = pi;
gamma = 1.0; % [J * m^-2]
c_g = c_2*gamma;

% Dislocation density parameters
s = 1.37;
beta = 1.74e-3; % [m^-2]
b = 0.5e-9; % [m]
mu = 50e9; % [Pa]

% Calculate grain-size attractor (subgrain piezometer of Toriumi 1979)
rho_dss = beta*b^-2*(sigma./mu).^s;
g_att = c_sg./sqrt(rho_dss);

% Stress-driven prefactor
C_sd = C_sd0 * exp(-Q_sd/R/T);

% Grain-growth prefactor
C_gg = C_gg0 * exp(-Q_gg/R/T);

% Calculate steady-state grain size
% gs_ss = (C_gg.*g_att + sqrt( C_gg.^2.*g_att.^2 + 16*C_sd.^2.*sigma.^(2*a).*c_g.^2)) ...
%         ./ (4*C_sd.*sigma.^(a).*c_g);

% JBR: Original equation 57 is missing a factor of g_att in the numerator!
% v=2
gs_ss = (C_gg.*g_att.^2 + sqrt( C_gg.^2.*g_att.^4 + 16*C_sd.^2.*sigma.^(2*a).*c_g.^2.*g_att.^2)) ...
        ./ (4*C_sd.*sigma.^(a).*c_g);
% v=3
% gs_ss = ( C_gg.*g_att.^2./(3.*C_sd.*sigma.^a.*c_g) + g_att.^2 ).^0.5;
    
end

