function s=mmstructcat(s1,s2)
%MMSTRUCTCAT Concatenate Structures. (MM)
% MMSTRUCTCAT(S1,S2) forms a new structure by combining the fields
% of structures S2 and S1. S1 and S2 must have the same dimensions.
% Duplicate field names in S1 and S2 are not allowed.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 7/16/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ~isstruct(s1) | ~isstruct(s2)
   error('Arguments Must be Structures.')
end
s1siz=size(s1);
s2siz=size(s2);
if any(s1siz~=s2siz) % potential dimension mismatch
   if min(s1siz)==1 & min(s2siz)==1 % both vectors
      s1=reshape(s1,1,prod(s1siz)); % change to rows
      s2=reshape(s2,1,prod(s2siz)); % allow concatenation
   else
      error('Arguments Must Have the Same Dimensions.')
   end
end
c1=struct2cell(s1);  % vectorized approach
f1=fieldnames(s1);
c2=struct2cell(s2);
f2=fieldnames(s2);
try
   s=cell2struct([c1;c2],[f1;f2],1);
catch
   error('S1 and S2 Must Contain Unique Field Names.')
end