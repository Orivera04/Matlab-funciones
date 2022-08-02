% Script f08_14.m; Fermat Pb with a conjugate point; 
% s=[be x y]';                          2/94, 4/4/02
%
tf=[3.1959 3.3715 3.7080 4.3144 4.8025 5.5386];
s01=(pi/12)*[1 2 3 4 4.5 5];
%
figure(1); clf; for i=1:6, s0=[s01(i) 0 0]'; 
   [t,s]=ode23('conjpt',[0 tf(i)],s0); x=s(:,2); 
   y=s(:,3);    plot(x,y,x,-y,'b'); hold on; end
plot(pi,0,'ro',0,0,'ro',[0 pi],[0 0]); hold off
axis([0 9 -4.5 4.5]); axis('square'); grid
xlabel('x/h'); ylabel('y/h');
text(6.1,-3.8,'V=Vo*sqrt[1+(y/h)^2]')
text(6.2,3.4,'\beta_0=75 deg'); text(4.2,2.4,'67.5')
text(3.2,1.8,'60'); text(2.4,1.2,'45')
text(2.1,.72,'30'); text(1.8,.4,'15')
text(3.2,.3,'Conjugate Point')
%print -deps2 \book_do\figures\f08_14	