function opcguistopfn(grp, event, node, grpLoggingPanel, userStopFn)
%OPCGUISTOPFN OPCTOOL logging callback function
%   OPCGUISTOPFN(Obj,Event) selects the current node and updates the panel.
%
%   Obj is the group object associated with the event. Event is a structure
%   that contains the Type and Data fields. Type is the event type. Data is
%   a structure containing event-specific information.
%
%   This function is called by OPCTOOL and should not be called directly by
%   the user.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd 
% $Revision: 1.1.6.2 $  $Date: 2004/03/24 20:44:55 $

grpLoggingPanel.updateStopIfSelected(node);

% Now call the users StopFunction
if ~isempty(userStopFn)
    if ~iscell(userStopFn)	
        feval(userStopFn, grp, event);
    else	
        feval(userStopFn{1}, grp, event, userStopFn{2:end});
    end
end


