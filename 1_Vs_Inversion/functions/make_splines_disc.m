function [ spbasis,spwts,spzz ] = make_splines_disc( zknots,dz,zi,vi )
%  [ spbasis,spwts,spzz ] = make_splines( zknots,dz,zi,vi )
%   
% Function to make splines within a current model with knots at absolute
% depths zknots. The splines will be defined on an interpolated grid (spzz)
% between the top and bottom splines. We will find weights for these
% splines by interpolating the basis onto vectors zi and vi.
%
% JBR 10/1/2022 - this version
% 
% INPUTS:
%   zknots   - vector of depths of spline knots (km)
%   dz.mod.zi  - increment of depth grid (km)
%   zi   - vector of depths for input velocity profile (km)
%   vi   - vector of velocities for input velocity profile [optional] (km/s)
% OUTPUTS:
%   spbasis  - matrix with spline basis (Nz x Nsp)
%   spwts    - (Nsp x 1) vector of spline weights to fit [zi,vi] profile 
%   spzz     - (Nz x 1) vector of depths for splines (km)
% 
% N.B.  to move spline knots but not change velocities, just ignore the new
% weightings, use new spbasis and knots positions. 

if nargin<4 % no velocities input for interpolation, so just use dummies.
    vi = zi;
end

ind_disc = [1; find(diff(zknots)==0); length(zknots)];
zknots_chunk = {};
for izchunk = 1:length(ind_disc)-1
    zknots_chunk{izchunk} = zknots(ind_disc(izchunk):ind_disc(izchunk+1));
    zknots_chunk{izchunk} = unique(zknots_chunk{izchunk});
end

Irep = find(ismember(zknots(diff(zknots)==0),zi)); % find repeating nodes
spbasis_all = zeros(length(zi)+length(Irep),length(zknots)+1);
zknots_all = [];
zi_all = [];
vi_all = [];
ii_zi = 0;
ii_sp = 0;
for izchunk = 1:length(zknots_chunk)
    minz = zknots_chunk{izchunk}(1);
    maxz = zknots_chunk{izchunk}(end);
    
    zi_chunk = zi(zi>=minz & zi<=maxz);
    vi_chunk = vi(zi>=minz & zi<=maxz);
    [spbasis_chunk,spcoeffs_chunk,spzz_chunk]=make_splines(zknots_chunk{izchunk}(:),[],zi_chunk,vi_chunk);
    
    zknots_all = [zknots_all; zknots_chunk{izchunk}(:)];
    zi_all = [zi_all; zi_chunk(:)];
    vi_all = [vi_all; vi_chunk(:)];
    spbasis_all(ii_zi+[1:length(zi_chunk)] , ii_sp+[1:length(spcoeffs_chunk)]) = spbasis_chunk;
    ii_zi = ii_zi + length(zi_chunk);
    ii_sp = ii_sp + length(spcoeffs_chunk);
end

spbasis = spbasis_all;
spwts = (spbasis'*spbasis)\(spbasis'*vi_all);
spzz = zi_all;


% % find spline coefficients manually
% N=length(zknots_all)+1; %unknowns
% M=length(zi_all); %depth points 
% 
% A=zeros(M,N);
% d=zeros(M,1);
% z=zeros(M,1);
% for ii=1:M
%   d(ii)=vi_all(ii);
%   z(ii)=zi_all(ii);
%   for jj=1:N
%     A(ii,jj)=spbasis_all(ii,jj);
%   end
% end
% m=(A'*A)\(A'*d);
% dpred=A*m;
% 
% spbasis = A;
% spwts = m;
% spzz = z;

if nargin<4
    spwts = [];
end


end

