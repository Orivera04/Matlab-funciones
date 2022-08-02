function [cleanObj, rFlag] = cleanup(Obj)
%CLEANUP Remove invalid objects from a OPCDA vector and its children
%   [CleanObj, RFlag] = cleanup(Obj) removes all invalid objects from the OPCDA
%   vector Obj, and also removes any invalid DAGROUP and DAITEM objects
%   contained within those OPCDA objects. RFlag is set to TRUE if any
%   objects were removed, and to FALSE if no objects were removed.
%
%   This function is intended for internal use only.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.2 $ $Date: 2004/02/01 22:06:12 $

rFlag = false;
if isempty(Obj),
    cleanObj = [];
else
    % Call subsref explicitly
    rFlag = any(~isvalid(Obj));
    cleanObj = subsref(Obj, struct('type', '()', 'subs', {{isvalid(Obj)}}));
    uddObj = uddhandles(cleanObj);
    % We have to use a subsref/subsasgn idea here
    for thisUdd=uddObj(:)'
        % Clean up my children
        if ~isempty(thisUdd.Group),
            [newGroup, rFlag] = cleanup(thisUdd.Group);
            thisUdd.udsetchild(newGroup);
        end
    end
end