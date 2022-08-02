function [hJava, hUDD] = slparamestim(varargin)
% SLPARAMESTIM Method to start/configure Simulink Parameter Estimation from
% Simulink or the workspace.
% VARARGIN : 'initialize' flag, model name, project handle.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.9 $ $Date: 2004/04/19 01:33:13 $

% Get the simulink model name
if isa(varargin{2}, 'char')
  model = varargin{2};
else
  try
    model = get_param(varargin{2}, 'Name');
  catch
    error('Invalid Simulink diagram handle.');
  end
end
open_system(model);

% Get the handle to the project and the frame
if (nargin == 3) && isa(varargin{3}, 'explorer.Project')
  project = varargin{3};
  FRAME   = slctrlexplorer;
else
  [project, FRAME] = getvalidproject(model,false);
  if isempty(project)
    return;
  end
end

% Switchyard for GUI interaction with Simulink
switch varargin{1}
case 'initialize'
  % Create the waitbar
  wb = waitbar(0, 'Simulink Parameter Estimation', ...
                  'Name', 'Simulink Parameter Estimation');
  pause(0.5);
  waitbar(0.2, wb, 'Loading Simulink Parameter Estimation...');
  pause(0.5)
    
  % Update the waitbar
  waitbar(0.5, wb, 'Creating the GUIs...')
  pause(0.5)
  
  % Create an estimation node
  waitbar(0.6, wb, 'Creating an estimation task...')
  h = spenodes.EstimationProject(project, model);
  
  % Add it to the Workspace
  waitbar(0.7, wb, 'Attach the project to the GUI...');
  project.addNode(h);
    
  % Set the Settings node to be the current selected
  FRAME.setSelected( h.getTreeNodeInterface );
  waitbar(1.0, wb, 'Simulink Parameter Estimation is ready.');
  close(wb);

  drawnow
  FRAME.setVisible(1);
  
  % Set the project dirty flag
  project.Dirty = 1;
end               

if nargout > 0 
  [hJava, hUDD] = slctrlexplorer;
end
