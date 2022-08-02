function out = isequal(varargin)
%ISEQUAL True if image acquisition object arrays are equal.
%
%    ISEQUAL(A,B) is 1 if the two image acquisition object arrays are 
%    the same size and are equal, and 0 otherwise.
%
%    ISEQUAL(A,B,C,...) is 1 if all the image acquisition object arrays
%    are the same size and are equal, and 0 otherwise.
% 
%    See also IMAQDEVICE/EQ, IMAQDEVICE/NE.
%

%    CP 9-02-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:22 $

% Error checking.
if nargin == 1
    errID = 'imaq:isequal:minrhs';
    error(errID, imaqgate('privateMsgLookup', errID));            
end

% Loop through all the input arguments and compare to each other.
for i=1:nargin-1
    obj1 = varargin{i};
    obj2 = varargin{i+1};
    
    % Return 0 if either arguments are empty.
    if isempty(obj1) || isempty(obj2)
        out = false;
        return;
    end
    
    % Inputs must be the same size.
    if ~(all(size(obj1) == size(obj2))) 
        out = false;
        return;
    end
    
    % Call eq overload.
    out = eq(obj1, obj2);
    
    % If not equal, return 0 otherwise loop and compare obj2 with 
    % the next object in the list.
    if (all(out) == 0)
        out = false;
        return;
    end
end

% Return just a 1 or 0.  
% Ex. isequal(obj, obj)  where obj = [obj obj obj]
% eq returns [1 1 1] isequal returns 1.
out = all(out);