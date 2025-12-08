function [ cobs_pert ] = perturb_data( cobs, cstd  )
% Perturb data by randomly sampling from a Gaussian distribution centered
% on the observed value with standard deviation equal to the uncertainty
%

cobs_pert = normrnd(cobs, cstd);

end

