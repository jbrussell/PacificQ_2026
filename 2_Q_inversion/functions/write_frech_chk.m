% 10/7/15 -- Josh Russell
%
% Creates the input file for frechet when there are mutiple eigenfunction
% files.
%
function write_frech_chk(TYPE,CARD,NDISC,ZDISC)


setup_parameters;
SID = param.SID;
TID = param.TID;
CARDPATH  = param.CARDPATH;
TABLEPATH = param.TABLEPATH;
% FRECHETPATH  = param.frechetpath;
DATAPATH = param.DATAPATH;
% CARD = CARDID;
RUNPATH = param.RUNPATH;
% CARD = param.CARD;
CARDID = param.CARDID;
% Set number of discontinuities to add
if NDISC > 0
    
    if length(ZDISC) > NDISC
        disp('Mismatch in discontinuity depths!')
    end
end

if strcmp(TYPE,'T') == 1
    disp('Toroidal!');
    
    RUNFILE = 'run_frechet.t';
    TYPEID = TID;

    
elseif strcmp(TYPE,'S') == 1
    disp('Spheroidal!');
    
    RUNFILE = 'run_frechet.s';
    TYPEID = SID;
    
else
    disp('No TYPE recognized!');
    
end

EIG0 = [CARDTABLE,CARD,'.',TYPEID,'_0.eig_fix'];
QMOD = [CARDPATH,CARDID,'.qmod'];
BRANCH = [CARDTABLE,CARD,'.',TYPEID,'.table_hdr.branch'];
% FRECH = [FRECHETPATH,CARDID,'.',TYPEID,'.frech'];
FRECH = [DATAPATH,CARD,'.',TYPEID,'.frech'];

com = ['ls ',CARDTABLE,CARD,'.',TYPEID,'_*.eig_fix | cat'];
[status eig_fils] = system(com);
EIG = strsplit(eig_fils,'\n');

% Check to see if file exists ... program will not overwrite it if it does
if exist(FRECH,'file') == 2
    disp([FRECH,' File exists! Removing it now'])
    com = ['rm -f ',FRECH];
    [status,log] = system(com);
end


fid = fopen(RUNFILE,'w');
fprintf(fid,'%s\n',QMOD);
fprintf(fid,'%s\n',BRANCH);
fprintf(fid,'%s\n',FRECH);
fprintf(fid,'%s\n',EIG0);
fprintf(fid,'%i\n',NDISC);
for i = 2:size(EIG,2)-1 % skip *_0.eig_fix and start at *_1.eig_fix
    disp(['Using eig file ',num2str(i-1)])
    fprintf(fid,'%s\n',EIG{i});
end
fprintf(fid,'\n');
fclose(fid);
    
% Move run files to run directory
com = ['mv run_frechet.? ',RUNPATH,'.'];
[status,log] = system(com);
    