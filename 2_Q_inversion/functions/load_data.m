function [ odata ] = load_data( param  )
% Load the data structure and check that periods are decreasing.
%
max_per_love = param.max_per_love;
path2data = param.data;
temp = load(path2data);
ndata = temp.data;
odata = ndata;

% Loop through Rayleeigh and Love waves
datatypes = fields(ndata);
for idt = 1:length(datatypes)
    % Make sure periods are decreasing
    [~,Isort] = sort(ndata.(datatypes{idt}).periods_iso,'descend');
    flds = fields(ndata.(datatypes{idt}));
    for ifld = 1:length(flds)
        if length(ndata.(datatypes{idt}).(flds{ifld})) ~= length(Isort)
            [~,Isort] = sort(ndata.(datatypes{idt}).periods_ani,'descend');
        end
        odata.(datatypes{idt}).(flds{ifld}) = ndata.(datatypes{idt}).(flds{ifld})(Isort);
    end
end

% Remove longer period love waves with kernel bulge
if ~isempty(max_per_love) && isfield(odata,'love')
    I_save = odata.love.periods_iso <= param.max_per_love;
    flds = fields(odata.love);
    for ifld = 1:length(flds)
        odata.love.(flds{ifld}) = odata.love.(flds{ifld})(I_save);
    end
end

if param.is_err2sigma % are errors in data structure 2-sigma?
    fldsRL = fields(odata);
    for irl = 1:length(fldsRL)
        fldRL = fldsRL{irl};
        flds = fields(odata.(fldRL));
        Ierr = find(contains(flds,'err'));
        for ifld = 1:length(Ierr)
            fld_err = flds{Ierr(ifld)};
            odata.(fldRL).(fld_err) = odata.(fldRL).(fld_err)/2;
        end
    end
end

end

