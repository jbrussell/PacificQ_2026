% Function version of Run Minos Bran
% Original version is name run_minos.m
%
%
% NJA, 2014
%
% Changed 8/2014 to use only one run file for spheroidal (instead of 6
% separate)
%
% 9/2014 modified to run codes out of the run directory
%
% 10/27/2014 Modified to return status of nohang commands
%
% 1/30/2015 modifed to use q corrected phae velocities and allow choice to
% run mineos strip and table
%
% 10/24/2016 JBR - Check that all eigenfrequencies are calculated and, if
% not, restart mineos where left off

function [status_S,status_T] = frun_mineos_check(CARD,runtable)

setup_parameters;
RUNPATH = param.RUNPATH;
DATAPATH = param.DATAPATH;
BINPATH = param.BINPATH;

% % Turn on if only want to calculate S or T
% SONLY = 0;
% TONLY = 1;

% Check to see if run directory exists and create it if not

if exist('run','dir') ~= 7
    mkdir('run');
end

% Set path to executables
% set_mineos_path;

% Change environment variables to deal with gfortran
setenv('GFORTRAN_STDIN_UNIT', '5') 
setenv('GFORTRAN_STDOUT_UNIT', '6') 
setenv('GFORTRAN_STDERR_UNIT', '0')
setenv('DYLD_LIBRARY_PATH', '/usr/local/bin:/opt/local/lib:')

%% Run Spheroidal Branches First
disp('---- Calculate Spheroidal Mode Set 1 ----')
TYPE = 'S';

num_loop = 0;
ll = [];

% Write out run files -- be sure that paths are correct!
write_mineos_drivers(TYPE,CARD);

% mineos_nohang for s1-s5
disp('Running mineos_nohang S');
tic
LOG = [CARDTABLE,'logS',num2str(num_loop)];
com = ['cat ',RUNPATH,'run_nohang.s | ',BINPATH,'mineos_nohang > ',LOG];
% tic
[status_S(1),log] = system(com);
% log

if status_S(1) ~= 0     
    disp( 'something is wrong at mineos_nohang S')
    return
end

% CHECK THAT ALL EIGENFREQUENCIES WERE CALCULATED, AND IF NOT, RESTART
TYPEID = param.SID;
com = ['cat ',DATAPATH,CARD,'.',TYPEID,'.asc > ',DATAPATH,CARD,'.',TYPEID,'_',num2str(num_loop),'.asc'];
[status,log] = system(com);
com = ['cat ',DATAPATH,CARD,'.',TYPEID,'.eig > ',DATAPATH,CARD,'.',TYPEID,'_',num2str(num_loop),'.eig'];
[status,log] = system(com);
l_start = check_mode(LOG,num_loop,0,TYPE,CARD); % Check that all eigenfrequencies were calculated
mode_chk = l_start;
while ~isnan(mode_chk)
    num_loop = num_loop + 1;
    ll = [ll; l_start];
    system(['rm ',RUNPATH,'run_nohang.s']);
    write_mode_in(l_start,num_loop,TYPE); % Build new mode.in file starting from last successful w,l
    write_chk_mineos_nohang(TYPE,CARD,num_loop);

%     disp(['--- Rerunning mineos_nohang: LOOP ',num2str(num_loop),' ---']);
%     disp(['Starting at l = ',num2str(l_start)]);
%     tic
    LOG = [DATAPATH,'logS',num2str(num_loop)];
    com = ['cat ',RUNPATH,'run_nohang.s | ',BINPATH,'mineos_nohang > ',LOG];
    [status,log] = system(com);

    if status ~= 0     
        disp( 'something is wrong at mineos_nohang S loop')
        break;
    end
%     toc

    l_start_prev = l_start;
    l_start = check_mode(LOG,num_loop,l_start_prev,TYPE,CARD); % Check that all eigenfrequencies were calcualted 

    mode_chk = l_start;
    %        pause;
end
toc

% eig_recover
if ~isempty(ll)
    disp(['Running eig_recover for ',num2str(num_loop),' files'])
    for i = 1:num_loop
        disp(['file ',num2str(i),' ...']);
        write_eig_recov(i-1,ll(i)-1,TYPE,CARD);
        com = ['cat ',RUNPATH,'run_eigrecov.s | ',BINPATH,'eig_recover'];
        [status log] = system(com);
        if status ~= 0     
            disp( 'something is wrong at eig_recover S')
            break;
        end
    end
    com = ['cat ',CARDTABLE,CARD,'.',TYPEID,'_',num2str(i),'.eig > ',CARDTABLE,CARD,'.',TYPEID,'_',num2str(i),'.eig_fix'];
    [status,log] = system(com);     


    % WRITE DRIVERS
    write_chk_q_strip_table(num_loop,TYPE,CARD);
end


% disp('---- Calculate Spheroidal Mode Set 2 ----')
% com = ['cat ',RUNPATH,'run_nohang2.s | mineos_nohang'];
% [status_S(2),log] = system(com);
% toc

% Check to make sure nothing got hung up
% disp('Checking for Stuck Eigenfrequencies')

% check_eigen('S');

% % mineos_q
% disp('Running mineos_q');
% com = ['cat ',RUNPATH,'run_q.s | mineos_q'];
disp('Running mineos_qcorrectphv');
com = ['cat ',RUNPATH,'run_q.s | ',BINPATH,'mineos_qcorrectphv'];
[status,log] = system(com);
if status ~= 0     
    disp( 'something is wrong at mineos_qcorrectphv S')
    return;
