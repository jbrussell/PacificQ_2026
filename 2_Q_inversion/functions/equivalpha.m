function [clro] = equivalpha(clr,alpha)
% Determine equivalent RGB color for input of a given alpha on top of white
%
clrbg = [1 1 1];
r2=clrbg(1); g2=clrbg(2); b2=clrbg(3);
r1=clr(1); g1=clr(2); b1=clr(3);

% If you have RGBA1 over RGB2, the effective visual result RGB3 will be:
r3 = r2 + (r1-r2)*alpha;
g3 = g2 + (g1-g2)*alpha;
b3 = b2 + (b1-b2)*alpha;

clro = [r3 g3 b3];

end

