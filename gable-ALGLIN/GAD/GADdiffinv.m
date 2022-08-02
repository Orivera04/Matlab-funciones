clf; %/
% |  DIFFERENTIATION OF INVERSE OPERATION
% |
%% x = vector to invert
%% b = change of x
x = 1.2*(e1+e2/3); %/
b = 0.1* unit(2*e2+e3); %/
%%
draw(x,'b'); GAtext(1.05*x,'x','b'); %/
axis off; %/
axis([ 0 1.2 0 0.5 0 0.1]); %/
% |    x = vector to invert
% | 
waitforbuttonpress; %/
ix = inverse(x); %/
draw(ix,'r'); GAtext(1.05*ix,'x^{-1}','r'); %/
axis([ 0 1.2 0 0.5 0 0.1]); %/
% |    inverse vector 1/x
% | 
waitforbuttonpress; %/
draw(b,'k'); GAtext(1.1*b,'b','k'); %/
draw(x+b,'m'); GAtext(1.05*(x+b),'x+b','m'); %/
DrawPolyline({x,x+b,x/1000},'m'); %/
axis([ 0 1.2 0 0.5 0 0.1]); %/
% |    change x to x+b
% | 
waitforbuttonpress; %/
xbi = inverse(x+b); %/
DrawPolygon({ix,xbi,ix/1000},'y'); %/
draw(xbi,'r'); GAtext(xbi+(b^x)/x,'(x+b)^{-1}','r'); %/
axis([ 0 1.2 0 0.5 0 0.1]); %/
% |    change in inverse
% | 
waitforbuttonpress; %/
dix = -ix*b/x;  %/
draw(dix,'r'); GAtext(1.1*dix,'-x^{-1}b x^{-1}','r'); %/
title('(x+b)^{-1} \approx x^{-1} - x^{-1}b x^{-1}'); %/
DrawPolygon({ix,ix+dix,ix/1000},'w'); %/
axis([ 0 1.2 0 0.5 0 0.1]); %/
% |    differentiation gives first order of this change
% |
% |  END OF DEMO

