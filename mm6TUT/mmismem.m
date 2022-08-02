function m=mmismem(a,b)
%MMISMEM True for Set Members. (MM)
% MMISMEM(A,B) returns a logical matrix the size of A
% having ones where the corresponding elements of A
% also appear in B. A and B need not be the same size.
%
% This function vectorizes the code
%
% M=logical(zeros(size(A)));
% for i=1:prod(size(A))
%     M(i) = any(A(i)==B);
% end
%
% This function is typically an order of magnitude faster than
% ISMEMBER in MATLAB version 5.0 and creates a vector no larger than
% prod(size(A)) + prod(size(B)). In later 5.X versions of MATLAB
% ISMEMBER is implemented in a MEX file, which makes it an order of
% magnitude faster than MMISMEM.
%
% See also ISMEMBER

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 8/24/95, revised 9/3/96, 12/31/96, v5: 1/13/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

b=sort(b(:));
b(~[diff(b);1])=[];         % discard duplicate values in b

m=logical(zeros(size(a)));  % make output mask vector of FALSE

a=a(:);                     % convert to column vector
na=length(a);
[sa,ia]=sort(a);            % sort to look for duplicates in a
d=~[diff(sa);1];            % true where duplicates exist in sa 
ida=ia(d);                  % indices of duplicates in a
for i=ida.'
   m(i)=any(a(i)==b);      % check duplicates and poke in TRUE
end
a(ida)=nan+zeros(length(ida),1);% change duplicates to nan
% nan's go to end when sorted

[x,ix]=sort([a;b]);     % sort a and b together
dx=[diff(x);1];         % look for differences
i=ix(dx==0);            % indices of a that have matching values in b
m(i)=ones(length(i),1); % poke TRUE into these indices
