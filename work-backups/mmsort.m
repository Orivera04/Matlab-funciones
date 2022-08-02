function [y,idx,rnk]=mmsort(x,n,varargin)
%MMSORT General 2D sorting. (MM)
% MMSORT(X,N) sorts the 2D array X down its N-th column in ascending order
% returning an array where each column is ordered by the N-th column sort.
% MMSORT(X,N,'col'), MMSORT(X,N,'col','ascend') and MMSORT(X,N,'ascend') do
% the same thing.
% MMSORT(X,N,'col','descend') and MMSORT(X,N,'descend') sorts X down its
% N-th column in descending order.
%
% MMSORT(X,N,'row') sorts X across its N-th row in ascending order returning
% an array where each row is ordered by the N-th row sort.
% MMSORT(X,N,'row','descend') sorts X across its N-th row in descending order.
%
% Y=MMSORT(X,N,..) returns the sorted array in Y.
% [Y,IDX]=MMSORT(X,N,..) in addition returns the sort index.
% [Y,IDX,RNK]=MMSORT(X,N,..) in addition returns the rank of the index.
%
% See also SORT, SORTROWS

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 5/20/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==2
   rc='col';
   dir='asc';
elseif nargin==3 | nargin==4
   [rc,dir]=local_parse(varargin);
else
   error('Incorrect Number of Input Arguments.')
end
[rx,cx]=size(x);
if rx==1 | cx==1
   error('X Must be at Least 2-by-2.')
end
switch rc
case 'col'
   if n<1 | n>cx
      error('N Out of Range.')
   end
   [tmp,idx]=sort(x(:,n));
   if strcmp(dir,'des')
      idx=idx(end:-1:1);
   end
   y=x(idx,:);
case 'row'
   if n<1 | n>rx
      error('N out of Range.')
   end
   [tmp,idx]=sort(x(n,:));
   if strcmp(dir,'des')
      idx=idx(end:-1:1);
   end
   y=x(:,idx);
end
if nargout==3
   rnk(idx)=1:length(idx);
   rnk=reshape(rnk,size(idx));
end
function [rc,dir]=local_parse(arg)
if ~iscellstr(arg)
   error('String Arguments Required.')
end
rc='col';
dir='asc';
for k=1:length(arg)
   s=arg{k};
   if strncmpi('row',s,3)
      rc='row';
   elseif strncmpi('col',s,3)
      rc='col';
   elseif strncmpi('asc',s,3)
      dir='asc';
   elseif strncmpi('des',s,3)
      dir='des';
   else
      error('Unknown Dimension or Direction Requested.')
   end
end
