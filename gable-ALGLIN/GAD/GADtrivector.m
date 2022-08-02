% 	SPANNING A TRIVECTOR
GAfigure; clc; %/
% 	SPANNING A TRIVECTOR
%
global dummy; %/
clf; %/
% 	We can also span a TRIVECTOR:
%.
e1^e2^e3 %w
% I3  is called the PSEUDOSCALAR of 3-space 
GAprompt; %/
% 	Again, there is anti-symmetry:
%.
e2^e1^e3 %w
GAprompt; %/
% 	Here's how we draw it:
draw(I3);
GAtext(0.7*e1+0.2*e3,'I3'); %/
