function handles = setuihandles(hui)
%SETUIHANDLES Set handles for the Capital Allocation demo.
% Find all handles in the UI.

% Author(s): M. Reyes-Kattar, 03/05/98
% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.8 $   $Date: 2002/04/14 21:47:51 $

% Find all the interesting handles in the UI
% h = findobj(objhandles,'PropertyName',PropertyValue)
handles.hRfEdit = findobj(hui, 'Tag', 'RfEdit');
handles.hRbEdit = findobj(hui, 'Tag', 'RbEdit');
handles.hAEdit  = findobj(hui, 'Tag', 'AEdit');

handles.hRfSlider = findobj(hui, 'Tag', 'RfSlider');
handles.hRbSlider = findobj(hui, 'Tag', 'RbSlider');
handles.hASlider =  findobj(hui, 'Tag', 'ASlider');

handles.hRiskOverallText = findobj(hui, 'Tag', 'OverallRiskText');
handles.hRiskRiskyText   = findobj(hui, 'Tag', 'RiskyRiskText');
handles.hRoROverallText  = findobj(hui, 'Tag', 'OverallRoRText');
handles.hRoRRiskyText    = findobj(hui, 'Tag', 'RiskyRoRText');

% Keep the handles to the interesting UIControls in the figure's UserData
% set(H,'PropertyName',PropertyValue)
set(hui, 'userdata', handles);
