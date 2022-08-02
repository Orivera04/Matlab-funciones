function [cleanObj, rFlag] = cleanup(Obj)
%CLEANUP Remove invalid objects from a DAGROUP vector and its children
%   [CleanObj, RFlag] = cleanup(Obj) removes all invalid objects from the DAGROUP
%   vector Obj, and also removes the invalid objects found in the Item
%   property of each valid group. RFlag is set to TRUE if any
%   objects were removed, and to FALSE if no objects were removed.
%
%   This function is intended for internal use only.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.2 $ $Date: 2004/02/01 22:05:52 $

rFlag = false;
if isempty(Obj),
    cleanObj = [];
else
    rFlag = any(~isvalid(Obj));
    % Call subsref explicitly
    cleanObj = subsref(Obj, struct('type', '()', 'subs', {{isvalid(Obj)}}));
    % We have to use a subsref/subsasgn idea here
    uddObj = getudd(cleanObj);
    for thisUdd = uddObj(:)'
        % Clean up my children, and reset using the amazing setChild
        % method!
        if ~isempty(thisUdd.Item),
            [newItem, rFlag] = cleanup(thisUdd.Item);
            thisUdd.udsetchild(newItem);
        end
    end
end