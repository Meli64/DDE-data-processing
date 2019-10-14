%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lcmodel.m
%
% main program for LCModel analysis

%function lcmodel()

lcmodelflag=1;
include_MM_flag=1;
plotrawflag=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFINITION OF PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% UPDATE SAVE DIRECTORY & FILE NAMES
PathName='';

%list of phi value. /!\Here,20 designates the signal for phi=0° et b=0.02ms/µm² 
phi_tag=[20 0 45 90 135 180 225 270 315 360];

for i=1:length(phi_tag)
   
    phi_value=num2str(phi_tag(i));

    FileName=strcat('phi', phi_value, 'fid_asc');

    currentdir=pwd;

    % define acquisition parameters

    acqparam=struct('nbpoints',0,'sw_hz',0,'hzpppm',0,'receiveroffset_ppm',0);
    acqparam.nbpoints=4096;             % number of complex points 
    acqparam.sw_hz=5000;               % spectral width in hz
    acqparam.hzpppm=500.3;             % hertz per ppm
    acqparam.receiveroffset_ppm=4.65;   % position of receiver offset in data (after lsfrq)
    % (must be 4.65ppm for LCModel)

    % define processing parameters

    procparam=struct('lsfrq',0,'rp',0,'lp',0,'lb',0,'gf',0,'sifactor',0,'lsfid',0,'volume',0);
    procparam.lsfrq=0;      % frequency shift parameter (in hz)
    procparam.rp=0;        % zero order phase parameter
    procparam.lp=0;         %  linear phase parameter
    procparam.lb=0;
    procparam.gf=100000;
    procparam.sifactor=1;
    procparam.lsfid=0;
    procparam.volume=1.0;

    % define directories (all directory names must end by '/')

    files=struct('lcmodelprogramsdir',0,'lcmodelbasisdir',0,'lcmodeldatadir',0,'vnmrdatafilename',0,'lcmodelbasisfilename',0,'lcmodeldatafilename',0,'lcmodeldatafilenameext',0);
    files.lcmodelprogramsdir=currentdir;
    files.lcmodelbasisdir=[currentdir '']; %update basis set directory
    files.lcmodelbasisfilename='SE_DDE_30_25'; %basis set file name
    files.lcmodeldatadir=PathName;
    files.lcmodeldatafilename=FileName;
    name_of_ctrl='ctrl_mouse_DDE';

    % define file names

    files.vnmrdatafilename='xxx';          % vnmr time domain data to be analyzed

    files.lcmodeldatafilenameext=[];                    % LCModel file name extension (used for time course analysis)

    % define flags

    if exist([files.lcmodelbasisdir files.lcmodelbasisfilename '.BASIS'])
        makebasisflag=0;
    else
        makebasisflag=1;                    % 1=rebuild .BASIS file / 0=use existing .BASIS file
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % START PROGRAM
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    % display directories to check
    fprintf('\n***** FILES AND DIRECTORIES FOR LCMODEL ANALYSIS *****\n\n')
    fprintf(['lcmodelprogramsdir=' files.lcmodelprogramsdir '\n']);
    fprintf(['lcmodelbasisdir=' files.lcmodelbasisdir '\n']);
    fprintf(['lcmodeldatadir=' files.lcmodeldatadir '\n']);
    fprintf(['vnmrdatafilename=' files.vnmrdatafilename '\n']);
    fprintf(['lcmodelbasisfilename=' files.lcmodelbasisfilename '\n']);


    % copy .BASIS file to data directory

    cd(files.lcmodelbasisdir);
    if (makebasisflag==1)
        disp(['Make Basis']);
        unix(['~/.lcmodel/bin/makebasis < ' files.lcmodelbasisfilename '.IN']);
    end
    disp(['Executing UNIX command: ' 'cp ' files.lcmodelbasisfilename '.BASIS ' files.lcmodeldatadir]);
    unix(['\cp ' files.lcmodelbasisfilename '.BASIS ' files.lcmodeldatadir]);
    cd(files.lcmodelprogramsdir);

    % start LCModel Analysis

    fprintf('\n***** STARTING LCMODEL ANALYSIS *****\n');

    i=1;
    ['load ' files.lcmodeldatadir files.lcmodeldatafilename]
    eval(['load ' files.lcmodeldatadir files.lcmodeldatafilename])
    fid_to_fit=eval(files.lcmodeldatafilename);


    eval([name_of_ctrl '(files,fid_to_fit,acqparam,procparam,include_MM_flag)']);

    cd(files.lcmodeldatadir)

    % execute PlotRaw
    if (plotrawflag==1)
        disp(['Executing UNIX command: ' 'PlotRaw.EXE < ' files.lcmodeldatafilename  files.lcmodeldatafilenameext '.PLOTIN']);
        unix(['~/.lcmodel/bin/plotraw < ' files.lcmodeldatafilename files.lcmodeldatafilenameext '.PLOTIN']);
        disp(['Executing UNIX command: ' 'gs ' files.lcmodeldatafilename  files.lcmodeldatafilenameext '.PS']);
        unix([ps_reader ' ' files.lcmodeldatafilename  files.lcmodeldatafilenameext '.PS']);
    end

    if (lcmodelflag==1)
        cd(files.lcmodeldatadir)
        disp(['Executing UNIX command: ' 'LCModel.EXE < ' files.lcmodeldatafilename  files.lcmodeldatafilenameext '.CONTROL']);
        tic
        unix(['~/.lcmodel/bin/lcmodel < ' files.lcmodeldatafilename files.lcmodeldatafilenameext '.CONTROL']);
        elapsedtime=toc;
        fprintf(['LCModel finished.\nElapsed time for LCModel analysis : ' num2str(elapsedtime/60,3) ' min\n\n']);
    end

    cd(files.lcmodeldatadir)


    cd(currentdir)

    fprintf('\n***** LCMODEL ANALYSIS IS DONE*****\n');


end
