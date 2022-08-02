% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% Chapter 10: Frequency Response Techniques
%
% (ch10p1) Example 10.3: We can use MATLAB to make Bode plots using 
% bode(G), where G(s) = numg/deng and G is an LTI transfer-function object. 
% Information about the plots obtained with bode(G) can be found by left-clicking 
% the mouse on the curve. You can find the curve's label, as well as 
% the coordinates of the point on which you clicked. Right clicking 
% on a curve emphasizes and identifies the curve. Right clicking away 
% from a curve brings up a menu. From this menu you can select 
% (1) system responses to be displayed, (2) response characteristics to 
% be displayed, (3) choices for zooming, and (4) choice for grid on or off. 
% If you select a response characteristic, an appropriate point is displayed 
% on the plot. Clicking on the point reveals measurements of the selected 
% characteristic. We can obtain points on the plot using 
% [mag,phase,w] = bode(G), where magnitude, phase, and frequency are stored in 
% mag, phase, and w, respectively, Magnitude and phase are stored as 3-D arrays. 
% We use mag(:,:)',phase(:,:)' to convert the arrays to column vectors, where the 
% apostrophe signifies matrix transpose. Let us look at Example 10.3 in 
% the text.

'(ch10p1) Example 10.3'             % Display label.
clf                                 % Clear graph on screen.
numg=[1 3];                         % Define numerator of G(s).
deng=conv([1 2],[1 2 25]);          % Define denominator of G(s).
'G(s)'                              % Display label.
G=tf(numg,deng)                     % Create and display G(s).
grid on                             % Turn on grid for Bode plot.
bode(G)                             % Make a Bode plot.
title('Open-Loop Frequency Response')		
                                    % Add a title to the Bode plot.
[mag,phase,w]=bode(G);              % Store points on the Bode plot.
points=[20*log10(mag(:,:))',phase(:,:)',w]	
                                    % List points on Bode plot with 
                                    % magnitude in dB.
