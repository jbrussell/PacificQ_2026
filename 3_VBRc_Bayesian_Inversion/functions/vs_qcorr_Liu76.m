function [vs_q] = vs_qcorr_Liu76(vs,q,freq,fref_hz)
    %
    % Correct velocities for physical dispersion following:
    % Liu, H. P., Anderson, D. L. and Kanamori, H., Velocity dispersion due to
    % anelasticity: implications for seismology and mantle composition,
    % Geophys. J. R. Astron. Soc., vol. 47, pp. 41-58 (1976)
    %
    % jbrussell 5/3/2022

    w = 2*pi*freq;
    w_ref = 2*pi*fref_hz;
    vs_q = vs(:) .* ( 1 + 1./(pi.*q(:)) .* log(w./w_ref) );

end
