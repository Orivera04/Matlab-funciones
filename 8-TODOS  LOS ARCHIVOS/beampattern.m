%BEAMPATTERN.M
%
%Plots a beam pattern for a line hydrophone.

Nhp = 185;	% Number of hydrophones
d = 1.875;
f = 500;
lambda = 1500/f;
dol = d/lambda;	% spacing/wavelength (d/lambda)


theta = linspace(0,2*pi,5000);
r = 10*log10(beam(Nhp,dol,theta));
ind = find(r<=-80);
r(ind) = -80*ones(size(ind));

clf
subplot(2,1,1)
plot(theta*180/pi,r)
set(gca,'XTick',0:30:360)               
axis([0 360 -80 0])
xlabel('angle (degrees)')
ylabel('DI (normalised dB)')
title([int2str(Nhp) ' hydrophones, spacing = ' num2str(dol) '*lambda'])

subplot(2,1,2)
negpolar(theta,r)
xlabel('Beam pattern')
