function [ ofrech,oforward ] = organize_Qkernels_TYPE( frech, forward, data, TYPE )
% Organize kernels such that only necessary frequencies are used.

% Initialize
oforward = [];
ofrech_T = [];
ofrech_S = [];

tol = 1e-6;
if strcmp(TYPE,'T')
    % Ensure that toroidal kernel frequencies match data
    if ~isempty(frech)
        T_periods = data.love.periods_iso;
        ii = 0;
        for iT = 1:length(frech)
            if ismembertol(frech(iT).per,T_periods,tol)
                ii = ii + 1;
                iT_save(ii) = iT;
            end
        end
        ofrech_T = frech(iT_save);
        oforward.tq = forward.tq(iT_save);
        oforward.tqinv = forward.tqinv(iT_save);
        oforward.tper = forward.tper(iT_save);
        oforward.talpha = forward.talpha(iT_save);
        if length(ofrech_T) ~= length(T_periods)
            error('Number of kernels does not match number of data')
        end
    end
    ofrech = ofrech_T;
else

    % Ensure that spheroidal kernel frequencies match data
    if ~isempty(frech)
        S_periods = data.rayl.periods_iso;
        ii = 0;
        for iS = 1:length(frech)
            if ismembertol(frech(iS).per,S_periods,tol)
                ii = ii + 1;
                iS_save(ii) = iS;
            end
        end
        ofrech_S = frech(iS_save);
        oforward.sq = forward.sq(iS_save);
        oforward.sqinv = forward.sqinv(iS_save);
        oforward.sper = forward.sper(iS_save);
        oforward.salpha = forward.salpha(iS_save);
        if length(ofrech_S) ~= length(S_periods)
            error('Number of kernels does not match number of data')
        end
    end
    ofrech = ofrech_S;
end

end

