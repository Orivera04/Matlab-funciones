function [cleanObj, rFlag] = cleanup(Obj)
%CLEANUP Remove invalid objects from a DAITEM vector
%   [CleanObj, RFlag] = cleanup(Obj) removes all invalid objects from the DAITEM
%   vector Obj. RFlag is set to TRUE if any objects were removed, and to
%   FALSE if no objects were removed.
%
%   This function is intended for internal use only.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.2 $ $Date: 2004/02/01 22:06:05 $

rFlag = false;
if isempty(Obj),
    cleanObj = [];
else
    rFlag = any(~isvalid(Obj));
    cleanObj = subsref(Obj, struct('type', '()', 'subs', {{isvalid(Obj)}}));
end