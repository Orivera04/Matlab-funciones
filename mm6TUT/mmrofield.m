function ss=mmrofield(s,ord)
%MMROFIELD Reorder Structure Fields. (MM)
% MMROFIELD(S,Order) returns the structure S with the
% field names reordered according to the variable Order.
%
% MMROFIELD(S,'ascii') reorders the structure so the field
% names appear in ascii alphabetic order.
% MMROFIELD(S,'alpha') reorders the structure so the field
% names appear in alphabetic order ignoring case.
% MMROFIELD(S,'rascii') reorders the structure so the field
% names appear in reverse ascii alphabetic order.
% MMROFIELD(S,'ralpha') reorders the structure so the field
% names appear in reverse alphabetic order ignoring case.
%
% MMROFIELD(S,Idx) where Idx is a permutation of the indices
% of the field names of S, reorders the structure to match
% the order given by Idx.
%
% MMROFIELD(S,Sr) where Sr is a reference structure, reorders
% the fieldnames of S to match those of Sr. S and Sr must have
% the same fields.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 6/7/00, 2/26/01, 5/31/01
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin~=2
   error('Two Input Arguments Required.')
end
if ~isa(s,'struct')
   error('First Argument Must be a Structure.')
end
dims=size(s);
c=struct2cell(s(:));
fnames=fieldnames(s);
if ischar(ord)
   if strncmpi(ord,'as',2)
      [tmp,idx]=sort(fnames);
      ss=cell2struct(c(idx,:),fnames(idx),1);
   elseif strncmpi(ord,'ras',3) | strncmpi(ord,'rev',3)
      [tmp,idx]=sort(fnames);
      idx=idx(end:-1:1);
      ss=cell2struct(c(idx,:),fnames(idx),1);
   elseif strncmpi(ord,'al',1)
      [tmp,idx]=sortrows(lower(char(fnames)));
      ss=cell2struct(c(idx,:),fnames(idx),1);
   elseif strncmpi(ord,'ral',3)
      [tmp,idx]=sortrows(lower(char(fnames)));
      idx=idx(end:-1:1);
      ss=cell2struct(c(idx,:),fnames(idx),1);      
   else
      error('Unknown String Second Argument.')
   end
elseif isnumeric(ord)   % Idx
   nfn=length(fnames);
   if nfn~=length(ord)
      error('Incorrect Number of Field Names Provided.')
   end
   if ~isequal(1:nfn,sort(ord(:)'))
      error('Idx Does Not Contain Field Name Indices.')
   end
   ss=cell2struct(c(ord,:),fnames(ord),1);
elseif isa(ord,'struct')
   ord=mmstridx(fieldnames(ord),fnames);
   if isempty(ord)
      error('S and Sr Must Have the Same Fields.')
   else
      ss=cell2struct(c(ord,:),fnames(ord),1);
   end
else
   error('Unknown Second Argument.')
end
ss=reshape(ss,dims);
