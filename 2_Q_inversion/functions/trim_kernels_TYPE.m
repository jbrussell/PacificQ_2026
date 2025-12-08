function [ ofrech ] = trim_kernels_TYPE( frech, bot )
% Truncate spheroidal and toroidal kernels at the bottom of the model space
% making them the same length.
%
ofrech = frech;

if ~isempty(frech)
    for iper = 1:length(frech)
        flds = fieldnames(frech);
        I_model = frech(iper).z <= bot;
        for ifld = 1:length(flds)
            if length(frech(iper).(flds{ifld}))==1 || isempty(frech(iper).(flds{ifld}))
                continue
            end
            ofrech(iper).(flds{ifld}) = frech(iper).(flds{ifld})(I_model);
        end
    end
end

end

