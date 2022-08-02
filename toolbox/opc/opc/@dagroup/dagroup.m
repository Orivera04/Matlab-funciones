function this = dagroup(varargin)
% DAGROUP Constructor for the dagroup class.
%   To add groups to an opcda object, OPCDA/ADDGROUP must be used. If daObj
%   is an opcda object ADDGROUP(daObj,'MyGroup') adds a group called
%   MyGroup to opcda object daObj.
%
%   See also OPCDA/ADDGROUP

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.6 $  $Date: 2004/03/24 20:42:52 $

if (nargin == 1) && ...
        (strcmp(class(varargin{1}), 'opc.dagroup') || ...
        strcmp(class(varargin{1}), 'struct'))
    this = struct;
    this = class(this,'dagroup',opcroot(varargin{1}));
else
    rethrow(mkerrstruct('opc:dagroup:arginvalid','Create dagroup objects by calling the addgroup method on a valid opc object.'));
end