% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% Chapter 8: Root Locus Techniques
%
% (ch8p1) Example 8.7: MATLAB allows root loci to be plotted with the 
% rlocus(GH) command, where G(s)H(s) = numgh/dengh and GH is an LTI transfer-
% function object. Points on the root locus can be selected interactively 
% using the [K,p] = rlocfind(GH) command. MATLAB then yields the gain(K) at 
% that point as well as all other poles(p) that have that gain. We can zoom 
% in and out of the root locus by changing the range of axis values using 
% the command axis([xmin,xmax,ymin,ymax]). The root locus can be drawn 
% over a grid that shows constant damping ratio(z) and constant natural 
% frequency(wn) curves using the sgrid(z,wn) command. To plot multiple 
% z and wn curves use z = zmin:zstep:zmax and wn = wnmin:wnstep:wnmax to 
% specify a range of values. 

'(ch8p1) Example 8.7'               % Display label.
clf                                 % Clear graph on screen.
numgh=[1 -4 20];                    % Define numerator of G(s)H(s).
dengh=poly([-2 -4]);                % Define denominator of G(s)H(s).
'G(s)H(s)'                          % Display label.
GH=tf(numgh,dengh)                  % Create G(s)H(s) and display.
rlocus(GH)                          % Draw root locus.
z=0.2:0.05:0.5;                     % Define damping ratio values: 0.2 to
                                    % 0.5in steps of 0.05.
wn=0:1:10;                          % Define natural frequency values: 0 
                                    % to 10 in steps of 1.
sgrid(z,wn)                         % Generate damping ratio and natural 
                                    % frequency grid lines for root
                                    % locus.
title('Root Locus')                 % Define title for root locus.
pause
rlocus(GH)                          % Draw close-up root locus.
axis([-3 1 -4 4])                   % Define range on axes for root locus
                                    % close-up view.
title('Close-up')                   % Define title for close-up root
                                    % locus.
z=0.45;                             % Define damping ratio line for 
                                    % overlay on close-up root locus.
wn=0;                               % Suppress natural frequency overlay 
                                    % curves.
sgrid(z,wn)                         % Overlay damping ratio curve on
                                    % close-up root locus.
for k=1:3                           % Loop allows 3 points to be selected 
                                    % as per Example 8.7
                                    % (z=0.45, jw crossing, breakaway).
[K,p]=rlocfind(GH)                  % Generate gain, K, and closed-loop 
                                    % poles, p, 
                                    % for point selected interactively on
                                    % the root locus.
end                                 % End loop.
