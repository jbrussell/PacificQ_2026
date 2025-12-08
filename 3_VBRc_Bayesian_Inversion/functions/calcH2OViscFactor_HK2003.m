function [scale] = calcH2OViscFactor_HK2003(VBR)
% Calculate a factor for the influence of H2O on viscosity
% JBR

% extract state variables and parameters
  T_K = VBR.in.SV.T_K ; % [K]
  P_Pa = 1e9.*(VBR.in.SV.P_GPa) ; % [GPa] to [Pa]
  sig = VBR.in.SV.sig_MPa; % deviatoric stress [MPa]
  d = VBR.in.SV.dg_um ; % [um]
  phi = VBR.in.SV.phi ;
  fH2O = VBR.in.SV.Fh2o ; % [MPa]
  params=VBR.in.viscous.HK2003;

mech='diff'; % use diffusion creep mechanism
if isfield(VBR.in.viscous.HK2003,mech)
    % prep the flow law parameters
    FLP_dry=prep_constants(0*fH2O,T_K,params.(mech),mech);
    FLP_wet=prep_constants(fH2O,T_K,params.(mech),mech);
    if VBR.in.GlobalSettings.melt_enhancement==0
       FLP_dry.x_phi_c=1;
       FLP_wet.x_phi_c=1;
    end
    % calculate strain rate (ignoring melt effect, phi=0)
    sr_dry = sr_flow_law_calculation(T_K,P_Pa,sig,d,0*phi,0*fH2O,FLP_dry);
    sr_wet = sr_flow_law_calculation(T_K,P_Pa,sig,d,0*phi,fH2O,FLP_wet);
    
    eta_dry = sig*1e6./sr_dry; % viscosity
    eta_wet = sig*1e6./sr_wet; % viscosity 
    
    % Calculate scale factor to pre-multiply timescales tau_{L,H,P}
    scale = eta_wet ./ eta_dry;
else
    error('Viscous method is missing this mechanism!')
end

end

function FLP=prep_constants(fH2O,T_K,params,mech)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % FLP=prep_constants(fH2O,T_K,params,mech)
  %
  % builds the flow law parameters (FLP) structure
  %
  % Parameters:
  % ----------
  % fH2O    oxygen fugacity [MPa]
  % T_K     temperature [K]
  % params  the parameter structure
  % mech    the current deformation mechanism
  %
  % Output:
  % ------
  % FLP    flow law parameter structure with flow law constants
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  FLP = struct();
  fields={'A';'n';'p';'r';'Q';'V';'phi_c';'alf';'x_phi_c'};
  for ifi = 1:numel(fields(:,1))
    name=char(fields(ifi,:)); % current fieldname
    if strcmp(mech,'diff') || strcmp(mech,'disl')
      % diffusion/dislocaiton creep with different parameters depending on
      % the water content
      name_wet = [name '_wet'];
      dry = params.(name);
      wet = params.(name_wet);
      wet_dry=dry .* (fH2O == 0) + wet .* (fH2O > 0);
      FLP.(name) =  wet_dry;
    elseif strcmp(mech,'gbs')
      % grain boundary sliding mechanism has different parameters for above
      % and below 1250 C
      name_gt = [name '_gt1250'];
      name_lt = [name '_lt1250'];
      gt1250 = params.(name_gt);
      lt1250 = params.(name_lt);
      val = gt1250 .* (T_K-273 >= 1250) + lt1250 .* (T_K-273<1250);
      FLP.(name) =  val;
    end
  end
end