end

% 
if runtable == 1
    % mineos_strip
    disp('Running mineos_strip');
    com = ['cat ',RUNPATH,'run_strip.s | ',BINPATH,'mineos_strip'];
    [status,log] = system(com);
    if status ~= 0     
        disp( 'something is wrong at mineos_strip S')
        return;
    end

    % mineos_table
    disp('Running mineos_table');
    com = ['cat ',RUNPATH,'run_table.s | ',BINPATH,'mineos_table'];
    [status,log] = system(com);
    if status ~= 0     
        disp( 'something is wrong at mineos_table S')
        return;
    end

end

%% Run toroidal branches next
disp('---- Calculate Toroidal Modes ----')
TYPE = 'T';

num_loop = 0;
ll = [];
    
% Write out run files -- be sure that paths are correct!
write_mineos_drivers(TYPE,CARD);

% mineos_nohang
disp('Running mineos_nohang T');
tic
LOG = [CARDTABLE,'logT',num2str(num_loop)];
com = ['cat ',RUNPATH,'run_nohang.t | ',BINPATH,'mineos_nohang > ',LOG];
[status_T,log] = system(com);
if status_T ~= 0     
    disp( 'something is wrong at mineos_nohang T')
    return
end

% CHECK THAT ALL EIGENFREQUENCIES WERE CALCULATED, AND IF NOT, RESTART
TYPEID = param.TID;
com = ['cat ',CARDTABLE,CARD,'.',TYPEID,'.asc > ',CARDTABLE,CARD,'.',TYPEID,'_',num2str(num_loop),'.asc'];
[status,log] = system(com);
com = ['cat ',CARDTABLE,CARD,'.',TYPEID,'.eig > ',CARDTABLE,CARD,'.',TYPEID,'_',num2str(num_loop),'.eig'];
[status,log] = system(com);
l_start = check_mode(LOG,num_loop,0,TYPE,CARD); % Check that all eigenfrequencies were calculated
mode_chk = l_start;
while ~isnan(mode_chk)
    num_loop = num_loop + 1;
    ll = [ll; l_start];
    system(['rm ',RUNPATH,'run_nohang.t']);
    write_mode_in(l_start,num_loop,TYPE); % Build new mode.in file starting from last successful w,l
    write_chk_mineos_nohang(TYPE,CARD,num_loop);

%     disp(['--- Rerunning mineos_nohang: LOOP ',num2str(num_loop),' ---']);
%     disp(['Starting at l = ',num2str(l_start)]);
%     tic
    LOG = [CARDTABLE,'logT',num2str(num_loop)];
    com = ['cat ',RUNPATH,'run_nohang.t | ',BINPATH,'mineos_nohang > ',LOG];
    [status,log] = system(com);

    if status ~= 0     
        disp( 'something is wrong at mineos_nohang T loop')
        break;
    end
%     toc

    l_start_prev = l_start;
    l_start = check_mode(LOG,num_loop,l_start_prev,TYPE,CARD); % Check that all eigenfrequencies were calcualted 

    mode_chk = l_start;
    %        pause;
end
toc

    % eig_recover
if ~isempty(ll)
    disp(['Running eig_recover for ',num2str(num_loop),' files'])
    for i = 1:num_loop
        disp(['file ',num2str(i),' ...']);
        write_eig_recov(i-1,ll(i)-1,TYPE,CARD);
        com = ['cat ',RUNPATH,'run_eigrecov.t | ',BINPATH,'eig_recover'];
        [status log] = system(com);
        if status ~= 0     
            disp( 'something is wrong at eig_recover T')
            break;
        end
    end
    com = ['cat ',CARDTABLE,CARD,'.',TYPEID,'_',num2str(i),'.eig > ',CARDTABLE,CARD,'.',TYPEID,'_',num2str(i),'.eig_fix'];
    [status,log] = system(com);     


    % WRITE DRIVERS
    write_chk_q_strip_table(num_loop,TYPE,CARD);
end

% mineos_qcorrectphv
disp('Running mineos_qcorrectphv');
com = ['cat ',RUNPATH,'run_q.t | ',BINPATH,'mineos_qcorrectphv'];
[status,log] = system(com);
if status ~= 0     
    disp( 'something is wrong at mineos_qcorrectphv T')
    return;
end
 
if runtable == 1
    % mineos_strip
    disp('Running mineos_strip');
    com = ['cat ',RUNPATH,'run_strip.t | ',BINPATH,'mineos_strip'];
    [status,log] = system(com);
    if status ~= 0 
        disp( 'something is wrong at mineos_strip T')
        return;
    end

    % mineos_table
    disp('Running mineos_table');
    com = ['cat ',RUNPATH,'run_table.t | ',BINPATH,'mineos_table'];
    [status,log] = system(com);
    if status ~= 0     
        disp( 'something is wrong at mineos_table T')
        return;
    end
end

% Change the environment variables back to the way they were
setenv('GFORTRAN_STDIN_UNIT', '-1') 
setenv('GFORTRAN_STDOUT_UNIT', '-1') 
setenv('GFORTRAN_STDERR_UNIT', '-1')
