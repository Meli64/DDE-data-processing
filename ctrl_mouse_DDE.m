%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% createlcmodel1Hinput.m
%
% prepare .RAW and .CONTROL file for LCModel
%
% pgh Sep 2001
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT PARAMETERS :
%   files : structure containing the filenames
%   fid : two-column vector containing real and imaginary part of fid
%   acqparam : structure containing acquisition parameters
%   procparam : structure containing processing parameters
% OUTPUT PARAMETERS : 
%   none
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=createlcmodel1Hinput(files,fid_to_fit,acqparam,procparam,include_MM_flag)

fprintf('\n***** CREATING INPUT FILES (.RAW and .CONTROL) FOR LCMODEL *****\n');

% create .CONTROL file for LCModel

disp(['Writing ' files.lcmodeldatadir files.lcmodeldatafilename files.lcmodeldatafilenameext '.CONTROL'])

fileid=fopen([files.lcmodeldatadir files.lcmodeldatafilename files.lcmodeldatafilenameext '.CONTROL'],'w');

fprintf(fileid,' $LCMODL\n');
fprintf(fileid,[' TITLE=''' files.lcmodeldatafilename files.lcmodeldatafilenameext '''\n']);
fprintf(fileid,[' OWNER=''CEA - MIRCen''\n']);
fprintf(fileid,[' PGNORM=''US''\n']);
fprintf(fileid,[' FILPS=''' files.lcmodeldatafilename files.lcmodeldatafilenameext '.PS''\n']);
fprintf(fileid,[' FILCOO=''' files.lcmodeldatafilename files.lcmodeldatafilenameext '.COORD''\n']);
fprintf(fileid,[' FILCOR=''' files.lcmodeldatafilename files.lcmodeldatafilenameext '.CORAW''\n']);
fprintf(fileid,[' FILTAB=''' files.lcmodeldatafilename files.lcmodeldatafilenameext '.TABLE''\n']);



% Declare metabolites to observe (and sums if needed)

fprintf(fileid,' NCOMBI=4\n');
fprintf(fileid,[' CHCOMB(1)=''NAA+NAAG''\n']);
fprintf(fileid,[' CHCOMB(2)=''Glu+Gln''\n']);
fprintf(fileid,[' CHCOMB(3)=''GPC+PCho+Cho''\n']);
fprintf(fileid,[' CHCOMB(4)=''Cr+PCr''\n']);
fprintf(fileid,[' NAMREL=''Cr+PCr''\n']);
fprintf(fileid,' CONREL=8.00\n');
fprintf(fileid,' LPRINT=6\n');
fprintf(fileid,[' FILPRI=''' files.lcmodeldatafilename files.lcmodeldatafilenameext '.PRINT''\n']);
fprintf(fileid,' LCOORD=99\n');
fprintf(fileid,' NEACH=99\n');
fprintf(fileid,[' NAMEAC(1)=''Ala''\n']);
fprintf(fileid,[' NAMEAC(2)=''Asp''\n']);
fprintf(fileid,[' NAMEAC(3)=''Cho''\n']);
fprintf(fileid,[' NAMEAC(4)=''Cr''\n']);
fprintf(fileid,[' NAMEAC(5)=''GABA''\n']);
fprintf(fileid,[' NAMEAC(7)=''Gln''\n']);
fprintf(fileid,[' NAMEAC(8)=''Glu''\n']);
fprintf(fileid,[' NAMEAC(9)=''GPC''\n']);
fprintf(fileid,[' NAMEAC(10)=''GSH''\n']);
fprintf(fileid,[' NAMEAC(11)=''Ins''\n']);
fprintf(fileid,[' NAMEAC(12)=''Lac''\n']);
fprintf(fileid,[' NAMEAC(13)=''NAA''\n']);
fprintf(fileid,[' NAMEAC(14)=''NAAG''\n']);
fprintf(fileid,[' NAMEAC(15)=''PCho''\n']);
fprintf(fileid,[' NAMEAC(16)=''PCr''\n']);
fprintf(fileid,[' NAMEAC(18)=''sIns''\n']);
fprintf(fileid,[' NAMEAC(19)=''Tau''\n']);
fprintf(fileid,[' NAMEAC(20)=''MM_NEG''\n']);
fprintf(fileid,[' NAMEAC(21)=''Ace''\n']);
fprintf(fileid,[' NAMEAC(21)=''-CrCH2''\n']);


% Define metabolites ratio to guide the fit

fprintf(fileid,[' NRATIO=4\n']);

fprintf(fileid,[' CHRATO(1)=''PCho/GPC = 0.5 +- 0.01''\n']);
fprintf(fileid,[' CHRATO(2)=''Cho/GPC = 0 +- 0.01''\n']);
fprintf(fileid,[' CHRATO(3)=''sIns/Cr+PCr = 0.02 +- 0.02''\n']);
fprintf(fileid,[' CHRATO(4)=''Glu/NAA+NAAG= 0.48 +- 0.05''\n']);


% Contributions we want to avoid in the fit


