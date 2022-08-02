% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 Copyright © 2000 by
% John Wiley & Sons, Inc.
%
'(apDex1) Example D.1'                    %Display label.
'LTI Viewer for Chapter 4, Example 4.8'   %Display label.   
'Step response'                           %Display label.
'T1(s)'                                   %Display label.
T1=tf(24.542,[1 4 24.542])                %Create T1.
'T2(s)'                                   %Display label.
T2=tf(245.42,conv([1 10],[1 4 24.542]))   %Create T2. 
'T3(s)'                                   %Display label.
T3=tf(73.626,conv([1 3],[1 4 24.542]))    %Create T3.
ltiview                                   %Call up LTI Viewer.                                 
 