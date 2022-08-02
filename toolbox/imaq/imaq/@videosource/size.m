function varargout = size(obj,varargin)
%SIZE Size of image acquisition object array.  
%
%    D = SIZE(OBJ), for M-by-N image acquisition object, OBJ, returns the 
%    two-element row vector D = [M, N] containing the number of rows
%    and columns in the image acquisition object array, OBJ.  
%
%    [M,N] = SIZE(OBJ) returns the number of rows and columns in separate
%    output variables.  
%
%    [M1,M2,M3,...,MN] = SIZE(OBJ) returns the length of the first N 
%    dimensions of OBJ.
%
%    M = SIZE(OBJ,DIM) returns the length of the dimension specified by the 
%    scalar DIM. For example, SIZE(OBJ,1) returns the number of rows.
% 
%    See also IMAQHELP.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:52 $

% Error checking.
if ~isa(obj, 'imaqchild'),
    errID = 'imaq:size:invalidType';
    error(errID, imaqgate('privateMsgLookup',errID));
end

% Determine the number of output arguments.
numOut = nargout;
if (numOut == 0)
    % If zero output modify to 1 (ans) so that the expression below
    % evaluates without error.
    numOut = 1;
end

% Call the builtin size function on the UDD object.  The uddobject field
% of the object indicates the number of objects that are concatenated
% together.
try
    [varargout{1:numOut}] = builtin('size', obj.uddobject, varargin{:});
catch
    rethrow(lasterror);
end	
