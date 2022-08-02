function LT = UpdateSFlist(LT,p,flag)
%UPDATESFLIST

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:28 $

% ads the xregpointer p the the Flist field of the normaliser LT.
switch flag
case 0
   LT = i_remove(LT,p);
case 1
   LT = i_add(LT,p);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_add                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%

function LT = i_add(LT,p)

V = LT.SFlist;
n = length(V);
i = 1;
j = 0;
while j==0 & i<=n
   if isequal(V(i),p)
      j = j+1;
   end
   i = i+1;
end
if j==1
   LT = LT;
   else
   LT.SFlist = [V;p];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_remove               %
%%%%%%%%%%%%%%%%%%%%%%%%%%

function LT = i_remove(LT,p)

V = LT.SFlist;
n = length(V);
n = length(V);
if n ~= 0
   V = V(~(p==V));
   if prod(size(V))==0
      V = [];
   end
end

LT.SFlist = V;