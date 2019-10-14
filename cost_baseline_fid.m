function c=cost_baseline_fid(param)

global spec_ref spec_p_lb
global c

offset_baseline_real=param(1)*ones(size(spec_ref,1),size(spec_ref,2));
offset_baseline_imag=param(2)*ones(size(spec_ref,1),size(spec_ref,2));

c=10000*[real(spec_p_lb-spec_ref)-offset_baseline_real imag(spec_p_lb-spec_ref)-offset_baseline_imag];