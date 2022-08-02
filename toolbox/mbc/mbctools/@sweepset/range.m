function r= range(S);
% SWEEPSET/RANGE range of data in sweepset

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:11:27 $



% Range breaks if size(S,1) retuns two identical values at the end
st=[tstart(S) size(S,1)+1];
r= zeros(length(st)-1,size(S,2));
for i=1:length(st)-1
   r(i,:)= max(S.data(st(i):st(i+1)-1,:),[],1) - min(S.data(st(i):st(i+1)-1,:),[],1);
end
% r=  max(S.data,[],1) - min(S.data,[],1);