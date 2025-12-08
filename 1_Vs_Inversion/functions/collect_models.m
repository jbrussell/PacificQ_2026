function [ bootstrap ] = collect_models( mat )
% organize models in order to do statistics on the ensemble

% Loop through models and interpolate to common knots
for ibs = 1:length(mat)
    card = mat(ibs).card;

    flds = fields(card);
    for ifld = 1:length(flds)
        fld = flds{ifld};
        if strcmp(fld,'fname') || strcmp(fld,'z') || strcmp(fld,'rad')
            continue
        end

        % Build bootstrap structure
        bootstrap.models.(fld)(:,ibs) = card.(fld);
    end
    bootstrap.models.z(:,ibs) = card.z;
    bootstrap.models.rad(:,ibs) = card.rad;

    % Gather dispersion measurements
    bootstrap.disp.periods(:,ibs) = mat(1).periods;
    bootstrap.disp.cpre(:,ibs) = mat(ibs).cpre;
    bootstrap.disp.chi2(:,ibs) = mat(ibs).chi2;
end


end

