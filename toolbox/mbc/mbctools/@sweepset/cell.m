function c= cell(S);
% SWEEPSET/CELL convert sweepset to cell

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:06:03 $

Ns=size(S,3);
s= [tstart(S) size(S.data,1)+1];
c= cell(1,Ns);
data= S.data;
for i=1:Ns;
   c{i}= data(s(i):s(i+1)-1,:);
end