function [priors] = intialize_depth_prior(test_vec,zvec,Nvals)

priors.edges_vec = linspace(min(test_vec(:)),max(test_vec(:)),Nvals);
priors.vec = 0.5*(priors.edges_vec(1:end-1)+priors.edges_vec(2:end));
priors.vals = zeros(length(zvec),length(priors.vec));
[priors.xmat,priors.zmat] = meshgrid(priors.vec,zvec);

end

