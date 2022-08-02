% Script e08_2_2.m; NO Paths for Zermelo Pb;            3/95, 7/5/02
%
clear; clear global; zerm_nom; 
optn=odeset('reltol',1e-5); figure(1); clf;
%
% Nominal path:
[t,s]=ode23('zerm_noc',[0 5.1],[3.66 -1.86]',optn); x=s(:,1);
y=s(:,2); plot(x,y,0,0,'ro'); grid; axis([0 7 -2.5 2])
xlabel('x/h'); ylabel('y/h'); hold on; text(4.2,-.3,'Nominal')
%
% NO path #1:
[t1,s1]=ode23('zerm_noc',[0 5.3],[5.4 -1.5]',optn); x1=s1(:,1);
y1=s1(:,2); plot(x1,y1,'r--',0,0,'b.'); text(4.5,1.2,'NO Path #1')
%
% NO path #2:
[t2,s2]=ode23('zerm_noc',[0 4.1],[3 -1.5]',optn); x2=s2(:,1);
y2=s2(:,2); plot(x2,y2,'r--'); text(2.7,-.3,'NO Path #2'); hold off
