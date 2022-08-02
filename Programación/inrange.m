function y = inrange(X,R,varargin)
%INRANGE tests if values are within a specified range (interval).
%   INRANGE(X,RANGE) tests if the values in X are within the range specified 
%   by RANGE.  X can be a vector or matrix.  
%
%   RANGE is a range in the form [LOW HIGH] against which each value in X will 
%   be tested.  RANGE can also be a two-column vector whose ith row is of form 
%   RANGE(i,:) = [LOW HIGH].  In this form, input X must be a vector with the
%   same length as RANGE, and each element of X is tested against the
%   range in the corresponding row of RANGE.
%
%   INRANGE(X,RANGE,BOUNDARY) specifies whether the endpoints of the specified 
%   range should be included or excluded from the interval.  The options for 
%   BOUNDARY are:
%
%       'includeboth' : Both end points included in interval (default)
%       'includeleft' : Left end point only included in interval
%       'includeright': Right end point only included in interval
%       'excludeboth' : Neither end point included in interval
%
%   If the LOW and HIGH values for RANGE are equal, that single value will be 
%   found in range only under the 'includeboth' option (default). Otherwise, 
%   for this case, no values will be found in range.
%
%   Examples:  
%      X = 1:10
%      X =
%          1     2     3     4     5     6     7     8     9    10
%
%      Y = inrange(X,[5 7.2],'includeboth')
%      Y =
%          0     0     0     0     1     1     1     0     0     0
%
%      Y = inrange(X,[5 7.2],'excludeboth')
%      Y =
%          0     0     0     0     0     1     1     0     0     0
%
%   See also ISVALID.

%Version 2: Per online comment from "Jos x" (thanks!), fixed the following:
% 1) no need for find, use logical indexing;  DONE
% 2) return a logical array (false/true) instead of a zero/one array; DONE
% 3) for a 1x2 input R you do no need the repmat, as you split it into two
%    scalars; DONE
% 4) reduce overhead: first get the size of X, than use X = X(:), and
%    finally reshape Y using the stored size of X; DONE
% 5) why not make a default value for boundary DONE
% 6) it may return some unexpected results when LOW==HIGH;  I DONT SEE IT,
%    but will add a comment.
% 7) Take a look at submission #9428 by John D'Errico how to implement
%    "boundary" effectively.  SORRY, TOO LAZY.

Narg = nargin;
error(nargchk(2,3,Narg,'struct'))
if Narg==2
    boundary = 'includeboth';
else
    boundary = varargin{1};
end


XoriginalDim = size(X);
X = X(:);

if numel(R) ~= 2,
    if ~isequal(size(R,2),2),
        error('RANGE input has too many columns.')
    end
    if ~isequal(size(R,1),numel(X))
        error('If RANGE is a matrix, X must be a vector of same length.')
    end
end
Rrep = R;

leftBound = R(:,1);
rightBound = R(:,2);
if any(leftBound > rightBound),
    error('Rows of RANGE must have form [LOW HIGH].')
end

switch boundary
    case 'includeboth',
        inRangeIX = (X >= leftBound) & (X <= rightBound);
    case 'includeleft',
        inRangeIX = (X >= leftBound) & (X < rightBound);
    case 'includeright',
        inRangeIX = (X > leftBound) & (X <= rightBound);
    case 'excludeboth',
        inRangeIX = (X > leftBound) & (X < rightBound);
    otherwise
        error('Valid options for third input are ''includeboth'', ''includeleft'', ''includeright'', ''excludeboth''.')
end

y = reshape(inRangeIX,XoriginalDim);


