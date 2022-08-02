function opcguirecacqfn(grp, event, node, grpLoggingPanel, userRecAcqFn)
%OPCGUIRECACQTFN OPCTOOL logging callback function
%   OPCGUIRECACQTFN(Obj,Event) updates the OPC GUI logging progress bar.
%
%   Obj is the group object associated with the event. Event is a structure
%   that contains the Type and Data fields. Type is the event type. Data is
%   a structure containing event-specific information.
%
%   This function is called by OPCTOOL and should not be called directly by
%   the user.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd 
% $Revision: 1.1.6.2 $  $Date: 2004/03/24 20:44:53 $

% Update the logging panel
percentComplete = round(grp.recordsAcquired/grp.RecordsToAcquire*100);
grpLoggingPanel.updateStatusIfSelected(node,grp.recordsAvailable,percentComplete);

% Now call the users RecordsAcquiredFunction
if ~isempty(userRecAcqFn)
    if ischar(userRecAcqFn)
        eval(userRecAcqFn);
    elseif ~iscell(userRecAcqFn)	
        feval(userRecAcqFn, grp, event);
    else	
        feval(userRecAcqFn{1}, grp, event, userRecAcqFn{2:end});
    end
end


