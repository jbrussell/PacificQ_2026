function [sample] = sample_model_bounds(priors,N,Ncoeffs,model_bounds)

% Function to draw model from prior
sample = nan(N,Ncoeffs);
for ic = 1:Ncoeffs
    sample(:,ic) = priors(N,ic,model_bounds);
end

end

