function ss=mmrofield(s,ord)
%MMROFIELD Reorder Structure Fields. (MM)
% MMROFIELD(S,Order) returns the structure S with the
% field names reordered according to the variable Order.
%
% MMROFIELD(S,'alpha') reorders the structure so the field
% names appear in alphabetic order.
% MMROFIELD(S,'reverse') reorders the structure so the
% field names appear in reverse alphabetic order.
%
% MMROFIELD(S,Idx) where Idx is a permutation of the indices
% of the field names of S, reorders the structure to match
% the order given by Idx.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 6/7/00
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8

if nargin~=2
   error('Two Input Arguments Required.')
end
if ~isstruct(s)
   error('First Argument Must be a Structure.')
end
dims=size(s);
c=struct2cell(s(:));
if ischar(ord) % 'alpha' or 'reverse'
   [fnames,idx]=sort(fieldnames(s));
   if strncmpi(ord,'r',1)
      idx=idx(end:-1:1);
      ss=cell2struct(c(idx,:),fnames(end:-1:1),1);
   elseif strncmpi(ord,'a',1)
      ss=cell2struct(c(idx,:),fnames,1);
   else
      error('Unknown String Second Argument.')
   end
elseif isnumeric(ord)   % Idx
   fnames=fieldnames(s);
   nfn=length(fnames);
   if nfn~=length(ord)
      error('Incorrect Number of Field Names Provided.')
   end
   if ~isequal(1:nfn,sort(ord(:)'))
      error('Idx Does Not Contain Field Name Indices.')
   end
   ss=cell2struct(c(ord,:),fnames(ord),1);
else
   error('Unknown Second Argument.')
end
ss=reshape(ss,dims);
  