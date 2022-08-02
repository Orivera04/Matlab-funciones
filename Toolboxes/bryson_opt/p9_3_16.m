% Script p9_3_16.m; max time glide at const. altitude w. SVIC
% |y(t)|<= ymax, using FMINCON and inverse control; key state
% variables (V,ps); (x,y) by integration of (V,ps); control sg
% by differentiation of (V,ps);                  2/98, 9/17/02
%
N=40; load glid_dat; optn=optimset('Display','Iter');
p=fmincon('glid1_f',p0,[],[],[],[],[],[],'glid1_c',optn);
[f,x,y,ps,V,sg,tf]=glid1_f(p);      
t=tf*[0:1/N:1]'; tb=tf*[.5/N:1/N:1-.5/N]; c=180/pi;  
%
figure(1); clf; subplot(311), plot(t,V,t,V,'.'); grid
axis tight; ylabel('V'); subplot(312), plot(t,c*ps,t,c*ps,'.');
grid; axis tight; ylabel('\psi (deg)'); subplot(414)
plot(tb,c*sg,tb,c*sg,'.'); grid; axis tight
ylabel('\sigma (deg)'); xlabel('Time')
%
figure(2); clf; plot(x,y,x,y,'.',[-2 2],[.4 .4],'r--',...
    x(N+1),y(N+1),'ro',-2,0,'ro',[-2 2],[-.4 -.4],'r--');
axis([-2 2 -1.5 1.5]); grid; ylabel('y'); xlabel('x')


