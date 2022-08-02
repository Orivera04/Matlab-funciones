function M=smean(S,Stage)
% SMEAN Sweep mean
% 
% M=smean(S,Stage)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:20:53 $

if nargin==1
	Stage=1;
end
if size(S,1)==size(S,3)
   M=S;
else
   M=S(tstart(S),:);
   m= mean(S,Stage);
   M(:,:) = m;
   % set up correct Guids
   M= setGuids(M,getSweepGuids(S,'goodonly'));
end