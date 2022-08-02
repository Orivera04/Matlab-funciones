% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 Copyright © 2000 by
% John Wiley & Sons, Inc.
%
'(apDex5) Example D.5'          %Display label.
'LTI Viewer for Chapter 13'     %Display label.
'Digital step response'         %Display label.
'G(z)'                          %Display label.
G=tf([1 -0.214],[1 -0.607],0.5) %Create sampled transfer funtion.
'T(z)'                          %Display label.
T=G/(1+G)                       %Calculate closed-loop sampled
                                %transfer function for unity 
                                %feedback sampled system.
ltiview                         %Call LTI Viewer.


