function [X00] = smooth_LVZ_constraint_dQdz(X00, z, z_brks, fac, alpha, dQdz, zmin, zmax)
% Smoothly decrease constraint equation at specified depths to allow for
% "smoother" discontinuities
%
% jbrussell 6/5/2020

    % define min and max of Q profile to consider
%     zmin = 30;
%     zmax = 280;
    Iuse = z>=zmin & z<=zmax;

    vfac_all = ones(size(z));
    
    z_q = dQdz(:,2);
    dqdz = dQdz(:,1);
    dqdz = interp1(z_q,dqdz,z);
    
    % Scale between 0 and gamma and flip
    vfac_dqdz = 1-dqdz/max(dqdz(Iuse))*(1-fac.^alpha);
    
    vfac_all(Iuse) = vfac_dqdz(Iuse);
    
    X00 = X00 .* vfac_all;
    
    if 1
        figure(888); clf
        set(gcf,'color','w');
        box on; hold on;
        plot(vfac_all,-z,'r','linewidth',2);
        plot([min(vfac_all) max(vfac_all)], -z_brks(1)*[1 1],'--b','linewidth',1.5);
        plot([min(vfac_all) max(vfac_all)], -z_brks(2)*[1 1],'--b','linewidth',1.5);
        set(gca,'fontsize',15,'linewidth',1.5);
        xlabel('Weighting factor');
        ylabel('Depth (km)');
    end
    
end

