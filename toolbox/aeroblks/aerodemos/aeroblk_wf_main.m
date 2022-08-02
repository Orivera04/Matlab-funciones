% This is the master script for the 1903 Wright Flyer demo.
% The first action required is to determine what products the user has.
% The options are:
%
%    1. Virtual Reality are detected, and the complete visualization is used.
%   
%    2. The user only has Simulink (No Virtual Reality):
%       -- In this case the 1903 Wright Flyer model is shown with scopes only

% Copyright 1990-2003 The MathWorks, Inc.
% $Revision: 1.1.6.1 $  $Date: 2003/07/27 04:20:03 $


% determine which model should open based on available toolboxes

if  exist('vr','dir')==7
    disp('Virtual Reality Toolbox has been detected')
    modelName = 'aeroblk_wf_3dof';
else
    modelName = 'aeroblk_wf_3dof_noVR';
end

open_system(modelName)







