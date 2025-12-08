function [ ofrech_T, ofrech_S ] = trim_kernels( frech_T, frech_S, param )
% Truncate spheroidal and toroidal kernels at the bottom of the model space
% making them the same length.
%
bot = param.bot;
ofrech_T = frech_T;
ofrech_S = frech_S;

if ~isempty(frech_T)
    for iper = 1:length(frech_T)
        flds = fieldnames(frech_T);
        I_model = frech_T(iper).z <= bot;
        for ifld = 1:length(flds)
            if length(frech_T(iper).(flds{ifld}))==1
                continue
            end
            ofrech_T(iper).(flds{ifld}) = frech_T(iper).(flds{ifld})(I_model);
        end
    end
end

if ~isempty(frech_S)
    for iper = 1:length(frech_S)
        flds = fieldnames(frech_S);
        I_model = frech_S(iper).z <= bot;
        for ifld = 1:length(flds)
            if length(frech_S(iper).(flds{ifld}))==1
                continue
            end
            ofrech_S(iper).(flds{ifld}) = frech_S(iper).(flds{ifld})(I_model);
        end
    end
end

end

