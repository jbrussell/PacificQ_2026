% Read Vsv models from Nishimura & Forsyth (1989)

function nf89 = load_NF89_vs(path2nf89)

tables = dir([path2nf89,'/*.in']);

age_ranges = [[0 4];
              [4 20];
              [20 52];
              [52 110];
              [110 nan];
              ];

for ii = 1:length(tables)
    data = csvread([path2nf89,'/',tables(ii).name],2,0);
    nf89(ii).z = data(:,1);
    nf89(ii).vsv = data(:,3);
    nf89(ii).xi = data(:,4);
    nf89(ii).age = age_ranges(ii,:);
    
    vs = nf89(ii).vsv .* sqrt((2 + nf89(ii).xi)/3);
    nf89(ii).vs = vs;
end

