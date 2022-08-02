function [SummStats,sig,W]= localstats(L,X,y,Wc);
% LOCALMOD/LOCALSTATS localmod statistics
% 
% [SummStats,sig]= localstats(L,X,y,Wc);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:39:21 $



SummStats= summary(L,X,y,Wc);
if nargout>1
   [sig,W,SummStats.Cond_Jacob]= sigma(L,X,Wc);
	
	[ri,s2,df]= var(L);
   if s2~=0
      sig= sig/s2;
      W  = W/s2;
   end
end
