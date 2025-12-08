function [s] = marginal_prob(K,d)
% Sum along all dimensions except dimension "d" of N dimensional matrix
%
% It works by swapping the first and the desired dimension, then reshaping 
% so that all trailing dimensions are reduced to one. The sum is then trivially along each row.
%
% K: N-dimensional matrix (prob.)
% d: dimension of interest
% s: output marginal probability

N = ndims(K);
v = 1:N;
v([1,d]) = v([d,1]);
s = sum(reshape(permute(K,v),size(K,d),[]),2);

end

