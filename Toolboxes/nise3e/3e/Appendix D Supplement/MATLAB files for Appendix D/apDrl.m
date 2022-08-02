% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 Copyright © 2000 by
% John Wiley & Sons, Inc.
%
'(apDrl) Example for Section D.6'   
                            %Display label.
'Root Locus Design GUI'     %Display label.
clear workspace             %Clear all variables.
G=tf(1,conv([1 2],[1 2 2])) %Create transfer function
                            %1/[(s+2)(s^2+2s+2]).
rltool                      %Call Root Locus Design GUI.