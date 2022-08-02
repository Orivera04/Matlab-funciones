dm = linspace(0,1);
dn = back_lsh(dm);
plot(dm,abs(dn)); grid; 
title('Amplitude characteristics for the describing function of BACKLASH');
xlabel('D/M'); ylabel('| N |');
