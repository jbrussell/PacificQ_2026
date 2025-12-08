function [card_v, z] = mod2knot_discs(mod_v,dz,discs)
% Convert from surf96 layered mod file to MINEOS style knots. This takes
% into account exact discontinuitites at depths specified in 'discs'

z = [0; cumsum(dz(1:end-1,1))];
if length(z) ~= length(mod_v)
    error('Something is wrong with the vector lengths');
end

% Insert exact discontinuities
card_v = mod_v;
for idisc = 1:length(discs)
    disc = discs(idisc);
    [~,Idisc] = min(abs(z-disc));
    if ismember(z(Idisc),discs(idisc~=[1:length(discs)]))
        disp('skipping redundant discontinuity');
        continue
    end
    z = [z(1:Idisc); z(Idisc); z(Idisc+1:end)];
    card_v = [card_v(1:Idisc-1); card_v(Idisc-1); card_v(Idisc:end)];
end

% Shift knots to coincide with midpoints of layer rather than edge
% (treats discontinuities as though they are already in correct place)
ddz = [0; diff(z)];
Idisc = find(ddz == 0);
Idisc = Idisc(Idisc~=1);
ddz(Idisc-1) = 0;
z = z + ddz/2;

end

