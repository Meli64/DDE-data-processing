function c=cost_freq(param)

global spec_ref fid_p_lb metab_inf metab_sup time
global c

delta_nu=param(1);

correction=exp(2*pi*1i*delta_nu*time);

fid_shift_lb=fid_p_lb.*correction;

spec_shift_lb=fftshift(fft(fid_shift_lb));
spec_shift_lb=spec_shift_lb(metab_inf:metab_sup);

c=[abs(spec_shift_lb)-abs(spec_ref)];

