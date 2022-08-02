function [ma, loc] = kmaxima(a, k, d)
% KMAXIMA specified number of maxima
%     For vectors, KMAXIMA(X,K) is the vector of K largest elements in X. 
%     For matrices, Y = KMAXIMA(X,K) is a matrix with K rows; Y(i,:) 
%     contains the i-th maximum element from each column. For N-D arrays, 
%     KMAXIMA(X,K) operates along the first non-singleton dimension.
%  
%     [Y,I] = KMAXIMA(X,K) returns the indices of the maxima in vector I.
%    
%     [Y,I] = KMAXIMA(X,K,DIM) operates along the dimension DIM. 
%  
%     When complex, the magnitude ABS(X) is considered when computing the 
%     maxima, and the angle ANGLE(X) is ignored.  NaN's are also ignored .

% Mukhtar Ullah
% mukhtar.ullah@informatik.uni-rostock.de
% November 17, 2004

a(isnan(a)) = -inf;
if isvector(a) && nargin < 3
    [b,ix] = sort(a, 'descend');
    ma = b(1:k);
    loc = ix(1:k);
else
    if nargin < 3, d = 1; end
    [b,ix] = sort(a, d, 'descend');
    n = ndims(a);
    if n < 3
        if d < 2
            ma = b(1:k, :);
            loc = ix(1:k, :);
        else
            ma = b(:, 1:k);
            loc = ix(:, 1:k);
        end
    else
        C = cell(1, n);
        if d > 1, C(1:d-1) = {':,'}; end
        if d < n, C(d+1:n) = {',:'}; end
        C(d) = {'1:k'};
        S = ['(' [C{:}] ')'];
        ma = eval(['b' S]);
        if nargout > 1, loc = eval(['ix' S]); end
    end
end