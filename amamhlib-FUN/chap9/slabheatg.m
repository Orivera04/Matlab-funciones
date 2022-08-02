function slabheat      
% Example: slabheat
% ~~~~~~~~~~~~~~~~~
% This program computes the temperature 
% variation in a one-dimensional slab with 
% the left end insulated and the right end 
% given a temperature variation sin(w*t).
%
% User m functions required:  heat

[u1,t1,x1]=heat(12,0,2,50,0,1,51,250);
surf(x1,t1,u1); axis([0 1 0 2 -2 2]);
title('Temperature Variation in a Slab');
xlabel('x axis'); ylabel('time'); 
zlabel('temperature'); view([45,30]), shg
colormap(gray), brighten(.7)
disp(' '), disp('Press [Enter] to continue')
pause
print -deps tempsurf

[u2,t2,x2]=heat(12,0,2,150,0,1,3,250);
plot(t2,u2(:,1),'--k',t2,u2(:,2),':.k', ...
     t2,u2(:,3),'-k');
title(['Temperature History at Ends' ...
       ' and Middle']);
xlabel('dimensionless time');
ylabel('dimensionless temperature');
text1='Left End'; text2='Middle';
text3='Right End';
legend(text1,text2,text3,3); shg
print -deps templot 
disp(' '), disp('All Done');

%=============================================

function [u,t,x]= ...
         heat(w,tmin,tmax,nt,xmin,xmax,nx,nsum)
%
%[u,t,x]=heat(w,tmin,tmax,nt,xmin,xmax,nx,nsum)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function evaluates transient heat 
% conduction in a slab which has the left end 
% (x=0) insulated and has the right end (x=1) 
% subjected to a temperature variation 
% sin(w*t). The initial temperature of the slab
% is zero.
%
% w          - frequency of the right side
%              temperature variation
% tmin,tmax  - time limits for solution
% nt         - number of uniformly spaced
%              time values used
% xmin,xmax  - position limits for solution.
%              Values should lie between zero
%              and one.
% nx         - number of equidistant x values
% nsum       - number of terms used in the 
%              series solution
% u          - matrix of temperature values.
%              Time varies from row to row.
%              x varies from column to column.
% t,x        - vectors of time and x values
%
% User m functions called:  none.
%----------------------------------------------

t=tmin+(tmax-tmin)/(nt-1)*(0:nt-1);
x=xmin+(xmax-xmin)/(nx-1)*(0:nx-1)';
W=sqrt(-i*w); ln=pi*((1:nsum)-1/2); 
v1=ln+W; v2=ln-W;
a=-imag((sin(v1)./v1+sin(v2)./v2)/cos(W));
u=imag(cos(W*x)*exp(i*w*t)/cos(W))+ ...
  (a(ones(nx,1),:).*cos(x*ln))* ...
  exp(-ln(:).^2*t);
u=u'; t=t(:);