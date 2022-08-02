%	ROTATION BY ROTORS
GAfigure; clc; %/
%	ROTATION BY ROTORS
global plane angle i phi Raxis; %/
clf; %/
%
% 	Making a rotor:
%
%% plane = e1^(e2+e3/4);
plane = e1^e2;
angle = pi/4;
i = plane; %/
phi = angle; %/
R = gexp(-plane*angle/2) %w %%
% 	Applying the rotor:
x = e1 + e3;
draw(x,'r'); %/
axis([-1 1 -1 1 -1 1]); %/
axis off; %/
GAtext(0.7*x+0.1*unit(grade(inner(x,plane)/plane,1)),'x'); %/
draw(plane*angle); %/
GAview([15 30]); %/
axis([-1 1 -1 1 -1 1]); %/
GAtext(0.1*plane/I3-0.3*unit(grade(inner(x,plane)/plane,1)),'i \phi'); %/
%% GAprompt; %/
%% GAorbiter(-330,5); %/
r = R*x/R %w
draw(r,'m'); %/
axis([-1 1 -1 1 -1 1]); %/
title(['rotor R = e^{-i \phi /2}'],'Color','b'); %/
GAtext(0.9*r+0.1*unit(grade(inner(r,plane)/plane,1)),'R x R^{-1}'); %/
GAprompt; %/
title(''); %/
GAorbiter(-360,5); %/
% In 3-space, you could characterize the rotation by an axis:
Raxis = plane/I3 %w
draw(Raxis,'k'); %/
axis([-1 1 -1 1 -1 1]); %/
GAtext(1.1*Raxis,'i \phi / I_3'); %/
GAprompt; %/
%% =======>   To many rotations?     GAorbiter(-360,5); %/
% Now rotate a bivector.
B = 0.7*x^(e1+e2);
draw(B,'w'); %/
axis([-1 1 -1 1 -1 1]); %/
Blabel = -0.75*unit(meet(B,i)); %/
GAtext(Blabel,'B'); %/
%% GAprompt; %/
RB = R*B/R %w
draw(RB,'y'); %/
axis([-1 1 -1 1 -1 1]); %/
GAtext(R*Blabel/R,'R B R^{-1}'); %/
GAprompt; %/
GAorbiter(-400,10); %/
