dm = linspace(0,1);
dn = back_lsh(dm);
angl = atan2(imag(dn),real(dn))*180/pi; angl(length(angl)) = -90;
plot(dm,angl); grid;
title('Phase characteristics for the describing function of BACKLASH');
xlabel('D/M'); ylabel('Phase of shift of N (Degrees)');
