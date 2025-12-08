function [out] = load_S362ANI_profile(pathS362ANI,lat,lon)

%% Load NETCDF
% ncdisp('S362ANI_kmps.nc')
mat.lat = ncread(pathS362ANI,'latitude');
mat.lon = ncread(pathS362ANI,'longitude');
mat.z = ncread(pathS362ANI,'depth');
mat.vsv = ncread(pathS362ANI,'vsv');
mat.vsh = ncread(pathS362ANI,'vsh');
mat.vs = ncread(pathS362ANI,'vs');

%% Find value closest lat, lon in array

[~,Ilat] = min(abs(lat-mat.lat));
[~,Ilon] = min(abs(lon-mat.lon));
out.vsv = squeeze(mat.vsv(Ilon,Ilat,:));
out.vsh = squeeze(mat.vsh(Ilon,Ilat,:));
out.z = mat.z;
out.xi = out.vsh.^2 ./ out.vsv.^2;

end

