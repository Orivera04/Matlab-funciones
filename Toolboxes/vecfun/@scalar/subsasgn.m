function A=subsasgn(A,S,B)
%SUBSASGN  Subscripted assignment.
%   S = T assigns the scalar function T into A.
%
%   S([],[],[]) = T does the same thing.
%
%   See also SUBSREF.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=scalar(B);
err1='Cannot assign to an indexed scalar';
if isempty(S.type)
   A=B;
elseif strcmp(S.type,'()') & length(S.subs)==3
   if isempty(S.subs{1}) & isempty(S.subs{2}) & isempty(S.subs{3})
      A=B;
   else
      error([err1 ' with values.']);
   end
else
   error([err1 ' using ''{}'' or ''.''.']);
end