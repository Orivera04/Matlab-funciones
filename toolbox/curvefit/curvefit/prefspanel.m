function prefspanel
%PREFSPANEL Registers a Curve Fitting Toolbox preferences control panel.
%   PREFSPANEL registers a Preferences Control panel with the MATLAB IDE.

%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.3.2.2 $  $Date: 2004/02/01 21:42:48 $

% Register Object-based Context menus items in the Workspace Browser.

%   Methods of MatlabObjectMenuRegistry are unsupported.  Calls to these
%   methods will become errors in future releases.
com.mathworks.mlwidgets.workspace.MatlabCustomClassRegistry.registerClassCallbacks(...
    {'cfit'},...
    'Plot CFIT object',...
    {'Estimated Function',...
     'Prediction Bounds for Function',...
     'Prediction Bounds for Observation'...
     'First Derivative',...
     'Second Deriviative',...
     'Integral',...
    },...
    {'plot($1); shg;',...
     'plot($1,''predfunc''); shg;',...
     'plot($1,''predobs''); shg;'...
     'plot($1,''deriv1''); shg;'...
     'plot($1,''deriv2''); shg;'...
     'plot($1,''integral''); shg;'...
    });

% [EOF]
