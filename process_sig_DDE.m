%%%to update: path to directory containing the raw data%%%
directory_fid='';
nb_fid=40;
nb_series=4;

%%%to update: Bruker instruction number%%%
FID_tag=[13 14 15 16 17 18 19 20 21 22 24 25 26 27 28 29 30 31 32 33 35 36 37 38 39 40 41 42 43 44 46 47 48 49 50 51 52 53 54 55]; 

%%%list of phi value. /!\Here,20 designates the signal for phi=0° and
%%%b=0.02ms/µm² %%%
phi_tag=[20 0 45 90 135 180 225 270 315 360];

FID_ALL=zeros(4096,length(phi_tag));

for i=1:nb_fid/nb_series   
	
    number1=num2str(FID_tag(i));
    number2=num2str(FID_tag(i+nb_fid/nb_series));
    number3=num2str(FID_tag(i+2*(nb_fid/nb_series)));
    number4=num2str(FID_tag(i+3*(nb_fid/nb_series)));


    phivalue=strcat('phi',num2str(phi_tag(i)));
    
    file1=strcat(directory_fid,'\',number1,'\fid');   
    file2=strcat(directory_fid,'\',number2,'\fid');  
    file3=strcat(directory_fid,'\',number3,'\fid');  
    file4=strcat(directory_fid,'\',number4,'\fid');  
    
    %%%to update: save directory%%%
    Path=strcat('',phivalue);
    
    FID1=load_array_FID2(file1,32);    
    FID2=load_array_FID2(file2,32);
    FID3=load_array_FID2(file3,32);    
    FID4=load_array_FID2(file4,32);
    
    [ref1, fid_phased1, fid_raw1, STD_PHI1]=phaser(FID1);
    [ref2, fid_phased2, fid_raw2, STD_PHI2]=phaser(FID2);
    [ref3, fid_phased3, fid_raw3, STD_PHI3]=phaser(FID3);
    [ref4, fid_phased4, fid_raw4, STD_PHI4]=phaser(FID4);

    FIDTOT1=sum_FID(fid_phased1', fid_phased2', fid_phased1);
    FIDTOT2=sum_FID(fid_phased3', fid_phased4', fid_phased3);
    FIDTOT=sum_FID(FIDTOT1, FIDTOT2, FIDTOT1');   
    
    save_fid(FIDTOT,0,Path);
    FID_ALL(:,i)=FIDTOT;
        
end

    save('FID_ALL.mat', 'FID_ALL', '-mat');
