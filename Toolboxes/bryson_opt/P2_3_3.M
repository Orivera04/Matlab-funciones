% Script p2_3_3.m; min distance from point to meridian on a sphere;
% plot from analytical soln.;                        10/96, 6/27/02
%
c=180/pi; ph0=0; phf=50/c; th0=40/c; N=100; ph=phf*[0:1/N:1]; 
un=ones(1,N+1); tth=tan(th0)*cos(phf*un-ph)/cos(phf-ph0); 
th=atan(tth);
%
figure(1); clf; plot(ph*c,th*c,0,th0*c,'ro'); grid
ylabel('Latitude \theta (deg)'); xlabel('Longitude \phi (deg)')

