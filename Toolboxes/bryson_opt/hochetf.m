% Script hochetf.m; finds locus of initial evader points where
% tfs=tfb (equivocal points); (tfs,tfb)=final times using 
% (BS,BB) paths; (ts,tb)=switch times for (BS,BB) paths;
%                                                       3/2/02
%
w=1/3; el=1/4; X0=[4.9 .59]; figure(1); clf; optn=optimset...
   ('display','iter','maxiter',50); ts=[1.5:.3:3.6];
for i=1:length(ts), X=fsolve('hochetf1',X0,optn,w,el,ts(i));
   [f,xe0(i),ye0(i),xefs(i),yefs(i),xefb(i),yefb(i)]...
      =hochetf1(X,w,el,ts(i)); tf(i)=X(1); tb(i)=X(2); 
   plot(xe0(i),ye0(i),'b.',xefs(i),yefs(i),'b.',xefb(i),...
      yefb(i),'b.',[xe0(i) xefs(i)],[ye0(i) yefs(i)],'b',...
      [xe0(i) xefb(i)],[ye0(i) yefb(i)],'b'); hold on; X0=X;
end; grid; axis([-1 5 -4 2]); axis('square'); z=0:pi/90:2*pi; 
for i=1:181, xc(i)=1-cos(z(i)); yc(i)=sin(z(i)); end
plot(xc,yc,'r--',-xc,yc,'r--',xe0,ye0,'b'); xlabel('x_e');
ylabel('y_e'); hold off 
title('Locus of Points where t_{fb}=t_{fs}')

