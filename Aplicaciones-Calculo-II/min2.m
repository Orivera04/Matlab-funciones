function [vall, indd] = min2(A);
%   Function MIN2 finds value VALL of a smallest element in an 2D array  and 
%   returns it's indices INDD(1) =row and INDD(2) = column. If A is a vector, 
%   MIN2  equal standard Matlab MIN function. 
%   ATT: This function like standard Matlab MAX first looks in column, 
%   then  in rows to find its first min value.
%__NEW______ function replaces -Inf to NaN
%__________________________________________________
% 	Sergei Koptenko, Resonant Medical Inc., Toronto  |
%	sergei.koptenko@resonantmedical.com                |
%______________March/30/2004_____________________|

[rrow ccol] = size(A);

[i,j] = find(A == -Inf);
A(i,j) = NaN;
if   rrow ==1 | ccol ==1,     [vall, indd] = min(A);
else
[vall, jj] = min(A);    [vall, kk] = min(vall);    
indd(2) = kk;    indd(1)= jj(kk);  
end
