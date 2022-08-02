function status = isvalid(obj)
%ISVALID True for OPC Toolbox objects that are not deleted.
%   A = ISVALID(Obj) returns a logical array, A, that contains false where
%   the elements of Obj are deleted OPC Toolbox objects and true where the
%   elements of Obj are valid objects.
%
%   An invalid OPC Toolbox object should be cleared from the workspace
%   with CLEAR.
%
%   Examples
%       da(1) = opcda('localhost','Dummy.ServerA');
%       da(2) = opcda('localhost','Dummy.ServerB');
%       out1 = isvalid(da)
%       delete(da(1))
%       out2 = isvalid(da)
%       clear da
%
%   See also OPCDA/DELETE, OPCHELP.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.2 $  $Date: 2004/02/01 22:06:40 $

status = ishandle(getudd(obj));
