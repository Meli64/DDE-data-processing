%%%Read .COORD LCModel file and write the selected values in an Excel
%%%file%%
%TO UPDATE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phi_values=[1 0 45 90 135 180 225 270 315 360];

%%%To update: Excel file name%%%
NameExcel='';

%%%To upate: directory with the LCModel analysis for each phi value%%%
directory='';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%/!\ define list of metabolites

% % %List SE DDE 30 25
list_metabo={'Ace';
    'Ala';
    'Asp';
    'Cho';
    'Cr';
    'GABA';
    'Gln';
    'Glu';
    'GPC';
    'Ins';
    'sIns';
    'Lac';
    'NAA';
    'NAAG';
    'PCho';
    'PCr';
    'Tau';
    'MM_DDE';
    '-CrCH2';
    'NAA+NAAG';
    'Glu+Gln';
    'GPC+PCho+CHo';
    'Cr+PCr';
    };

%user selection

[Selection,ok] = listdlg('PromptString', 'Select metabolites','ListString',list_metabo);


%Creation of matrix contraining results to be saved in an Excel file

Res=cell(length(phi_values)+1, length(Selection)*2+1);
Res(1,1)={'b'};

for i=1:length(phi_values)
    
    Res(i+1,1)={phi_values(i)};
    
end

for j=2:length(Selection)*2+1
    if mod(j,2)==0
        s=round(j/2);
        Res(1,j)= {char(list_metabo(Selection(s)))};
    else
        Res(1,j)={'b=20/b=0.02'};
    end
end
    
for t=2:length(phi_values)+1
    
    filename=strcat(directory,'phi',num2str(phi_values(t-1)),'fid_asc.COORD');
    
    [error_flag, lcmodelresults]=readcoord(filename);
    for s=1:length(Selection)
        pos=s*2;
        Res(t,pos)={lcmodelresults.metabconc(Selection(s)).absconc};
    end
    
    xlswrite(NameExcel,Res,1);
end

