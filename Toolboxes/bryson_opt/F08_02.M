% Script f08_02.m; NOC for Zermelo Pb; 3/95, 4/4/02
%
% Nominal path
optn=odeset('reltol',1e-4);
[t,s]=ode23('zerm_noc',[0 5.1],[3.66; -1.86],optn); 
x=s(:,1); y=s(:,2); figure(1); clf; 
plot(x,y,x,y,'b.'); grid; axis([0 7 -2 2]); hold on 
%
% NOC path #1:
[t,s]=ode23('zerm_noc',[0 5.3],[5.4; -1.5],optn);
x=s(:,1); y=s(:,2); plot(x,y,x,y,'b.',0,0,'b.');
%
% NOC path #2:
[t,s]=ode23('zerm_noc',[0 4.1],[3; -1.5],optn); 
x=s(:,1); y=s(:,2); plot(x,y,x,y,'b.'); hold off
xlabel('x/h'); ylabel('y/h'); text(3.9,-.3,'Nominal')
text(2.2,-.3,'NOC #2'); text(5.2,1.2,'NOC #1');
%print -deps2 \book_do\figures\f08_02