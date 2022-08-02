function is= isBest(mdev);
% MODELDEV/ISBEST

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:10:31 $




p=Parent(mdev);
if p==0
	is=1;
else
	mdparent= info(p);
	
	bm= mdparent.BestModel;
	if isempty(bm) | bm==0;
		is= 0;
	elseif isa(bm,'xregpointer')
		is = (bm == address(mdev)) & (mdev.Status==2);
	else
		% response feature model
		ind= ResponseFeatures(mdparent);
      L= mdparent.Model;
      ind= ind(bm,:);
      if RFstart(L)
         ind=[1 ind+1];
      end 
		is = any(ind==childindex(mdev));
	end
end
	
