function [out] = load_QRFSI12_profile(pathQRFSI12,lat,lon)

%% Load files and construct mat file
temp = load(pathQRFSI12);
qrfsi12 = temp.qrfsi12;

%% Find value closest lat, lon in array

[~,Ilat] = min(abs(lat-qrfsi12.lat(1,:,1)));
[~,Ilon] = min(abs(lon-qrfsi12.lon(:,1,1)));
out.Qinv = squeeze(qrfsi12.Qinv(Ilon,Ilat,:));
out.z = qrfsi12.z;

end

