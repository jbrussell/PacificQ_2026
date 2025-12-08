function [X00] = smooth_LVZ_constraint_atdiscs(X00, z, z_brks, fac, alpha, dz_disc)
% Smoothly decrease constraint equation at specified depths to allow for
% "smoother" discontinuities
%
% jbrussell 6/5/2020

    vfac_all = ones(size(z));
    
    for ii = 1:length(z_brks)
        Ibrks = find(z>=z_brks(ii)-dz_disc/2 & z<=z_brks(ii)+dz_disc/2);
        Ibrks = [Ibrks(1)-1; Ibrks; Ibrks(end)+1];
        vfac = linspace(1,fac,ceil(length(Ibrks)/2));
        vfac = [vfac, flip(vfac)];
        vfac = vfac(1:length(Ibrks));
        vfac = vfac.^alpha;
        vfac_all(Ibrks) = vfac;
    end
    
    if 1
        figure(888); clf
        set(gcf,'color','w');
        box on; hold on;
        plot(vfac_all,-z,'r','linewidth',2);
        plot([min(vfac) max(vfac)], -z_brks(1)*[1 1],'--b','linewidth',1.5);
        plot([min(vfac) max(vfac)], -z_brks(2)*[1 1],'--b','linewidth',1.5);
        set(gca,'fontsize',15,'linewidth',1.5);
        xlabel('Weighting factor');
        ylabel('Depth (km)');
    end
    
    X00 = X00 .* vfac_all;
    
end

