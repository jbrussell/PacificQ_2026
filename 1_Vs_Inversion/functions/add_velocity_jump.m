function [X00, x0] = add_velocity_jump(X00, x0, z, dz, z_brks, dv, eps_fac)
% Break constraint equation at specified depths
%
% jbrussell 6/5/2020
    for ibrk = 1:length(z_brks)
        if z_brks(ibrk) > max(z)
            continue
        end
        [~,I_brk] = min(abs(z-z_brks(ibrk)));
        I_brk = I_brk + 1;
        
        eps_0 = eps_fac / dz(I_brk);

        X00(I_brk,I_brk) = 1 * eps_0;
        X00(I_brk,I_brk-1) = -1 * eps_0;
        
        x0(I_brk) = dv(ibrk) * eps_0;
        
    end
    
end

