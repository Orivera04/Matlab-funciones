% Script p5_2_07c.m; inverted pendulum - analytical solution;
% s=[y v]';                                       7/97, 3/31/02
%
tf1=[6 30]; sv=1e4; sy=sv; v0=0; y0=-1;
for i=1:2, tf=tf1(i); 
 c=cosh(tf); s=sinh(tf); M=.5*[tf*c-s+2*c/sy tf*s+2*s/sv; 
 tf*s+2*s/sy tf*c+s+2*c/sv]; AB=M\[y0 -v0]'; A=AB(1); 
 B=AB(2); C=B/sv-A/2; D=A/sy;  T=tf*[1:-.01:0]; t=tf*[0:.01:1];
 y=A*T.*cosh(T)/2+B*T.*sinh(T)/2+C*sinh(T)+D*cosh(T);
 u=A*sinh(T)+B*cosh(T);
 %
 figure(i); clf; subplot(211), plot(t,y); grid; ylabel('y');
 subplot(212), plot(t,u); grid; ylabel('u'); xlabel('t');
end
	 

