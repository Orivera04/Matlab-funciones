% Script p4_5_03.m; min dist. on sphere (Tokyo-New York);  11/96, 7/16/02
%
clear; clear global; global thf phf; c=pi/180; thf=40.7*c; th0=35.7*c;
phf=2*pi-c*(73.8+139.7); name='geot'; be0=[1.1:-.1:-1.1]'; 
N=length(be0)-1; tf=1.7; tu=tf*[0:1/N:1]'; s0=[0 th0]'; k=1; told=1e-4;
tols=2e-4; mxit=20; [t,be,s,tf]=fopt(name,tu,be0,tf,s0,k,told,tols,mxit);
ph=s(:,1)/c; th=s(:,2)/c; be=be/c;
%
figure(1); clf; subplot(211), plot(ph,th,0,th0/c,'ro',phf/c,...
   thf/c,'ro',76,70,'ro'); grid; axis([0 150 30 75])
ylabel('Latitude \theta (deg)'); text(10,35,'Tokyo');
text(125,35,'New York'); text(60,64,'Prudhoe Bay, Alaska')
subplot(212); plot(ph,be); grid 
xlabel('Diff. Long. \phi-\phi_0(deg)'); ylabel('Heading \beta (deg)')

