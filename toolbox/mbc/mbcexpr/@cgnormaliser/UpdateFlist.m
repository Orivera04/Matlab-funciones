function LT = UpdateFlist(LT,p,flag)
%UPDATEFLIST

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:39 $

% ads the xregpointer p the the Flist field of the cgnormaliser LT.
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

V = LT.Flist;
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
   LT.Flist = [V;p];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_remove               %
%%%%%%%%%%%%%%%%%%%%%%%%%%

function LT = i_remove(LT,p)

V = LT.Flist;
n = length(V);
if n
   V = V(~(p==V));
   if prod(size(V))==0
      V = [];
   end
   LT.Flist = V;
end