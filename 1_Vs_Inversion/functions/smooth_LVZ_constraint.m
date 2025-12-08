function [X00] = smooth_LVZ_constraint(X00, z, z_brks, fac, alpha)
% Break constraint equation at specified depths
%
% jbrussell 6/5/2020

    Ibrks = find(z>=min(z_brks) & z<=max(z_brks));
    Ibrks = [Ibrks(1)-1; Ibrks; Ibrks(end)+1];
    vfac = linspace(1,fac,ceil(length(Ibrks)/2));
    vfac = [vfac, flip(vfac)];
    vfac = vfac(1:length(Ibrks));
    vfac = vfac.^alpha;
    if 1
        figure(888); clf;
        set(gcf,'color','w');
        box on; hold on;
        plot(vfac,-z(Ibrks),'r','linewidth',2);
        plot([min(vfac) max(vfac)], -z_brks(1)*[1 1],'--b','linewidth',1.5);
        plot([min(vfac) max(vfac)], -z_brks(2)*[1 1],'--b','linewidth',1.5);
        set(gca,'fontsize',15,'linewidth',1.5);
        xlabel('Weighting factor');
        ylabel('Depth (km)');
    end
    for ibrk = 1:length(Ibrks)
%         if z_brks(ibrk) > max(z)
%             continue
%         end
%         [~,I_brk] = min(abs(z-z_brks(ibrk)));
        I_brk = Ibrks(ibrk);
        I_brk = I_brk + 1;
        if length(find(X00(I_brk,:)~=0))==3 % second derivative
            if I_brk-1<1 || I_brk+1>length(z)
                continue
            end
%             X00(I_brk-1:I_brk+1,:) = 0;
%             X00(I_brk-1:I_brk,:) = 0;
            if ibrk == 1
                X00(I_brk-1:I_brk,:) = X00(I_brk-1:I_brk,:) * vfac(ibrk);
            else
                X00(I_brk,:) = X00(I_brk,:) * vfac(ibrk);
            end
        end
        if length(find(X00(I_brk,:)~=0))==2 % first derivative
%             X00(I_brk,:) = 0;
            X00(I_brk,:) = X00(I_brk,:) * vfac(ibrk);
        end
    end
    
end

