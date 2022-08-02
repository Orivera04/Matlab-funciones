%

% This is the master script for the HL-20 demo.
% The first action required is to determine what products the user has.
% The options are:
%
%    1. Both Dials and Gauges and Virtual Reality are detected, and the 
%       complete visualization is used.
%   
%    2. The user has Dials and Gauges and not Virtual Reality:
%	-- In this case the model does not have the VRML world in it
%    
%    3. The user has Virtual Reality  and not Dials and Gauges:
%       -- In this case a model without gauges is used
%
%    4 The user only has Simulink (No Virtual Reality or Dials and Gauges):
%       -- In this case the HL-20 model is shown with scopes only

% Copyright 1990-2003 The MathWorks, Inc.
% $Revision: 1.3.2.4 $  $Date: 2004/04/06 01:04:24 $


% determine which model should open based on available toolboxes

if (exist('dials','dir')==7 && exist('vr','dir')==7 && strcmp(computer,'PCWIN'))
    modelName = 'aeroblk_HL20';
   
elseif (exist('dials','dir')==7 && ~exist('vr','dir')==1 && ... 
                                                     strcmp(computer,'PCWIN'))
   disp('Dials and Gauges Blockset has been detected.')
   modelName = 'aeroblk_HL20_DG';
    
elseif (exist('vr','dir')==7 && (~strcmp(computer,'HPUX'))) % looking for dials earlier for PC
   disp('Virtual Reality Toolbox has been detected')
   modelName = 'aeroblk_HL20_VR';

 else
   modelName = 'aeroblk_HL20_noVRnoDG';
end

open_system(modelName)







