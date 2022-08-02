% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch10p6): We can use MATLAB to plot Nichols charts using nichols(G), 
% where G(s) = numg/deng and G is an LTI transfer-function object. The 
% Nichols grid can be added using the ngrid command before the nichols(G) 
% command. Information about the plots obtained with nichols(G) can be 
% found by left-clicking the mouse on the curve. You can find the curve's 
% label, as well as the coordinates of the point on which you clicked. 
% Right clicking on a curve emphasizes and identifies the curve. Right 
% clicking away from a curve brings up a menu. From this menu you can
% select (1) system responses to be displayed, (2) choices for zooming, 
% and (3) choice for grid on or off. Let us make a Nichols chart of 
% G(s) = 1/[s(s+1)(s+2)].

'(ch10p6)'                          % Display label.
clf                                 % Clear graph on screen.
numg=1;                             % Define numerator of G(s).
deng=poly([0 -1 -2]);               % Define denominator of G(s).
'G(s)'                              % Display label.
G=tf(numg,deng)                     % Create and display G(s).
grid on                             % Turn on graph grid.
ngrid                               % Add Nichols grid.
nichols(G)                          % Make a Nichols plot.