fprintf(fileid,' NOMIT=11\n');
fprintf(fileid,[' CHOMIT(1)=''Gua''\n']);
fprintf(fileid,[' CHOMIT(2)=''MM20''\n']); 
fprintf(fileid,[' CHOMIT(3)=''MM12''\n']);
fprintf(fileid,[' CHOMIT(4)=''MM14''\n']);
fprintf(fileid,[' CHOMIT(5)=''MM17''\n']);
fprintf(fileid,[' CHOMIT(11)=''MM09''\n']);
fprintf(fileid,[' CHOMIT(6)=''Lip20''\n']);
fprintf(fileid,[' CHOMIT(7)=''Lip13a''\n']);
fprintf(fileid,[' CHOMIT(8)=''Lip13b''\n']);
fprintf(fileid,[' CHOMIT(9)=''Lip09''\n']);
fprintf(fileid,[' CHOMIT(10)=''PE''\n']);
fprintf(fileid,[' CHOMIT(12)=''Glc''\n']);


% Fitting paramaters

fprintf(fileid,' DEGZER=0\n');
fprintf(fileid,' SDDEGZ=999\n');
fprintf(fileid,[' DEGPPM=' num2str(-(procparam.lp)/(acqparam.sw_hz/acqparam.hzpppm)) '\n']);
fprintf(fileid,' SDDEGP=0.00\n');
fprintf(fileid,' SHIFMN=-0.3,-0.3\n');
fprintf(fileid,' SHIFMX=0.3,0.3\n');
fprintf(fileid,' FWHMBA=0.010\n');
fprintf(fileid,' RFWHM=1.8\n');
fprintf(fileid,' DKNTMN=0.25\n');
fprintf(fileid,' PPMST=4.3\n');
fprintf(fileid,' PPMEND=0.4\n');
fprintf(fileid,' PPMSHF=0.05\n');
fprintf(fileid,[' FILBAS=''' files.lcmodelbasisfilename '.BASIS''\n']);
fprintf(fileid,[' FILRAW=''' files.lcmodeldatafilename files.lcmodeldatafilenameext '.RAW''\n']);
fprintf(fileid,[' HZPPPM=' num2str(acqparam.hzpppm) '\n']);
fprintf(fileid,[' NUNFIL=' num2str(acqparam.nbpoints) '\n']);
fprintf(fileid,[' DELTAT=' num2str(1/acqparam.sw_hz) '\n']);
fprintf(fileid,[' VITRO=T\n']);
fprintf(fileid,[' NUSE1=3\n']);
fprintf(fileid,[' CHUSE1(1)=''NAA''\n']);
fprintf(fileid,[' CHUSE1(2)=''Cr+PCr''\n']);
fprintf(fileid,[' CHUSE1(3)=''GPC+PCho+Cho''\n']);
fprintf(fileid,' $END\n');

fclose(fileid);

% generate .PLOTIN file for PlotRaw

disp(['Writing ' files.lcmodeldatadir files.lcmodeldatafilename files.lcmodeldatafilenameext '.PLOTIN'])

fileid=fopen([files.lcmodeldatadir files.lcmodeldatafilename files.lcmodeldatafilenameext '.PLOTIN'],'w');

fprintf(fileid,' $PLTRAW\n');
fprintf(fileid,[' HZPPPM=' num2str(acqparam.hzpppm) '\n']);
fprintf(fileid,[' NUNFIL=' num2str(acqparam.nbpoints) '\n']);
fprintf(fileid,[' DELTAT=' num2str(1/acqparam.sw_hz) '\n']);
fprintf(fileid,[' FILRAW=''' files.lcmodeldatafilename files.lcmodeldatafilenameext '.RAW''\n']);
fprintf(fileid,[' FILPS=''' files.lcmodeldatafilename files.lcmodeldatafilenameext '.PS''\n']);

fprintf(fileid,[' DEGZER=' num2str(-(procparam.rp+0.5*procparam.lp)) '\n']);
fprintf(fileid,[' DEGPPM=' num2str(-(procparam.lp)/(acqparam.sw_hz/acqparam.hzpppm)) '\n']);
fprintf(fileid,' $END\n');

fclose(fileid);

% create .RAW file

% shift receiver offset (in time domain)

complexfid=zeros(1,length(fid_to_fit)/2);

complexfid=fid_to_fit(1:length(fid_to_fit)/2)+1i*fid_to_fit(length(fid_to_fit)/2+1:length(fid_to_fit));
t=(0:1/acqparam.sw_hz:(length(complexfid)-1)/acqparam.sw_hz)'; 
complexfid=complexfid.*exp(-1i*2*pi*procparam.lsfrq*t);

% create .RAW file for LCModel

disp(['Writing ' files.lcmodeldatadir files.lcmodeldatafilename files.lcmodeldatafilenameext '.RAW'])

fileid=fopen([files.lcmodeldatadir files.lcmodeldatafilename files.lcmodeldatafilenameext '.RAW'],'w');

fprintf(fileid,[' $NMID ID=''' files.lcmodeldatafilename files.lcmodeldatafilenameext '.RAW' ''', FMTDAT=''(8E13.5)''\n']);
fprintf(fileid,[' TRAMP=1, VOLUME=' num2str(procparam.volume,6) ' $END\n']);

fprintf(fileid,'%13.5E%13.5E%13.5E%13.5E%13.5E%13.5E%13.5E%13.5E\n',[transpose(imag(complexfid)); transpose(real(complexfid))]); 

fclose(fileid);


disp(' ')
