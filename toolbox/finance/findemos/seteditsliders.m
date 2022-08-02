function seteditsliders(hui)
%SETEDITSLIDERS This function connects the edit controls and the sliders.

% Author(s): M. Reyes-Kattar, 03/05/98
%   Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.8 $   $Date: 2002/04/14 21:42:41 $

handles = get(hui, 'userdata');

% Save the handle of the edit control inside the userdata of the slider
% set(H,'PropertyName',PropertyValue)
set(handles.hRfSlider, 'userdata', handles.hRfEdit);
set(handles.hRbSlider, 'userdata', handles.hRbEdit);
set(handles.hASlider, 'userdata', handles.hAEdit);

% Save the handle of the slider inside the userdata of the edit control
set(handles.hRfEdit, 'userdata',handles.hRfSlider );
set(handles.hRbEdit, 'userdata',handles.hRbSlider );
set(handles.hAEdit, 'userdata',handles.hASlider );

set(handles.hRfSlider, 'callback', 'set( get(gco, ''userdata''), ''String'', num2str(get(gco, ''value'')));capaldemo(''update'')');

set(handles.hRfEdit, 'callback', 'set( get(gco, ''userdata''), ''value'', str2double(get(gco, ''String'')));capaldemo(''update'')');

set(handles.hRbSlider, 'callback', 'set( get(gco, ''userdata''), ''String'', num2str(get(gco, ''value'')));capaldemo(''update'')');

set(handles.hRbEdit, 'callback', ['val = str2double(get(gco, ''String''));' ...
      'if( isempty(val)| isnan(val)) val = 0.085; end;', ...
      'set( get(gco, ''userdata''), ''value'', val); capaldemo(''update'')']);

set(handles.hASlider, 'callback', 'set( get(gco, ''userdata''), ''String'', num2str(get(gco, ''value'')));capaldemo(''update'')');
set(handles.hAEdit, 'callback', 'set( get(gco, ''userdata''), ''value'', str2double(get(gco, ''String'')));capaldemo(''update'')');
