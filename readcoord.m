% read .COORD file and plot data
% INPUT PARAMETER : filename
% OUTPUT PARAMETER : lcmodelresults structure
%       spectrumppm             : ppm values
%       spectrumdata            : raw data before fit
%       spectrumfit             : fit
%       spectrumbasl            : baseline
%       metabconc               : structure containing output information on fitted concentrations
%               name            : name of metabolite
%               relconc         : relative concentration
%               absconc         : absolute concentration
%               SD              : standard deviation (Cramer-Rao Bound)
%       linewidth               : estimated linewidth
%       SN                      : estimated signal-to-noise ratio

function [error_flag, lcmodelresults]=readcoord(filename)

error_flag=0;

% define output structure for results

lcmodelresults=struct('spectrumppm',0,'spectrumdata',0,'spectrumfit',0,'spectrumbasl',0,'metabconc',0,'linewidth',0,'SN',0);
%lcmodelresults.metabconc=struct('name',0,'relconc',0,'absconc',0,'SD',0);
lcmodelresults.metabconc=struct('name',0,'relconc',0,'absconc',0,'SD',0,'fit',0);
lcmodelresults.res=zeros(21,1);
% open .COORD file


if exist(filename)
    fileid=fopen(filename);


    % discard text until beginning of concentrations table (preceded by word 'Metab.')

   s=[];
    while ( strcmp(s,'Metabolite') + strcmp(s,'FATAL') )==0
        s=fscanf(fileid,'%s',1);
    end

    if strcmp(s,'Metabolite')==1

        % read concentration values

        index=1;
        endtable=0;
        while (endtable==0)
               lcmodelresults.metabconc(index).absconc=fscanf(fileid,'%f',1);
               lcmodelresults.res=fscanf(fileid,'%f',1);
               lcmodelresults.metabconc(index).SD=fscanf(fileid,'%f',1);
               temp=fscanf(fileid,'%s',1);                  % read and discard '%' character
               if (temp=='lines') endtable=1; end   % if word 'lines' found then concentration table has been completely read
               lcmodelresults.metabconc(index).relconc=fscanf(fileid,'%f',1);
               lcmodelresults.metabconc(index).name=fscanf(fileid,'%s',1);
               index=index+1;
        end

        lcmodelresults.metabconc=lcmodelresults.metabconc(1:length(lcmodelresults.metabconc)-1); % discard last line of table

        % discard text until linewidth (preceded by word 'FWHM')

        s=[];
        while strcmp(s,'FWHM')==0
            s=fscanf(fileid,'%s',1);
        end

        % read linewidth

        s=fscanf(fileid,'%s',1); % discard '='
        lcmodelresults.linewidth=fscanf(fileid,'%f',1);

        % discard text until S/N (preceded by word 'S/N')

        s=[];
        while strcmp(s,'S/N')==0
            s=fscanf(fileid,'%s',1);
        end

        % read S/N

        s=fscanf(fileid,'%s',1); % discard '='
        lcmodelresults.SN=fscanf(fileid,'%f',1);

        % discard text until number of data points (preceded by word 'extrema')

        s=[];
        while isempty(findstr(s,'extr'))
            s=fscanf(fileid,'%s',1);
        end

        % read number of points

        nbpoints=fscanf(fileid,'%d',1);

        % read and discard text 'points on ppm-axis = NY'

        s=fscanf(fileid,'%s',5);

        % read ppm values

        lcmodelresults.spectrumppm=fscanf(fileid,'%f',nbpoints);

        % read and discard text 'NY phased data points follow'

        s=fscanf(fileid,'%s',5);

        % read data values

        lcmodelresults.spectrumdata=fscanf(fileid,'%f',nbpoints);

        % read and discard text 'NY points of the fit to the data follow'

        s=fscanf(fileid,'%s',9);

        % read fit values
        
        lcmodelresults.spectrumfit=fscanf(fileid,'%f',nbpoints);

        % read and discard text 'NY background values follow'

        s=fscanf(fileid,'%s',4);

        % read baseline values

        lcmodelresults.spectrumbasl=fscanf(fileid,'%f',nbpoints);

       
        nb_metab_vec=size(lcmodelresults.metabconc);
        nb_metab=nb_metab_vec(2);
        
        for index=1:nb_metab
            % read and discard text 'metabname Conc. = conc'
            if lcmodelresults.metabconc(index).relconc==0
                lcmodelresults.metabconc(index).fit=zeros(nbpoints,1);
            else
                s=fscanf(fileid,'%s',4);
                lcmodelresults.metabconc(index).fit=fscanf(fileid,'%f',nbpoints);
            end
        end
         
          % close .COORD file
        fclose(fileid);
    end

    if strcmp(s,'FATAL')==1
        error_flag=1;
    end
    
else
    error_flag=1;
end
