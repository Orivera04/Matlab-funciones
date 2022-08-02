% Script p1_3_22.m; minimum helix radius & max turn rate for 
% specified climb angle for 727 at full thrust, using POP;
%                                              9/96, 3/30/02
%
global flg ga; flg=1; ga=0*pi/180; W=180000; S=1560; 
rho=.002203; g=32.2; lc=2*W/(rho*g*S); Vc=sqrt(g*lc);
tc=lc/Vc; tol=.00005; eta=1; mxit=100; c=pi/180; 
yo=[300/Vc 17*c 60*c]';
if flg==1, k=.1; elseif flg==2, k=-.1; end; 
% Note k must changed if ga not 0
[L,y,f]=pop('cltn',yo,k,tol,eta,mxit)
%
% Data for plots (acquired by running this code many times): 
ga=[0 2 3 4 4.5 4.75 5 5.25 5.5 5.75 6 6.25 6.5 6.75 6.99];
r=1.0e+003*[2.0594 2.2510 2.4097 2.6581 2.8442 2.9629 3.1060...
    3.2822 3.5056 3.7998 4.2094 4.8304 5.9261 8.4481];
rr=ones(1,14)./r; rr=[rr 0];
al=[.2958 .2789 .2681 .2552 .2478 .2438 .2395 .2351 .2304 ...
    .2255 .2202 .2147 .2087 .1952 .1822]/c;
sg=[.9626 .8753 .8185 .7467 .7021 .6767 .6487 .6173 .5819 ...
    .5411 .4931 .4344 .3587 .2645 0]/c;
%
figure(1); subplot(211),plot(ga,sg,'b',ga,al,'r--'); grid 
legend('\sigma','\alpha'); ylabel('Deg')
title('\sigma & \alpha for Min Helix Radius')
subplot(212), plot(ga,rr,'b'); grid; xlabel('\gamma (deg)') 
ylabel('1/Radius (1/ft)'); title('Reciprocal of Min Radius')

