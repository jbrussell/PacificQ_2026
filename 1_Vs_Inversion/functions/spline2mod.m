function [mod_out] = spline2mod(modsp,vs_sp,vp_vs,rho_vs,zmin)

% Check for Q field
isQ = isfield(modsp,'Qs');

dz = [diff(modsp.z(:)); 0];
z = modsp.z;

vp = vp_vs .* vs_sp; vp(vs_sp<0.01)=1.5;
% rho = vp / 2.5; rho(1)=1.03;
rho = rho_vs .* vs_sp; rho(vs_sp<0.01)=1.03;

if isQ
    Qp = modsp.Qp;
    Qs = modsp.Qs;
end

idisc = find(dz(1:end-1) == 0);
dz(idisc) = [];
vp(idisc) = [];
vs_sp(idisc) = [];
rho(idisc) = [];
if isQ
    Qp(idisc) = [];
    Qs(idisc) = [];
end
z(idisc) = [];

% I = find(vs_sp>0);
I = find(z==zmin);
dzshift = dz(I(1))/2;
dz(I(1)) = dz(I(1)) - dzshift;
dz(end-1) = dz(end-1) + dzshift;

% refmod_sp = [dz mod_ref.vp vs_ref mod_ref.rho];
mod_out = [dz vp vs_sp rho];
if isQ
    mod_out = [mod_out Qp Qs];
end

end

