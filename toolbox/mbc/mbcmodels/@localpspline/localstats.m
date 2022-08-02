function [SummStats,sig,W]= localstats(L,X,y,Wc);
% localpspline/STATS localmod statistics
% 
% [SummStats,sig]= localstats(L,X,y,Wc);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:41:23 $

SummStats= summary(L,X,y,Wc);
if nargout>1
   [X,y]= symmetric(L,X,y);
   [sig,W,SummStats.Cond_Jacob]= sigma(L,X,Wc);
	
	[ri,s2,df]= var(L);
   if s2>0
   	sig= sig/s2;
   	W = W/s2;   
   end
end
