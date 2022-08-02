function opcreset
%OPCRESET Disconnect and delete all OPC Toolbox objects.
%   OPCRESET disconnects and deletes all OPC Toolbox objects. Any data
%   that is stored in the buffer is flushed, all asynchronous operations
%   are cancelled, and open log files are closed.
%
%   You cannot reconnect an OPC Toolbox object to the server after it has
%   been deleted. Therefore, you should remove it from the workspace with
%   the CLEAR function.
%
%   Examples
%       da = opcda('localhost','Dummy.Server');
%       grp = addgroup(da);
%       opcreset;  % Deletes all objects
%       opcfind
%       % No objects found. Clear the original variables
%       clear da grp
%
%   See also CLEAR, OPCDA/DELETE, OPCFIND.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.3 $  $Date: 2004/02/01 22:06:55 $

% Find the objects in the engine, and delete them
opcobjs = opcfind;
for k=1:length(opcobjs)
    delete(opcobjs{k})
end
opcmex('reset');
