function [ ofrech_T,ofrech_S,oforward ] = organize_kernels( frech_T, frech_S, forward, data )
% Organize kernels such that only necessary frequencies are used.

% Initialize
oforward = [];
ofrech_T = [];
ofrech_S = [];

tol = 1e-6;
% Ensure that toroidal kernel frequencies match data
if ~isempty(frech_T)
    T_periods = data.love.periods_iso;
    ii = 0;
    for iT = 1:length(frech_T)
        if ismembertol(frech_T(iT).per,T_periods,tol)
            ii = ii + 1;
            iT_save(ii) = iT;
        end
    end
    ofrech_T = frech_T(iT_save);
    oforward.tphv = forward.tphv(iT_save);
    oforward.tper = forward.tper(iT_save);
    oforward.tphvq = forward.tphvq(iT_save);
    oforward.tperq = forward.tperq(iT_save);
    if length(ofrech_T) ~= length(T_periods)
        error('Number of kernels does not match number of data')
    end
end

% Ensure that spheroidal kernel frequencies match data
if ~isempty(frech_S)
    S_periods = data.rayl.periods_iso;
    ii = 0;
    for iS = 1:length(frech_S)
        if ismembertol(frech_S(iS).per,S_periods,tol)
            ii = ii + 1;
            iS_save(ii) = iS;
        end
    end
    ofrech_S = frech_S(iS_save);
    oforward.sphv = forward.sphv(iS_save);
    oforward.sper = forward.sper(iS_save);
    oforward.sphvq = forward.sphvq(iS_save);
    oforward.sperq = forward.sperq(iS_save);
    if length(ofrech_S) ~= length(S_periods)
        error('Number of kernels does not match number of data')
    end
end

end

