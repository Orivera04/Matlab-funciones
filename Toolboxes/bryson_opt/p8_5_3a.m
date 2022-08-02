% Script p8_5_3a.m; min distance path on sphere using NONLINEAR
% FEEDBACK to find optimal current heading angle; t=ph=longitude; 
% th=latitude;                                            7/13/02
%
global phf thf; c=pi/180; thf=40.7*c; phf=146.5*c; th0=35.7*c;
optn=odeset('RelTol',1e-4);
[ph,th]=ode23('geoz',[0 phf],th0,optn); 
%
figure(1); clf; subplot(211), plot(ph/c,th/c,0,th0/c,'ro',...
  phf/c,thf/c,'ro'); axis([0 phf/c 30 75]); grid
ylabel('Latitude \theta (deg)');
xlabel('Longitude Difference (deg)')