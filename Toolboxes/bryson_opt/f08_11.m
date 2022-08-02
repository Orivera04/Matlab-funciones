% Script f08_11.m; Zermelo pb w. sinusoidal current; problem 
% with a conjugate point;                        3/93, 4/4/02
%
tf1=(pi/sqrt(2))*[1.01 1.2:.2:1.8]; N=length(tf1);
name='zrm_sin'; s0=[0 0]'; 
optn=optimset('Display','Iter','MaxIter',100);
p0=[1 0.1804 -0.1800; 1 0.8241 -0.8231; 1 1.1614 -1.1606; ...
    1 1.3829 -1.3825; 1 1.5260 -1.5261];
yc=[-1:.02:1]; uc=(sin(yc*pi/2)).^2;
ya=[-1:.2:1]; ua=(sin(ya*pi/2)).^2;
%
figure(1); clf; plot(1.41,0,'ro',[0 1.41],[0 0],'b'); hold on
text(1.25,.1,'Conjugate Point'); text(.2,.86,'u_c'); 
figure(2); clf;
for i=1:N, tf=tf1(i);  
 p=fsolve('fopcf',p0(i,:),optn,name,s0,tf);
 [f,t,y1]=fopcf(p,name,s0,tf); x=2*y1(:,1)/pi; y=2*y1(:,2)/pi;
 th=atan(y1(:,4)); p1(i,:)=p; figure(1); plot(x,y,'b',x,-y,'b'); 
 figure(2); subplot(211), plot(t,th); hold on
end
for i=1:11, figure(1); pltarrow([0 ua(i)],[ya(i) ya(i)],...
   .06,'k','-'); end; grid; xlabel('2x/\pi'); ylabel('2y/\pi')
axis([0 3.2 -1 1]); hold off 
print -deps2 \book_do\figures\f08_11
figure(2); grid; xlabel('Time'); ylabel('\theta (rad)'); 
hold off

