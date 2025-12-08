% Read Rayleigh-wave dispersion data from Nishimura & Forsyth (1989)

function nf89 = load_NF89_R(path2nf89)

data = load(path2nf89);

age_ranges = [[0 4];
              [4 20];
              [20 52];
              [52 110];
              [110 nan];
              ];

for ii = 1:size(data,2)-1
    nf89(ii).periods = data(:,1);
    nf89(ii).phv = data(:,ii+1);
    nf89(ii).age = age_ranges(ii,:);
end

