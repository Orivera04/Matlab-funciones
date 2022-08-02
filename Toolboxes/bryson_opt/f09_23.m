% Script f09_23.m; max time glide at const. altitude with SVIC
% |y(t)|<= ymax;                                  2/98, 9/17/02
%
N=40; load glid_dat;               % Converged solution
optn=optimset('display','iter');
p=fmincon('glid1_f',p0,[],[],[],[],[],[],'glid1_c',optn);
[f,x,y,ps,V,sg,tf]=glid1_f(p);    
 t=tf*[0:1/N:1]'; tb=tf*[.5/N:1/N:1-.5/N]; N1=N+1;  
c=180/pi; sg=c*sg; ps=c*ps;
%
figure(1); clf; subplot(311), plot(t,V,t,V,'.'); grid; axis tight 
ylabel('V'); subplot(312), plot(t,ps,t,ps,'.'); grid; axis tight
ylabel('\psi (deg)'); subplot(414); plot(tb,sg,tb,sg,'.'); 
grid; axis tight; ylabel('\sigma (deg)'); xlabel('Time');
%
figure(2); clf; plot(x,y,x,y,'.',[-2 2],[.4 .4],'r--',x(N1),...
    y(N1),'ro',-2,0,'ro',[-2 2],[-.4 -.4],'r--');
axis([-2 2 -1.5 1.5]); grid; ylabel('y'); xlabel('x');


