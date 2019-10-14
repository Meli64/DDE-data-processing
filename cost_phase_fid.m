function c=cost_phase_fid(param)

global spec_ref spec_p_lb
global c

phi=param(1);

c=[real(exp(1i*phi)*spec_p_lb-spec_ref) imag(exp(1i*phi)*spec_p_lb-spec_ref)];
