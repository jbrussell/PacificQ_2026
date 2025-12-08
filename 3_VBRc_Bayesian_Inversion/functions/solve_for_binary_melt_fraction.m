function [solution] = solve_for_binary_melt_fraction(T_K,P_GPa,C_h2o_solid,D_h2o,C_co2_solid,D_co2,solidus_str,F)
% If temperature greater than solidus, allow there to be melt at the
% prescribed melt fraction. !!! No melt stability calculation is done in this
% version !!!
%
% INPUTS
% T_K : Temperature in Kelvin [N x 1]
% P_GPa : Pressure in GPa [N x 1]
% C_h2o : ppm H2O contained in solid matrix (i.e., bulk content) [N x 1]
% D_h2o : H2O partition coefficient [1 x 1]
% C_co2 : ppm CO2 contained in solid matrix (i.e., bulk content) [N x 1]
% D_co2 : CO2 partition coefficient [1 x 1]
% solidus_str : Type of solidus solution to use | 'katz' or 'hirschmann'
%
% jbrussell 5/2023

% Cf_CO2_saturation = 38; % (wt %), saturation value used in Blatter et al. (2022)
Cf_CO2_saturation = 37; % (wt %), saturation value to be compatible with Dasgupta et al. (2007)

solution.phi = zeros(length(P_GPa),1);
solution.Cf_H2O = zeros(length(P_GPa),1);
solution.Cf_CO2 = zeros(length(P_GPa),1);
solution.Cs_H2O = zeros(length(P_GPa),1);
solution.Cs_CO2 = zeros(length(P_GPa),1);
solution.Cs_H2O_0 = zeros(length(P_GPa),1);
solution.Cs_CO2_0 = zeros(length(P_GPa),1);
solution.Cs_H2O_ppm = zeros(length(P_GPa),1);
solution.Cs_CO2_ppm = zeros(length(P_GPa),1);
solution.Tsolidus_K = zeros(length(P_GPa),1);

%% Do calculations 

Cs_H2O=C_h2o_solid*1e-4; % ppm to wt%
Cs_CO2=C_co2_solid*1e-4; % ppm to wt%

% calculate volatile fractions in melt
% Cf_H2O = Cs_H2O ./ (D_h2o + F * (1-D_h2o));
% Cf_CO2 = Cs_CO2 ./ (D_co2 + F * (1-D_co2));
Cf_H2O = Cs_H2O ./ (D_h2o + 0 * (1-D_h2o)); % Consider melt-free solidus to determine whether or not there should be melt
Cf_CO2 = Cs_CO2 ./ (D_co2 + 0 * (1-D_co2)); % Consider melt-free solidus to determine whether or not there should be melt
Cf_CO2(Cf_CO2>Cf_CO2_saturation) = Cf_CO2_saturation;
Cf_CO2(isnan(Cf_CO2)) = 0;

P_Pa = P_GPa*1e9; % [Pa]
[Solidus] = SoLiquidus(P_Pa,Cf_H2O,Cf_CO2,solidus_str);
Tsolidus_K = Solidus.Tsol(:) + 273;

% Find where T < Tsolidus and set melt fraction to zero
Imeltfree = find(T_K < Tsolidus_K);
F_solution = F;
F_solution(Imeltfree) = 0;


    
%% Save out solution values
solution.phi = F_solution;
solution.Cf_H2O = Cs_H2O ./ (D_h2o + F_solution * (1-D_h2o));
solution.Cf_CO2 = Cs_CO2 ./ (D_co2 + F_solution * (1-D_co2));
solution.Cf_CO2(solution.Cf_CO2>Cf_CO2_saturation) = Cf_CO2_saturation;
solution.Cf_CO2(isnan(solution.Cf_CO2)) = 0;

solution.Cs_H2O_0 = Cs_H2O; % Initial H2O concentration
solution.Cs_CO2_0 = Cs_CO2; % Initial CO2 concentration
solution.Cs_H2O = D_h2o*solution.Cf_H2O; % H2O concentration left over in solid
solution.Cs_CO2 = D_co2*solution.Cf_CO2; % CO2 concentration left over in solid
solution.Cs_H2O_ppm = solution.Cs_H2O*1e4; % H2O concentration left over in solid (ppm)
solution.Cs_CO2_ppm = solution.Cs_CO2*1e4; % CO2 concentration left over in solid (ppm)
[Solidus] = SoLiquidus(P_Pa,solution.Cf_H2O,solution.Cf_CO2,solidus_str); % recalculate solidus using final melt fractions. This feeds into pre-melting model.
solution.Tsolidus_K = Solidus.Tsol(:) + 273;


if 0
    figure(999); 
    set(gcf,'position',[294         372        1192         527],'color','w')
    clf
    
    subplot(1,3,1);
    hold on;
    plot(T_K-273,P_GPa,'-k','linewidth',3);
    plot(Tsolidus_K-273,P_GPa,'-b','linewidth',3);
    plot(solution.Tsolidus_K-273,P_GPa,'-r','linewidth',3);
    set(gca,'ydir','reverse','linewidth',1.5,'fontsize',15)
    xlabel('Temperature (C)');
    ylabel('Pressure (GPa)');
    legend({'Geotherm','Sol. melt-free','Sol. final'});
    
    subplot(1,3,2);
    hold on;
    plot(F*100,P_GPa,'-k','linewidth',3);
    plot(solution.phi*100,P_GPa,'--r','linewidth',3);
    set(gca,'ydir','reverse','linewidth',1.5,'fontsize',15)
    xlabel('Melt Fraction, \phi (%)');
    ylabel('Pressure (GPa)');
    legend({'\phi in','\phi out'})
    
    subplot(1,3,3);
    hold on;
    plot(C_h2o_solid,P_GPa,'-k','linewidth',3);
    plot(solution.Cs_H2O_ppm,P_GPa,'--r','linewidth',3);
    set(gca,'ydir','reverse','linewidth',1.5,'fontsize',15)
    xlabel('C_{H_2O} (ppm)');
    ylabel('Pressure (GPa)');
    legend({'H_2O bulk','H_2O solid'})
    
    
    pause;
end


end

