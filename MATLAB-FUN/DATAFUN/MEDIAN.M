function y = median(x)
%MEDIAN	Median value.
%	For vectors,  MEDIAN(X)  is the median value of the elements in X.
%	For matrices, MEDIAN(X) is a row vector containing the median value
%	of each column.
%
%	See also MEAN, STD, MAX, MIN.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
[m,n] = size(x);
x = sort(x);
if (m==1)
    if isnan(x(1)) | isnan(x(n))
        y = nan;
        return
    end
    if rem(n,2)        % n is odd    
        y = x((n+1)/2);
    else            % n is even
        y = (x(n/2) + x(n/2+1))/2;
    end
else
    if rem(m,2)        % m is odd
        y = x((m+1)/2,:);
    else            % m is even
        y = (x(m/2,:) + x(m/2+1,:))/2;
    end
    nn = find( isnan(x(1,:)) | isnan(x(m,:)) );
    y(nn) = nan*ones(size(nn));
end
