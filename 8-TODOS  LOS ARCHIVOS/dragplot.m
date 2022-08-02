% DRAGPLOT allows plotted lines to be dragged from one figure window and
% dropped into another.  Type DRAGPLOT to enable lines in the CURRENT
% figure window to be moved.  Press and hold the left mouse button to
% select a line object and drag it to the new figure window.  When you 
% release the mouse button, the line will be moved.  It will be removed
% from the old window. If you hold down the CRTRL key while you drag and
% drop, the line object will be copied to the new window.  If you drop
% the line object outside of a figure window, it will be deleted. You
% can enable DRAGPLOT on as many open figure windows as you desire.
% The DRAGPLOT feature is suppressed while the figure window is in zoom
% mode.  It will be enabled when zoom is turned off.
%
% Example:
%   figure; plot(rand(1,30),'r'); dragplot
%   figure; plot(cos(2*pi*[0:32]/11),'b'); dragplot
% Now drag and drop the cosine curve or the random plot from one figure
% window to the other.

% NOTES:
% This script modifies the "WindowButtonDownFcn" and "WindowButtonUpFcn"
% properties, and creates an application data object named "dragplot" in
% the figure window to which it is applied.
%
% If the receiving figure contains subplots, the CURRENT subplot will
% receive the dragged plot.  If you desire to drop the plot into a
% different subplot, issue a SUBPLOT command to select the desired subplot
% before dragging and dropping.

% Version 1.0
% Mark W. Brown
% mwbrown@ieee.org

set(gcf,'windowbuttondownfcn',[...                  % When a mouse click occurs,
        't = get(gco,''type'');',...                % get the type of object clicked on.
        'if strcmp(t,''line'');',...                % If it's a line object,
          'set(gco,''selected'',''on'');',...       % mark it selected,
          'set(gcf,''pointer'',''fleur'');',...     % change the pointer,
          'setappdata(gcf,''dragplot'',gco);',...   % and store the object handle for later.
        'end'])

set(gcf,'windowbuttonupfcn',[...                    % When the mouse button is released,
        'f = get(0,''pointerwindow'');',...         % determine which figure window it's over.
        'h = getappdata(gcf,''dragplot'');',...     % Retrieve the handle to the line object.
        'if f > 0;',...                             % If it's a valid figure window,
          'c = get(f,''currentaxes'');',...         % then determine the current axes,
          's = get(h,''selected'');',...            % and the selection state of the object.
          'if strcmp(s,''on'');',...                % If the object was marked as selected,
            't = get(gcf,''selectiontype'');',...   % determine whether the CTRL key was pressed too.
            'if strcmp(t,''alt''),',...             % If CTRL was pressed,
              'n = copyobj(h,c);',...               % then we'll make a copy of the object.
              'set(n,''selected'',''off'');',...    % Deselect the new copy,
              'set(h,''selected'',''off'');',...    % and deselect the original copy.
            'else,',...                             % Otherwise, this is a MOVE operation.
              'set(h,''parent'',c);'...             % So assign the line object to it's new parent,
              'set(h,''selected'',''off'');',...    % and deselect it.
            'end;',...
          'end;',...
        'else;',...                                 % If it's not a valid figure window,
           'delete(h);',...                         % then delete the line object.
        'end;',...
        'set(gcf,''pointer'',''arrow'');'])         % Restore pointer when finished.
