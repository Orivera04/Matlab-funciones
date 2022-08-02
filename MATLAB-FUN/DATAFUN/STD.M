function y = std(x)
%STD	Standard deviation.
%	For vectors, STD(x) returns the standard deviation.
%	For matrices, STD(X) is a row vector containing the
%	standard deviation of each column.
%
%	STD computes the "sample" standard deviation, that
%	is, it is normalized by N-1, where N is the sequence
%	length.
%
%	See also COV, MEAN, MEDIAN.

%	J.N. Little 4-21-85
%	Revised 5-9-88 JNL
%	Copyright (c) 1984-94 by The MathWorks, Inc.


[m,n] = size(x);
if (m == 1) + (n == 1)
    m = max(m,n);
    y = norm(x-sum(x)/m);
else
    avg = sum(x)/m;
    y = zeros(size(avg));
    for i=1:n
        y(i) = norm(x(:,i)-avg(i));
    end
end
if m == 1
    y = 0;
else 
    y = y / sqrt(m-1);
end
