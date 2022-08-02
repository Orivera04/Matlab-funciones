clf; %/
% |  DIFFERENTIATION OF VECTOR UNIT NORMALIZATION OPERATION
% |
%% x = vector to unify
%% b = change of x
x = 1.2*(e1+e2/3); %/
b = 0.1* unit(2*e2+e3); %/
%%
draw(x,'b'); GAtext(1.05*x,'x','b'); %/
axis off; %/
axis([0 1.2 0 0.5 0 0.1]); %/
% |    x = vector to normalize
% | 
waitforbuttonpress; %/
ux = unit(x); %/
draw(ux,'r'); GAtext(1.05*ux,'x/|x|','r'); %/
axis([0 1.2 0 0.5 0 0.1]); %/
% |    normalized vector x/|x|
% | 
waitforbuttonpress; %/
draw(b,'k'); GAtext(1.1*b,'b','k'); %/
draw(x+b,'m'); GAtext(1.05*(x+b),'x+b','m'); %/
DrawPolyline({x,x+b,x/1000},'m'); %/
axis([0 1.2 0 0.5 0 0.1]); %/
% |    change x to x+b
% | 
waitforbuttonpress; %/
xbn = (x+b)/norm(x+b); %/
DrawPolygon({ux,xbn,ux/1000},'y'); %/
draw(xbn,'r'); GAtext(xbn+(b^x)/x,'(x+b)/|x+b|','r'); %/
axis([0 1.2 0 0.5 0 0.1]); %/
% |    change in normalization
% | 
waitforbuttonpress; %/
nx = norm(x); %/
dux = (b^x)/x/nx; %/
draw(dux,'r'); GAtext(1.1*dux,'(b \wedge x^{-1})x/|x|','r'); %/
title('(x+b)/|x+b| \approx x/|x| + (b \wedge x^{-1})x/|x|'); %/
DrawPolygon({ux,ux+dux,ux/1000},'w'); %/
axis([0 1.2 0 0.5 0 0.1]); %/
% |    differentiation is first order of this change
% |
% |  END OF DEMO

