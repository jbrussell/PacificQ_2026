function [ midpt_matrix ] = midpts_vec( matrix )
% Find the midpoints along the rows of a matrix

nrow = size(matrix,1);
ncol = size(matrix,2);
if nrow > ncol
    midpt_matrix = zeros(nrow-1,ncol);
    midpt_matrix(:,1) = [matrix(1:end-1)+matrix(2:end)]/2;
elseif ncol > nrow
    midpt_matrix = zeros(nrow,ncol-1);
    midpt_matrix(1,:) = [matrix(1:end-1)+matrix(2:end)]/2;
end
    

