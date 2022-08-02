function varargout = size(obj, varargin)
%SIZE Size of an OPC Toolbox object
%    D = SIZE(Obj), for M-by-N OPC Toolbox object, Obj, returns the 
%    two-element row vector D = [M, N] containing the number of rows
%    and columns in the image acquisition object array, Obj.  
%
%    [M,N] = SIZE(Obj) returns the number of rows and columns in separate
%    output variables.  
%
%    M = SIZE(OBJ,DIM) returns the length of the dimension specified by the 
%    scalar DIM. For example, SIZE(OBJ,1) returns the number of rows.
% 
%    See also OPCHELP.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.3 $  $Date: 2004/02/01 22:07:06 $

n = max(nargout, 1);    % Catch the case where no outputs requested
try
    [varargout{1:n}] = builtin('size', obj.uddobject, varargin{:});
catch
    rethrow(mkerrstruct(lasterror));
end	