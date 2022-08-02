% Script p3_2_02.m; DVDP for max range with uc=Vy/h, yf=0, s=[x y]'  
% in units of h, t in units of h/V;                    8/97, 6/9/02
%
N=20; s0=[0 0]'; tf=6; k=-1; tol=1e-4; th0=pi/3*[1:-2/N:-1+2/N]; 
mxit=30; [th,s]=dopc('dzrmc',th0,s0,tf,k,tol,mxit); 
x=s(1,:); y=s(2,:);
%
% Calculate location of tips of thrust vectors:
for i=1:N, xt(i)=x(i)+1.8*cos(th(i)); yt(i)=y(i)+1.8*sin(th(i)); 
end
%
figure(1); clf; plot(x,y,'.',x,y); grid; hold on 
for i=1:N, pltarrow([x(i) xt(i)],[y(i) yt(i)],.25,'r','-'); end
hold off; axis([0 12 -3 5]); xlabel('x/h'); ylabel('y/h')
       

       
       