% 	DUAL: INNER PRODUCT WITH I3 
GAfigure; clc; %/
% 	DUAL: INNER PRODUCT WITH I3 
%.
global x B b; %/
clf; %/
% 	The inner product with I3 gives the DUAL
%	(the part of I3 least like x).
%.
x = e1/2 - e2 +e3/3
random = unit(pi*e1 + pi/exp(0)*e2 + exp(0)*e3); %/
B = inner(x,I3) %w
draw(x,'b'); %/
GAtext(0.7*x + 0.1*unit(random^x)/I3,'x','b'); %/
axis off; %/
axis([-1 1 -1 1 -1 1]); %/
GAprompt; %/
% 	(The bivector coefficients match the vector coefficients.)
%.
draw(B,'g'); %/
axis([-1 1 -1 1 -1 1]); %/
GAtext(0.3*unit(grade(inner(random,B),1))+0.1*B/I3,'x \bullet I_3'); %/
GAprompt; %/ 
GAorbiter(360,10); GAprompt; %/ 
% 	Taking the dual of the bivector gives a vector:
%.
b = inner(B,I3) %w
draw(b,'r'); %/
axis([-1 1 -1 1 -1 1]); %/
GAtext(0.9*b - 0.15*unit(random^b)/I3,'(x \bullet I_3) \bullet I_3','r'); %/ 

