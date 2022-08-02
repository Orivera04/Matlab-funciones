%	QUATERNIONS IN GEOMETRIC ALGEBRA
GAfigure; clc; %/
%	QUATERNIONS IN GEOMETRIC ALGEBRA
global i j k u q bivector Rangle Raxis; %/
clf; %/
% The basic 'vectors' in quaternions are unit bivectors.
i = e1*I3    %w
j = -e2*I3    %w
k = e3*I3    %w
% The quaternion product is the geometric prodcut:
i*i 		%w
j*j 		%w
k*k 		%w
i*j 		%w
i*j*k 		%w
% A (unit) quaternion is a rotor:
q = 1 + i +j +k %w
GAprompt; %/
u = q/norm(q) 	%w
%% We can retrieve the rotation plane and angle:
bivector = sLog(u); %/
Rangle = norm(bivector); %/
Raxis = bivector/I3; %/
%% GAprompt; %/
% A quaternion can be applied to a vector, bivector etc.,
% without converting it to a matrix first
% (and without normalization).
clf; %/
x = e1; %/
draw(x,'b'); %/
axis off; %/
GAtext(1.1*x,'x','b'); %/
draw(bivector,'r'); %/
draw(Raxis,'k'); %/
label = -0.5*unit(grade(inner(x + q*x/q,bivector)/bivector,1))+ 0.1*unit(Raxis); %/
GAtext(label, 'log(q)'); %/
axis([-1 1 -1 1 -1 1]); %/
GAview([45 30]); %/
GAprompt; %/
Rx = q*x/q  %w
draw(Rx,'g'); %/
GAtext(1.1*Rx,'q x q^{-1}','k'); %/
axis([-1 1 -1 1 -1 1]); %/
GAprompt; %/
GAorbiter(360,10); %/
GAprompt; %/
% And it can be applied directly to bivectors:
B = x^(e2+e3); 
draw(B,'b'); %/
axis([-1 1 -1 1 -1 1]); %/
label = grade(meet(B,bivector),1); %/
GAtext(0.75*label,'B','b'); %/
RB = q*B/q  %w
draw(RB,'g'); %/
GAtext(0.75*q*label/q,'q B q^{-1}','k'); %/
axis([-1 1 -1 1 -1 1]); %/
GAprompt; %/
GAorbiter(360,10); %/

