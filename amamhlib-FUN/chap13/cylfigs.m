function cylfigs
% cylfigs
% ~~~~~~~
% This function plots the geometries 
% pertaining to four data cases used 
% to test closest proximity problems 
% involving two circular cylinders
%
% User m functions called: plot2cyls

w=rads; p=1:2; q=3:4; s=5:6; t=7:8;

rad=1; len=3; r0=[4,0,0]; v=[0,0,1];
Rad=1; Len=3; R0=[0,4,0]; V=[0,0,1];
d=.4; subplot(2,2,1)
[x,y,z,X,Y,Z]=plot2cyls(rad,len,r0,v,Rad,Len,...
              R0,V,d,'CASE 1'); hold on
plot3(w(p,1),w(p,2),w(p,3),'linewidth',2')  
hold off

rad=1; len=3; r0=[4,0,0]; v=[3,0,4];
Rad=1; Len=3; R0=[0,4,0]; V=[0,3,4];
d=.4; subplot(2,2,2);
[x,y,z,X,Y,Z]=plot2cyls(rad,len,r0,v,Rad,Len,...
              R0,V,d,'CASE 2'); hold on
plot3(w(q,1),w(q,2),w(q,3),'linewidth',2')  
hold off

rad=1; len=5; r0=[4,0,0]; v=[-4,0,3];
Rad=1; Len=5; R0=[0,4,0]; V=[0,0,1];
d=.4; subplot(2,2,3)
[x,y,z,X,Y,Z]=plot2cyls(rad,len,r0,v,Rad,Len,...
              R0,V,d,'CASE 3'); hold on
plot3(w(s,1),w(s,2),w(s,3),'linewidth',2')  
hold off

rad=1; len=4*sqrt(2);  r0=[4,0,0]; v=[-1,1,0];
Rad=1; Len=3; R0=[0,0,-2]; V=[0,0,-1];
d=.4; subplot(2,2,4);
[x,y,z,X,Y,Z]=plot2cyls(rad,len,r0,v,Rad,Len,...
              R0,V,d,'CASE 4'); hold on
plot3(w(t,1),w(t,2),w(t,3),'linewidth',2')  
hold off, subplot
% print -deps cylclose