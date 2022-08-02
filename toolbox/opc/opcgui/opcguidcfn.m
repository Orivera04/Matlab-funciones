function opcguidcfn(grp, event, opctoolClient, userDataChngFn)
%OPCGUIDCFN OPCTOOL data change function
%   OPCGUIDCFN(Obj,Event) updates the items in the panel on a data change
%   event.
%
%   Obj is the group object associated with the event. Event is a structure
%   that contains the Type and Data fields. Type is the event type. Data is
%   a structure containing event-specific information.
%
%   This function is called by OPCTOOL and should not be called directly by
%   the user.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd 
% $Revision: 1.1.6.1 $  $Date: 2004/03/24 20:44:51 $

% Extract the itemIDs, values, qualities and timestamps to cellarrays. Call
% updateDataChange, passing these values
data = event.Data;
itemID = {data.Items.ItemID};
value = {data.Items.Value};
quality = {data.Items.Quality};
timestamp = {data.Items.TimeStamp};
try
    opctoolClient.updateDataChange(grp.parent.Name, grp.Name, itemID, ...
        value, quality, timestamp);
catch
    % Could not update the data table, this is more than likely because the
    % panel has not been initialized yet
    % warning('opc:opcguidcfn:nodatachange', ...
    %    'Could not update data change event data');
end

% Now call the users DataChangeFcn
if ~isempty(userDataChngFn)
    if ischar(userDataChngFn)
        eval(userDataChngFn);
    elseif ~iscell(userDataChngFn)	
        feval(userDataChngFn, grp, event);
    else	
        feval(userDataChngFn{1}, grp, event, userDataChngFn{2:end});
    end
end


