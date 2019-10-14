%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Sum of spectra after phase and frequency correction relative to a
%reference spectrum
% JV september 2009
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fid_sum]=sum_FID(fid_1,fid_2,fid_sum_init);

global spec_ref spec_p_lb fid_p_lb metab_inf metab_sup time

nb_pts_cplx=4096;
dw=1/5000;

lb=8; % lb for phase correction only, not on the final fid

metab_inf=3100; %mainly used for metabolites
metab_sup=3300;

metab_inf_noise=300;
metab_sup_noise=500;


%%% Generating the reference metab spectrum for correction %%%%%%%%%%%%

time=((0:nb_pts_cplx-1)*dw)';

fid_1_lb=fid_1.*exp(-lb*time);

spec_ref=fft(fid_1_lb);

spec_ref=spec_ref(metab_inf:metab_sup);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Individual spectrum correction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options=optimset;
optjv=optimset(options,'MaxFunEvals',1e6);


%% Frequency correction %%

fid_p_lb=fid_2.*exp(-lb*time);

y=lsqnonlin('cost_freq_fid',[0],[-300],[300],optjv);

delta_nu=y(1)

fid_2_no_fac=fid_2.*exp(2*pi*1i*delta_nu*time);


%% Phase correction %%

fid_lb=fid_2_no_fac.*exp(-lb*time);
spec_lb=fft(fid_lb);
spec_p_lb=spec_lb(metab_inf:metab_sup);

x=lsqnonlin('cost_phase_fid',[0],[-pi],[pi],optjv);

phi=x(1)


fid_2=exp(1i*phi)*fid_2_no_fac;


%% Frequency correction again %%

fid_p_lb=fid_2.*exp(-lb*time);

y=lsqnonlin('cost_freq_fid',[0],[-300],[300],optjv);

delta_nu=y(1)

fid_2=fid_2.*exp(2*pi*1i*delta_nu*time);

%% Baseline correction %%

fid_lb=fid_2.*exp(-lb*time);
spec_lb=fft(fid_lb);
spec_ref=fft(fid_1_lb);
spec_ref=spec_ref(metab_inf_noise:metab_sup_noise);
spec_p_lb=spec_lb(metab_inf_noise:metab_sup_noise);

z=lsqnonlin('cost_baseline_fid',[0 0],[-10000000 -10000000],[10000000 10000000],optjv);


offset_baseline_real=z(1)
offset_baseline_imag=z(2)

fid_2=fid_2-ifft(offset_baseline_real*ones(size(fid_2_no_fac,1),size(fid_2_no_fac,2))+1i*offset_baseline_imag*ones(size(fid_2_no_fac,1),size(fid_2_no_fac,2)));

fid_sum=fid_2+fid_sum_init';

f=figure;
figure(f);
hold on;
plot(real(fftshift(fft(fid_1))));
plot(real(fftshift(fft(fid_sum))),'k');
plot(real(fftshift(fft(fid_2))),'r');