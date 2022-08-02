% Script f09_17.m; DVDP for min time to specified xf with
% y>=h+x*tan(th), using FMINCON                     12/94, 3/24/02
%
N=20; ga=[1:-1/(N-1):0]; tf=1.7; h1=[.1 .2 .284]; lb=zeros(1,N+1); 
ub=[(pi/2)*ones(1,N) 5]; optn=optimset('display','iter');
%
figure(1); clf 
for i=1:3, h=h1(i); p=[ga tf]; 
   p=fmincon('dvdp_f1',p,[],[],[],[],lb,ub,'dvdp_c',optn,N,h);
   [f,v,y,x]=dvdp_f1(p,N,h); c=dvdp_c(p,N,h); 
   plot(x,-y,x,-y,'.'); hold on; plot([0 1],[-h -h-.5],'--');
end
grid; axis([0 1 -.7 0]); xlabel('x/l'); ylabel('y/l'); hold off
       
