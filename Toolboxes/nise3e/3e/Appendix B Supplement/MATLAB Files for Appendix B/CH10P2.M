% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
% 
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch10p2) Example 10.5: We can use MATLAB to make Nyquist plots using 
% nyquist(G), where G(s) = numg/deng and G is an LTI transfer-function object. 
% Information about the plots obtained with nyquist(G) can be found by 
% left-clicking the mouse on the curve. You can find the curve's label, as well 
% as the coordinates of the point on which you clicked. Right clicking on a 
% curve emphasizes and identifies the curve. Right clicking away from a 
% curve brings up a menu. From this menu you can select (1) system responses 
% to be displayed, (2) choices for zooming, and (3) choice for grid on or off.
% We can obtain points on the plot using [re,im,w] = nyquist(G), where the 
% real part, imaginary part, and frequency are stored in re, im, and w, 
% respectively, and re and im are 3-D arrays. We can specify a range of w 
% by using, [re,im] = nyquist(G,w). We use re(:,:)',and im(:,:)' to convert 
% the arrays to column vectors. Let us look at Example 10.5 in the text.

'(ch10p2) Example 10.5'             % Display label.
clf                                 % Clear graph on screen.
numg=[1 2];                         % Define numerator of G(s).
deng=[1 0 0];                       % Define denominator of G(s).
'G(s)'                              % Display label.
G=tf(numg,deng)                     % Create and display G(s).
grid on                             % Turn on grid for Nyquist plot.
nyquist(G)                          % Make a Nyquist plot.
title('Open-Loop Frequency Response') 
                                    % Add a title to the Nyquist plot.
w=0:0.5:10;                         % Let 0<w<10 in steps of 0.5.
[re,im]=nyquist(G,w);               % Get Nyquist plot points for a range
                                    % of w.
points=[re(:,:)',im(:,:)',w']       % List specified range of points in 
                                    % Nyquist plot.
