function [ bootstrap ] = collect_models( mat )
% Interpolate all models in mat structure to a common knots so that we can
% do statistics on the enseble


% Get reference depth profile to interpolate all models to common knots
bot_km = mat(1,1).results.param.bot;
cardref = mat(1,1).results.card{end};
Iinterp = find(cardref.z<bot_km & ...
               cardref.vsv~=0);
zint = cardref.z(Iinterp);
zint = zint + (1:length(zint))'*1e-10;

bootstrap.cardref = cardref;
bootstrap.Iinterp = Iinterp;

% Loop through models and interpolate to common knots
ii = 0;
model_idx = [];
for imod = 1:size(mat,1)
    for ibs = 1:size(mat,2)
        ii = ii + 1;
        card = mat(imod,ibs).results.card{end};
        
        % Find depth to interpolate over
        bot_km = mat(imod,ibs).results.param.bot;
        Iinterp = find(card.z<bot_km & ...
                       card.vsv~=0);
        Ih20 = find(card.vpv==1500 & card.vsv==0);
        I_bot = Iinterp(1);
        
        flds = fields(card);
        for ifld = 1:length(flds)
            fld = flds{ifld};
            if strcmp(fld,'fname') || strcmp(fld,'z') || strcmp(fld,'rad')
                continue
            end
            v = card.(fld)(Iinterp);
            z = card.z(Iinterp);
            z = z+(1:length(z))'*1e-10;
            z(1)=zint(1); z(end)=zint(end);
            vint = interp1(z,v,zint);
        %     ocard.(fld)(I_bot:I_moho) = vint;
            card.(fld) = [card.(fld)(1:I_bot-1); vint(:); card.(fld)(Ih20:end)];
            
            % Build bootstrap structure
            bootstrap.models.(fld)(:,ii) = vint(:);
        end
        bootstrap.models.z(:,ii) = zint(:);
        card.z = [card.z(1:I_bot-1); zint(:); card.z(Ih20:end)];
        card.rad = [card.rad(1:I_bot-1); (6371-zint(:))*1000; card.rad(Ih20:end)];
        
        % Gather dispersion measurements
        forward = mat(imod,ibs).results.forward{end};
        flds = fields(forward);
        for ifld = 1:length(flds)
            fld = flds{ifld};
            bootstrap.disp.(fld)(:,ii) = forward.(fld);
        end
        
        model_idx(:,ii) = imod*ones(size(vint(:)));
    end
end
bootstrap.model_idx = model_idx;


end

