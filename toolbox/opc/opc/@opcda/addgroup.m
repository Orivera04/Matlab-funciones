function grp = addgroup(obj, varargin)
%ADDGROUP Add a data access group to an opcda object.
%   Gobj = ADDGROUP(Obj) adds a group to the opcda object Obj. A group is
%   a container for a client to organize and manipulate data items.
%   Typically, you create different groups to support different update
%   rates, activation status, callbacks, etc.
%
%   Gobj is a dagroup object. By default, Gobj has the Active property set
%   to 'on', and GroupType set to 'private' and the Subscription property
%   set to 'on'.
%
%   If Obj is already connected to the server when ADDGROUP is called, a
%   group name is requested from the server. If the server does not supply
%   a group name, or the object is not connected to a server, a unique
%   name is automatically assigned to Gobj. The unique name follows the
%   convention 'groupN' where N is an integer. You can change this name
%   with the group's Name property.
%
%   Gobj = ADDGROUP(Obj,'GName') adds a group to the OPC data access
%   object Obj with group name given by GName. The group name must be
%   unique among other group names within Obj.
%
%   You can add data access items to Gobj using the ADDITEM function.
%
%   See also DAGROUP/ADDITEM, OPCSERVERINFO.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.8 $  $Date: 2004/03/24 20:43:07 $

errorargmsg = nargchk(1,3,nargin);
if ~isempty(errorargmsg)
    rethrow(mkerrstruct('opc:addgroup:inargs',errorargmsg));
end

grp = [];
if length(obj)>1
    rethrow(mkerrstruct('opc:addgroup:vecnotsupported'));
end

if ~isvalid(obj)
    rethrow(mkerrstruct('opc:addgroup:objinvalid'));
end

uddopcda = getudd(obj);

% If the opcda object is disconnected then this constructor will
% either create a unique name or ensure that the name is unique
try
    if ~strcmp(get(obj,'Status'),'connected')
        if nargin>=2
            if isempty(varargin{1}) || ~ischar(varargin{1})
                rethrow(mkerrstruct('opc:addgroup:groupnamearg'));
            end
            if any(strcmp(get(get(obj,'Group'),'Name'),varargin{1}))
                rethrow(mkerrstruct('opc:addgroup:groupnamedup'));
            end
            uddgrp = opcmex('addgroup',uddopcda,varargin{:});
        elseif nargin==1
            uddgrp = opcmex('addgroup',uddopcda,newdefaultname(obj));
        end
    else
        if nargin == 1
            % Try to add with an empty name on the server. If this fails
            % (some servers don't support) then generate a client default
            % name and try again
            try
                uddgrp = opcmex('addgroup',uddopcda,'');
            catch
                uddgrp = opcmex('addgroup',uddopcda,newdefaultname(obj));
            end
        else
            uddgrp = opcmex('addgroup',uddopcda,varargin{:});
        end
    end

    % Wrap the group in an OOPS object
    grp = dagroup(uddgrp);

    % Set the UDD object's OOPS representation to the MATLAB OOPS object.
    udsetoops(uddgrp, grp);

    % Update the Group property of the OPCDA object.
    % Be careful. We need a row vector here!
    if size(grp, 1)>1,
        newGroup = horzcat(get(obj, 'Group'), grp');
    else
        newGroup = horzcat(get(obj,'Group'), grp);
    end
    udsetchild(uddopcda, newGroup);
catch
    rethrow(mkerrstruct(lasterror));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function name = newdefaultname(opcobj)
childNames = get(get(opcobj,'Group'),'Name');
if ischar(childNames)
    childNames = {childNames};
end
groupInd = find(strncmp(childNames,'group',5));
groupNums = 0;
%TODO: Remove the for loop here!
for k = 1:length(groupInd)
    thisName = childNames{groupInd(k)};
    groupNums = [groupNums, str2double(thisName(6:end))];
end
allPossibleNums = 1:(max(groupNums)+1);
% The new name is created by finding the smallest number which has not
% already been assigned to a group name
name = sprintf('group%d', min(setdiff(allPossibleNums,groupNums)));
