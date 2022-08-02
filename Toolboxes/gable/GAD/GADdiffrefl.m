% | DIFFERENTIAL PROPERTIES OF REFLECTION 
%% a = vector to be reflected
%% x = vector to reflect in
%% b = change of x
clf; 				%/
a = 1.5*(e1+e2); %/
x = e1; %/
b = 0.05* unit(2*e2+e3); %/
%%
draw(a,'m'); GAtext(1.05*a,'a','m');	%/
axis([-0.1 1.7 -1.5 1.5 -0.1 0.2]); %/
axis off;	%/
% |
% |    a = vector to be reflected
waitforbuttonpress; %/
% |
%%
draw(x,'b'); GAtext(1.05*x,'x','b');	%/
axis([-0.1 1.7 -1.5 1.5 -0.1 0.2]); %/
% |    x = vector to reflect in
% |
waitforbuttonpress; %/
%%
ix = inverse(x);	%/
p = x*a/x;	%/
DrawPolygon({a,p,p/1000},'y');	%/
draw(p,'r'); GAtext(1.05*p,'x a x^{-1}','r');	%/
axis([-0.1 1.7 -1.5 1.5 -0.1 0.2]); %/
% |    the reflection of a in x
% |
waitforbuttonpress; %/
pb= (b+x)*a/(b+x);	%/
draw(x+b,'b'); GAtext(1.05*(x+b),'x+b','b');	%/
DrawPolyline({x,x+b},'k');	%/
axis([-0.1 1.7 -1.5 1.5 -0.1 0.2]); %/
% |    b = change of x
% |
waitforbuttonpress; %/
draw(pb,'r'); GAtext(1.05*pb,'(x+b) a (x+b)^{-1}','r');	%/
DrawPolygon({p,pb,a},'g');	%/
DrawPolygon({x,x+b,x/1000},'c');	%/
DrawPolyline({x,(a+p)/2,(a+pb)/2,x+b},'b');	%/
axis([-0.1 1.7 -1.5 1.5 -0.1 0.2]); %/
% |    reflection of a in x+b
% |
waitforbuttonpress; %/
id = inner(a,ix^b);	%/
draw(id,'b'); GAtext(1.05*id,'a \bullet (x^{-1} \wedge b) ','b');	%/
d = -2*x*inner(a,ix^b)/x;	%/
%%draw(d,'m'); %GAtext(1.05*d,'-2x (a \bullet (x^{-1}\wedge b))x^{-1}','k');	%/
DrawPolygon({d+p,p,d/1000},'w');	%/
axis([-0.1 1.7 -1.5 1.5 -0.1 0.2]); %/
title('(x+b) a (x+b)^{-1} \approx x a x^{-1} - 2 x (a \bullet (x^{-1}\wedge b)) x^{-1}');	%/
% |    the derivative approximates the change due to b
% |
%% GAview([-100 30]);	%/
%% shg;	%/
% | END OF DEMO
