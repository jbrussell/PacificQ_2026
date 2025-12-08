function [ bootstrap ] = get_stats( bootstrap )
% Calculate mean and confidence intervals of model ensemble

flds = fields(bootstrap.models);
for ifld = 1:length(flds)
    fld = flds{ifld};
    % median
    bootstrap.stats.(fld).median = nanmedian(bootstrap.models.(fld),2);
    % 95-confidence
    bootstrap.stats.(fld).u95 = prctile(bootstrap.models.(fld),97.5,2);
    bootstrap.stats.(fld).l95 = prctile(bootstrap.models.(fld),2.5,2);
    % 68-confidence
    bootstrap.stats.(fld).u68 = prctile(bootstrap.models.(fld),16,2);
    bootstrap.stats.(fld).l68 = prctile(bootstrap.models.(fld),84,2);
end

flds = fields(bootstrap.disp);
for ifld = 1:length(flds)
    fld = flds{ifld};
    % median
    bootstrap.stats.(fld).median = nanmedian(bootstrap.disp.(fld),2);
    % 95-confidence
    bootstrap.stats.(fld).u95 = prctile(bootstrap.disp.(fld),97.5,2);
    bootstrap.stats.(fld).l95 = prctile(bootstrap.disp.(fld),2.5,2);
    % 68-confidence
    bootstrap.stats.(fld).u68 = prctile(bootstrap.disp.(fld),16,2);
    bootstrap.stats.(fld).l68 = prctile(bootstrap.disp.(fld),84,2);
end


end

