% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 Copyright © 2000 by
% John Wiley & Sons, Inc.
%
'(apDex2) Example D.2'              %Display label.
'LTI Viewer for Chapter 10 Example 10.8'
                                    %Display label.
'Nyquist diagram'                   %Display label.
numg=6;                             %Create numerator of G(s).
deng=conv([1 2],[1 2 2]);           %Create denominator of G(s).
'G(s)'                              %Display label.
G=tf(numg,deng)                     %Create and display G(s).
ltiview                             %Call up LTI Viewer.


