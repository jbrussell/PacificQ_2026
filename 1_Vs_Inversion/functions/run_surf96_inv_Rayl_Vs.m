function [finalmod,cpre,vs_std] = run_surf96_inv_Rayl_Vs(cobs,cstd,periods,startmod,discs,eps_data,eps_H,eps_J,eps_F,z_dampbot,nit,nit_recalc_c,vp_vs,rho_vs)
% Do linearized inversion of Rayleigh wave phase velocities for Vs using
% surf96 to generate the kernels and to calculate phase velocity
%
% INPUTS (N=number of data; M=number of layers in model)
% cobs - phase velocity observed km/s [N x 1]
% cstd - phase velocity uncertainty km/s [N x 1]
% periods - seconds [N x 1]
% startmod - starting model: dz (km), vp (km/s), vs (km/s), rho (kg/m^3) [M x 4]
% discs - depth of desired discontinuities in smoothing (km) [any length x 1]
% eps_data - weight for data fit as fraction of G norm [scalar]
% eps_H - weight for norm damping as fraction of G norm [scalar]
% eps_J - weight for 1st derivative smoothing as fraction of G norm [scalar]
% eps_F - weight for 2nd derivative smoothing as fraction of G norm [scalar]
% z_dampbot - depth below which to damp to starting model (km) [scalar]
% nit - number of iterations [scalar]
% nit_recalc_c - number of iterations after which to recalculate phase velocity and kernels [scalar]
% vp_vs - desired vp/vs scaling [M x 1 or scalar]
% rho_vs - desired rho/vs scaling [M x 1 or scalar]
%
% OUTPUTS
% finalmod - final surf96 model: dz (km), vp (km/s), vs (km/s), rho (kg/m^3) [M x 4]
% cpre - phase velocity predicted for final model [N x 1]
% vs_std - formal uncertainties on Vs [M x 1]
%


% Calculate kernels for G matrix using SURF96
ifnorm = 0; % for plotting only
ifplot = 0;
[dcdvs, dcdvp, dudvs, dudvp, zkern] = calc_kernel96(startmod, periods, 'R', ifnorm, ifplot);    
G = dcdvs';

% Data weighting
% min_pct = 0.005; % minimum error percentage of observed
% I_error_too_small = find(cstd./cobs < min_pct);
% cstd(I_error_too_small) = cobs(I_error_too_small)*min_pct;
W = diag(1./cstd);

% Set up smoothing and damping matrices
nlayer = length(startmod(:,1));
dz = gradient(zkern);
dz_mat = repmat(dz,1,length(dz));
% Damping matrix
H00 = eye(nlayer);
h0 = startmod(:,3);
% first derviative flatness
J00 = build_flatness(nlayer) ./ dz_mat;
j0 = zeros(size(J00,2),1);
% second derivative smoothing
F00 = build_smooth( nlayer ) ./ dz_mat.^2;
f0 = zeros(size(F00,2),1);

% Break constraints at discontinuities
% z_brks = [waterdepth, seddepth, mohodepth];
% z_brks = [ seddepth, mohodepth];
% z_brks = sort([discs; zdisc_Q(:)]);
z_brks = sort(discs);
z = cumsum(startmod(:,1));
J00 = break_constraint(J00, z, z_brks);
F00 = break_constraint(F00, z, z_brks);

% Rescale the kernels
NA=norm(W*G,1);
NR=norm(H00,1);
eps_H0 = eps_H*NA/NR;
NR=norm(J00,1);
eps_J0 = eps_J*NA/NR;
NR=norm(F00,1);
eps_F0 = eps_F*NA/NR;

% Damp towards starting model
ind_dampstart = find(z > z_dampbot);
H00(ind_dampstart,ind_dampstart) = H00(ind_dampstart,ind_dampstart).*linspace(1,1000,length(ind_dampstart));
h0(ind_dampstart) = h0(ind_dampstart).*linspace(1,1000,length(ind_dampstart))';
% Kill water layers
ind_h2o = find(startmod(:,3)==0);
H00(ind_h2o,ind_h2o) = 1e9;

% combine all constraints
H = [H00*eps_H0; J00*eps_J0; F00*eps_F0];
h = [h0*eps_H0; j0*eps_J0; f0*eps_F0];

% Data vector
cstart = dispR_surf96(periods,startmod); % "predictions";
cpre = cstart;

% Least squares inversion
premod = startmod;
vs_pre = premod(:,3);
clrs = jet(nit);
isfigure = 1;
clear vs
for ii = 1:nit
    
    % reformulate inverse problem so that constraints apply directly to model
    dc = cobs - cpre;
    d = dc + G*vs_pre;
    
    % least squares
    F = [W*G*eps_data; H];
    f = [W*d*eps_data; h];
    m = (F'*F)\F'*f;
    vs = m(1:nlayer);
    
    % update data vector
    dvs = vs-vs_pre;
    dc_update = G * dvs;
    cpre = cpre + dc_update;
    
    % update model
    vs_pre = vs_pre + dvs;
    premod(:,3) = vs_pre;
    premod(:,2) = vp_vs .* premod(:,3); premod(premod(:,3)==0,2)=1.5;
    premod(:,4) = rho_vs .* premod(:,3); premod(premod(:,3)==0,4)=1.03;
    
    % Model uncertainties
    vs_std = diag(inv(F'*F)).^(1/2);
    
    if mod(ii,nit_recalc_c)==0
        cpre = dispR_surf96(periods,premod);
        dc = cobs - cpre;
        
        ifnorm = 0; % for plotting only
        ifplot = 0;
        [dcdvs, dcdvp, dudvs, dudvp, zkern] = calc_kernel96(premod, periods, 'R', ifnorm, ifplot);    
        G = dcdvs';
    end
    
    if isfigure
        if ii == 1 
            figure(2); clf; set(gcf,'position',[370   372   967   580]);
            
            subplot(2,2,[1 3]); box on; hold on;
            h2 = plotlayermods(startmod(:,1),startmod(:,3),'-k');
            h2.LineWidth = 4;
            
            subplot(2,2,2); box on; hold on;
            plot(periods,cstart,'-ok','linewidth',4);
        end
        subplot(2,2,[1 3]);
        h2 = plotlayermods(premod(:,1),premod(:,3),'-');
        h2.LineWidth = 2;
        h2.Color = clrs(ii,:);
        xlabel('Vs (km/s)');
        ylabel('Depth (km)');
        title('Starting Model');
        set(gca,'FontSize',18,'linewidth',1.5);
        
        subplot(2,2,2);
        plot(periods,cpre,'-o','color',clrs(ii,:),'linewidth',2);
        errorbar(periods,cobs,2*cstd,'or','linewidth',4);
        xlabel('Period');
        ylabel('Phase Velocity');
        set(gca,'FontSize',18,'linewidth',1.5);
        % pause;
        drawnow
    end
end

finalmod = premod;
cpre = dispR_surf96(periods,finalmod);

end

