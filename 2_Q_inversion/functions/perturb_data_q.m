function [ odata ] = perturb_data_q( data, data_str  )
% Perturb data by randomly sampling from a Gaussian distribution centered
% on the observed value with standard deviation equal to the uncertainty
%

is_2sigma = 2; % are uncertainties 2-sigma? If so, divide by 2 to get standard deviation

if is_2sigma == 0
    stdfrac = 0.5; % 2-sigma uncertainty
elseif is_2sigma == 1
    stdfrac = 1; % 1-sigma uncertainty
else
    stdfrac = is_2sigma;
end

odata = data;

if isfield(odata,'rayl')
    odata.rayl.(data_str) = normrnd(data.rayl.(data_str), data.rayl.(['err_',data_str])*stdfrac);
end
if isfield(odata,'love')
    odata.love.(data_str) = normrnd(data.love.(data_str), data.love.(['err_',data_str])*stdfrac);
end

end

