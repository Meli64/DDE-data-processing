%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script sums individual repetition after performing  frequency and
% phase correction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ref= reference spectrum for phase and frequency correction, here, the sum
%of all repetitions without correction between the metab_inf and metab_sup bounds 

%fid_phased: reconstructed fid after phase and frequency correction

%fid_raw: sum of all repetitions without frequency/phase correction

%STD_PHI: standard deviation of the phase values applied for phase correction: the
%higher the phase standard deviation, the more likely that there are
%artifacts arising from motion during the acquisition


function [ref fid_phased fid_raw STD_PHI]=sum_rep(fid_matrix)

global spec_ref spec_p_lb fid_p_lb time factor_for_phi metab_inf metab_sup

nb_pts_cplx=size(fid_matrix,1);
dw=1/5000;

lb=8; % lb for phase correction only, not on the final fid

metab_inf=800;
metab_sup=1500;


NS=size(fid_matrix,2);

%%% Generating the raw sum FID %%%%%%%%%%%%

fid_raw=sum(fid_matrix,2);

%%% Generating the reference spectrum for correction %%%%%%%%%%%%

time=((0:nb_pts_cplx-1)*dw)';

fid_ref=fid_raw.*exp(-lb*time)/NS;

spec_ref=fftshift(fft(fid_ref));
spec_ref=spec_ref(metab_inf:metab_sup);
ref=spec_ref;


fid_phased=zeros(nb_pts_cplx,1);
list_phase=zeros(NS,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Individual spectrum correction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options=optimset;
optjv=optimset(options,'MaxFunEvals',1e6);

for p=1:NS
    
    fid_p=squeeze(fid_matrix(:,p));
    
    fid_p_lb=fid_p.*exp(-lb*time);
    
    %%% Frequency correction %%%
    
    y=lsqnonlin('cost_freq',[0 1],[-80 0],[80 3],optjv);
    delta_nu=y(1);
    factor_for_phi=y(2);
    
    correction=exp(2*pi*1i*delta_nu*time);
    
    fid_p=fid_p.*correction;
    
    %%% Phase correction %%%
    
    fid_p_lb=fid_p.*exp(-lb*time);
    spec_p_lb=fftshift(fft(fid_p_lb));
    spec_p_lb=spec_p_lb(metab_inf:metab_sup);
    
    phi=lsqnonlin('cost_phase',0,-pi,pi,optjv);
    
    list_phase(p)=phi*180/pi;
    
    fid_p=exp(1i*phi)*fid_p;
    
    fid_phased=fid_phased + fid_p;
   
   
end

% g=figure
% figure(g)
% plot(list_phase);

MEAN_PHI=mean(list_phase)
STD_PHI=std(list_phase)

f=figure;
figure(f);
hold on;
plot(real(fftshift(fft(fid_raw'))));
plot(real(fftshift(fft(fid_phased'))),'r');


fid_raw=fid_raw';
fid_phased=fid_phased';
