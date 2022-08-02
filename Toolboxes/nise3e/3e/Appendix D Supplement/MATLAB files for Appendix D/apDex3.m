% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 Copyright © 2000 by
% John Wiley & Sons, Inc.
%
'(apDex3) Example D.3'           %Display label.
'LTI Viewer for Chapter 10, Example 10.10'
                                 %Display label.
'Bode plot'                      %Display label.
numg=200;                        %Create numerator of G(s).
deng=poly([-2 -4 -5]);           %Create denominator of G(s).
'G(s)'                           %Display label.
G=tf(numg,deng)                  %Create and display G(s).
ltiview                          %Call up LTI Viewer.

