function bMono = ismonotonic(x, bStrict, direction, dim)
% ISMONOTONIC(X) returns a boolean value indicating whether or not a vector is monotonic.  
% By default, ISMONOTONIC returns true for non-strictly monotonic vectors,
% and both monotonic increasing and monotonic decreasing vectors. For
% matrices and N-D arrays, ISMONOTONIC returns a value for each column in
% X.
% 
% ISMONOTONIC(X, 1) works as above, but only returns true when X is
% strictly monotonically increasing, or strictly monotonically decreasing.
% 
% ISMONOTONIC(X, 0) works as ISMONOTONIC(X).
% 
% ISMONOTONIC(X, [], 'INCREASING') works as above, but returns true only
% when X is monotonically increasing.
% 
% ISMONOTONIC(X, [], 'DECREASING') works as above, but returns true only
% when X is monotonically decreasing.
% 
% ISMONOTONIC(X, [], 'EITHER') works as ISMONOTONIC(X, []).
% 
% ISMONOTONIC(X, [], [], DIM) works as above, but along dimension DIM.
% 
% NOTE: Third input variable is case insensitive, and partial matching is
% used, so 'd' would be recognised as 'DECREASING' etc..
% 
% EXAMPLE:
%     x = [1:4; 6:-2:2 3]
%     ismonotonic(x)
%     ismonotonic(x, [], 'i')
%     ismonotonic(x, [], [], 2)
% 
%     x =
%          1     2     3     4
%          6     4     2     3
%     ans = 
%          1     1     1     1
%     ans =
%          1     1     0     0
%     ans =
%          1
%          0
% 
% SEE ALSO: is*
% 
% $ Author: Richie Cotton $     $ Date: 2006/07/04 $    $ Version: 1.1 $


%% Basic error checking & default setup
if ~isreal(x) || ~isnumeric(x)
   warning('ismonotonic:badXValue', ...
       'The array to be tested is not real and numeric.  Unexpected behaviour may occur.'); 
end

if nargin < 2 || isempty(bStrict)
    bStrict = false;
end

if nargin < 3 || isempty(direction)
    direction = 'either';
end

% Accept partial matching for direction
if strmatch(lower(direction), 'increasing')
    bTestIncreasing = true;
    bTestDecreasing = false;
elseif strmatch(lower(direction), 'decreasing')
    bTestIncreasing = false;
    bTestDecreasing = true;
elseif strmatch(lower(direction), 'either') 
    bTestIncreasing = true;
    bTestDecreasing = true;
else
    warning('ismonotonic:badDirection', ...
        'The string entered for direction has not been recognised, reverting to "either".');
    bTestIncreasing = true;
    bTestDecreasing = true;
end

if nargin < 4 || isempty(dim)
    dim = find(size(x) ~= 1, 1);
    if isempty(dim)
        dim = 1;
    end
end

%% Test for monotonic increasing
if bTestIncreasing    
    if bStrict
        fhComparison = @gt;
    else
        fhComparison = @ge;
    end    
    bMonoAsc = all(fhComparison(diff(x, [], dim), 0), dim);
else
    bMonoAsc = false;
end

%% Test for monotonic decreasing
if bTestDecreasing    
    if bStrict
        fhComparison = @lt;
    else
        fhComparison = @le;
    end
    bMonoDesc = all(fhComparison(diff(x, [], dim), 0), dim);
else
    bMonoDesc = false;
end

bMono = bMonoAsc | bMonoDesc;
