clear;

% Lat lon boundary
% NoMelt
parameters.lalim = [5 12] ;
parameters.lolim = [-150 -142];

%% Load NETCDF
% ncdisp('S362ANI_kmps.nc')
mat.lat = ncread('S362ANI_kmps.nc','latitude');
mat.lon = ncread('S362ANI_kmps.nc','longitude');
mat.z = ncread('S362ANI_kmps.nc','depth');
mat.vsv = ncread('S362ANI_kmps.nc','vsv');
mat.vsh = ncread('S362ANI_kmps.nc','vsh');
mat.vs = ncread('S362ANI_kmps.nc','vs');

%% Find value closest to center of array
clat = mean(parameters.lalim);
clon = mean(parameters.lolim);

[~,Ilat] = min(abs(clat-mat.lat));
[~,Ilon] = min(abs(clon-mat.lon));
vsv = squeeze(mat.vsv(Ilon,Ilat,:));
vsh = squeeze(mat.vsh(Ilon,Ilat,:));
z = mat.z;

%% Plot
figure(1); clf;
box on; hold on;
plot(vsv,z,'-k','linewidth',2);
plot(vsh,z,'-r','linewidth',2);
legend('V_{SV}','V_{SH}');
xlabel('Vs (km/s)');
ylabel('Depth (km)');
set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse');