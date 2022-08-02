function [vall, indd] = max2(A);
%   Function MAX2 finds value VALL of a largest element in an 2D array  and 
%   returns its indices INDD(1) =row and INDD(2) = column. If A is a vector, 
%   MAX2  equal standard Matlab MAX function. 
%   ATT: This function like standard Matlab MAX first looks in column, 
%   then  in rows to find its first max value.
%__NEW______ function replaces +Inf to NaN

%__________________________________________________
% 	Sergei Koptenko, Resonant Medical Inc., Toronto  |
%	sergei.koptenko@resonantmedical.com              |
%______________March/30/2004_____________________|

[i,j] = find(A == Inf);
A(i,j) = NaN;

[rrow ccol] = size(A);
if   rrow ==1 | ccol ==1,     [vall, indd] = max(A);
else
[vall, jj] = max(A);     [vall, kk] = max(vall);     
indd(2) = kk;               indd(1)= jj(kk);   
end
