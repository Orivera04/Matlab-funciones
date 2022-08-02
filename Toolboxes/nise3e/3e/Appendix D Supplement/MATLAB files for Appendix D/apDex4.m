% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 Copyright © 2000 by
% John Wiley & Sons, Inc.
%
'(apDex4) Example D.4'   %Display label.
'LTI Viewer for Chapter 10, Figure 10.47'
                         %Display label.
'Nichols chart'          %Display label.
numg=1;                  %Create numerator for G(s).
deng=poly([0 -1 -2]);    %Create denominator for G(s).
'G(s)'                   %Display label.
G=tf(numg,deng)          %Create G(s).
ltiview                  %Call up LTI Viewer.

