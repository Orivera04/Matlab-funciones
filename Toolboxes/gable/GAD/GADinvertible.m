% |    INVERTIBILITY OF GEOMETRIC PRODUCT
% |
%% |   demonstrate unique decomposition of 
%% |   geometric product (by considering its components)
%% |   then show projection and rejection
clf; %/
a=e1; %/
x = 2*e1+e2; %/
ip = inner(x,a); %/
proj=ip/a; %/
rej = (x^a)/a; %/
urej = unit(rej); %/
aplane = unit(a)*I3; %/
perp = -urej/aplane; %/
draw(a,'r'); GAtext(a/2-0.1*urej+0.1*perp,'a','r'); %/
axis off; %/
gaview([-15,60]); %/
axis([-1 4 -1.5 1.5 -1.5 1.5]); %/
% |    Given a and a.x, what is x?
% |
title('Given a and x \bullet a, what is x?'); %/
GAprompt; %/
s = 1.5*norm(rej); %/
DrawPolygon({proj+s*(urej+perp),proj+s*(urej-perp),proj+s*(-urej-perp),proj+s*(-urej+perp)},'w'); %/
GAtext(proj-(s+0.1)*urej,'x \bullet a - plane','r'); %/
gaview([-15,60]); %/
axis([-1 4 -1.5 1.5 -1.5 1.5]); %/
% |    Somewhere in the x.a-plane...
% |
title('Somewhere in the x \bullet a - plane...'); %/
GAprompt; %/
clf;
draw(a,'r'); GAtext(a/2-0.1*urej+0.1*perp,'a','r'); %/
axis off; %/
gaview([-15,60]); %/
axis([-1 4 -1.5 1.5 -1.5 1.5]); %/
% |    Given a and x^a, what is x?
% |
title('Given a and x \wedge a, what is x?'); %/
GAprompt; %/
y = x; %/
DrawPolygon({0,a,a+y,y},'y'); %/
y = x-2*a; %/
DrawPolygon({0,a,a+y,y},'y'); %/
DrawPolyline({x-3*a,x+2*a},'r'); %/
GAtext(x+2.2*a,'x \wedge a - line','r'); %/
axis([-1 4 -1.5 1.5 -1.5 1.5]); %/
% |    Somewhere on the x^a-line...
% |
title('Somewhere on the x \wedge a - line...'); %/
GAprompt; %/
DrawPolygon({proj+s*(urej+perp),proj+s*(urej-perp),proj+s*(-urej-perp),proj+s*(-urej+perp)},'w'); %/
GAtext(proj-(s+0.1)*urej,'x \bullet a - plane','r'); %/
% |    Now combine these to the invertible geometric product
% |
title('Combine in the geometric product:  x a = x \bullet a + x \wedge a'); %/
axis([-1 4 -1.5 1.5 -1.5 1.5]); %/
GAprompt; %/
% |    And solve!
% |
title('Solve as:  x = (x \bullet a)/a + (x \wedge a)/a'); %/
draw(x,'k'); GAtext(2*x/3-0.1*urej+0.1*perp,'x','k'); %/
draw(proj,'b'); GAtext(1.1*proj,'(x \bullet a)/a','b'); %/
draw(rej,'b'); GAtext(1.3*rej+0.1*perp,'(x \wedge a)/a','b'); %/
axis([-1 4 -1.5 1.5 -1.5 1.5]); %/
