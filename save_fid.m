%========================================================================
% Spectra reconstruction from FID
% J. Valette, C. Giraudeau, 11/2008, CEA/DSV/I2BM/NEUROSPIN/ISEULT
%========================================================================

function save_fid(FID, phi0,PathName)


nb_pts_to_remove=0;


fid_tronc=[FID(nb_pts_to_remove+1:end); zeros(nb_pts_to_remove,1)];

fid_tronc=fid_tronc.*exp(1i*phi0);

plot(real(fftshift(fft(fid_tronc))));

set(gca,'Xdir','reverse');

fid_name=[PathName 'fid_asc'];

file_id=fopen(eval('fid_name'),'w');
fprintf(file_id,'%10.2f\n',[real(fid_tronc) imag(fid_tronc)]);


fclose(file_id);





