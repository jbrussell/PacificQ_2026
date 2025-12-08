function [model] = sample_model(priors,model_bounds,Nparams)

% Sample model from priors
model = zeros(Nparams,1);
for ic = 1:Nparams
    model(ic,1) = priors.sample(model_bounds,1,ic);
end

end

