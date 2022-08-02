function idx=mmfindrc(x,dim,flag)
%MMFINDRC Find First or Last Nonzero Indices per Row or Column.
% MMFINDRC(X,Dim,Flag) returns a vector whose i-th element contains
% the index of the First/Last nonzero column/row of X for the i-th
% row/column of X.
% X is the 2-D array to be searched.
% Dim is the dimension to accumulate indices along.
% Dim=1 returns a vector of length equal to the row dimension of X.
% Dim=2 returns a vector of length equal to the column dimension of X.
% Flag indicates whether the first of last element is returned.
% Flag='first' returns the First nonzero.
% Flag='last' returns the Last nonzero.
% If Flag is not given, 'last' is assumed.

if nargin~=2 & nargin~=3
   error('Two or Three Input Arguments Required.')
end
xsiz=size(x);
if ndims(x)~=2 | min(xsiz)<=1
   error('Vectors and N-D Arrays are Not Allowed.')
end
if length(dim)>1 | fix(dim)~=dim | dim<1 | dim>2
   error('Dimension Argument Must be 1 or 2.')
end
if nargin==2
   flag='last';
end
if ~ischar(flag)
   error('Flag Input Argument Must be a String.')
end
first=lower(flag(1))=='f'; % default is 'last'
[r,c]=find(x);
if dim==1 & ~first
   idx=zeros(xsiz(1),1);
   idx(r)=c;
elseif dim==2 & ~first
   idx=zeros(xsiz(2),1);
   idx(c)=r;
elseif dim==1 & first
   idx=zeros(xsiz(1),1);
   idx(r(end:-1:1))=c(end:-1:1);
elseif dim==2 & first
   idx=zeros(xsiz(2),1);
   idx(c(end:-1:1))=r(end:-1:1);
end