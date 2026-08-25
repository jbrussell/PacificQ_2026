clear;

% Lat lon boundary
% NoMelt
parameters.lalim = [5 12] ;
parameters.lolim = [-150 -142];

ncard = read_model_card('./CARDS/pa5_5km.card');
ocard_name = './CARDS/S362ANI_NoMelt.card';

zmax = 2500;

%% Set up crust2.0 values
crust2 = [
    5.1470    1.5000    0.0000    1.0200;  %water       
    0.0000    3.8100    1.9400    0.9200;  %ice         
    0.0700    1.8000    0.8000    1.7000;  %soft sed.   
    0.0000    3.2000    1.6000    2.3000;  %hard sed.   
    1.7000    5.0000    2.5000    2.6000;  %upper crust 
    2.3000    6.6000    3.6500    2.9000;  %middle crust
    2.5000    7.1000    3.9000    3.0500]; %lower crust
Izero = find(crust2(:,1)==0);
crust2(Izero,:) = [];
crust.dz = crust2(:,1);
crust.z = cumsum(crust.dz);
crust.vp = crust2(:,2);
crust.vs = crust2(:,3);
crust.rho = crust2(:,4) * 1000;

% Make discontinuities in crust to make MINEOS happy
crust.dz = [0; crust.dz(1); crust.dz(1); crust.dz(2); crust.dz(2); crust.dz(3:end)];
crust.z =  [0; crust.z(1) ; crust.z(1) ; crust.z(2) ; crust.z(2) ; crust.z(3:end) ];
crust.vp = [crust.vp(1); crust.vp(1); crust.vp(2); crust.vp(2); crust.vp(3:end); crust.vp(end)];
crust.vs = [crust.vs(1); crust.vs(1); crust.vs(2); crust.vs(2); crust.vs(3:end); crust.vs(end)];
crust.rho = [crust.rho(1); crust.rho(1); crust.rho(2); crust.rho(2); crust.rho(3:end); crust.rho(end)];

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

Imod = z <= zmax;
z = z(Imod);
vsv = vsv(Imod);
vsh = vsh(Imod);

%% Get Vp and Density values from MINEOS card
vpvs = 0.5*(ncard.vpv+ncard.vph) ./ (0.5*(ncard.vsv+ncard.vsh));
vpvs_int = interp1(ncard.z+(1:length(ncard.z))'*1e-10,vpvs,z);
rho_int = interp1(ncard.z+(1:length(ncard.z))'*1e-10,ncard.rho,z);
vpv = vpvs_int .* vsv;
vph = vpvs_int .* vsh;
rho = rho_int;

%% Paste crust2.0 on top
vsv = [crust.vs; vsv(1); vsv] * 1000;
vsh = [crust.vs; vsh(1); vsh] * 1000;
vpv = [crust.vp; vpv(1); vpv] * 1000;
vph = [crust.vp; vph(1); vph] * 1000;
rho = [crust.rho; rho(1); rho];
z = [crust.z; max(crust.z); z];

%% Plot
figure(1); clf;
box on; hold on;
plot(vsv,z,'-k','linewidth',2);
plot(vsh,z,'-r','linewidth',2);
legend('V_{SV}','V_{SH}','location','southwest');
xlabel('Vs (km/s)');
ylabel('Depth (km)');
set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse');

%% Make Card
ocard = ncard;

I = find(ncard.z < max(z));
ocard.z(I) = []; ocard.z = [ocard.z; flip(z)];
ocard.rad = [] ;ocard.rad = (6371-ocard.z)*1000;
ocard.rho(I) = []; ocard.rho = [ocard.rho; flip(rho)];
ocard.vpv(I) = []; ocard.vpv = [ocard.vpv; flip(vpv)];
ocard.vph(I) = []; ocard.vph = [ocard.vph; flip(vph)];
ocard.vsv(I) = []; ocard.vsv = [ocard.vsv; flip(vsv)];
ocard.vsh(I) = []; ocard.vsh = [ocard.vsh; flip(vsh)];

eta = interp1(ncard.z+(1:length(ncard.z))'*1e-10,ncard.eta,z);
eta(1) = ncard.eta(end);
qkap = interp1(ncard.z+(1:length(ncard.z))'*1e-10,ncard.qkap,z);
qkap(1) = ncard.qkap(end);
qmu = interp1(ncard.z+(1:length(ncard.z))'*1e-10,ncard.qmu,z);
qmu(1) = ncard.qmu(end);

ocard.eta(I) = []; ocard.eta = [ocard.eta; flip(eta)];
ocard.qkap(I) = []; ocard.qkap = [ocard.qkap; flip(qkap)];
ocard.qmu(I) = []; ocard.qmu = [ocard.qmu; flip(qmu)];

%% Write card

write_MINEOS_mod(ocard,ocard_name);

%% Plot final card
figure(2); clf;
box on; hold on;
subplot(1,5,1);
plot(ocard.vsv,ocard.z,'-k','linewidth',2);
plot(ocard.vsh,ocard.z,'-r','linewidth',2);
legend('V_{SV}','V_{SH}','location','southwest');
xlabel('Vs (km/s)');
ylabel('Depth (km)');
set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse');
ylim([0 400]);
subplot(1,5,2);
plot(ocard.vpv,ocard.z,'-k','linewidth',2);
plot(ocard.vph,ocard.z,'-r','linewidth',2);
legend('V_{PV}','V_{PH}','location','southwest');
xlabel('Vp (km/s)');
ylabel('Depth (km)');
set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse');
ylim([0 400]);
subplot(1,5,3);
plot(ocard.rho,ocard.z,'-k','linewidth',2);
xlabel('\rho');
ylabel('Depth (km)');
set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse');
ylim([0 400]);
subplot(1,5,4);
plot(ocard.eta,ocard.z,'-k','linewidth',2);
xlabel('\eta');
ylabel('Depth (km)');
set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse');
ylim([0 400]);
subplot(1,5,5);
plot(ocard.qkap,ocard.z,'-k','linewidth',2); hold on;
plot(ocard.qmu,ocard.z,'-r','linewidth',2);
xlabel('Q');
ylabel('Depth (km)');
set(gca,'fontsize',15,'linewidth',1.5,'ydir','reverse');
ylim([0 400]);
xlim([0 1500]);



