function n=order(p);
% ORDER Order of Polynomial
% 
% N = ORDER(P) Order of polynomial - leading zeros are ignored.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:40:38 $



c = double(p);
f=find( c );
if ~isempty(f)
   n= length(c)-f(1);
else
   n= 0;
end
