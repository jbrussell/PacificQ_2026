function [is_acceptable] = is_model_in_bounds(mod,bounds)
% Check that model is acceptable within bounds of M

is_acceptable = 1; % initiate flag

Nparams = length(mod);
for ic = 1:Nparams
    if mod(ic)<bounds(ic,1) || mod(ic)>bounds(ic,2)
        is_acceptable = 0;
        return
    end
end


end

