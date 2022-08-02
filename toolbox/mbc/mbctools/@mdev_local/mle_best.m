function [out,msg] =mle_best(mdev,isbest)
%MLE_BEST

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.5 $  $Date: 2004/04/20 23:19:06 $

msg='';
if nargin==1
   if isfield(mdev.MLE,'BestModel') 
      out= mdev.MLE.BestModel;
   else
      out=0;
   end
else
    mdev.MLE.BestModel= isbest;
    
    bmindex= isbest+1;
    mdev= statistics(mdev,mdev.TSstatistics.Summary(bmindex,:));
    mdev.modeldev= BestModel(mdev.modeldev,bmindex);
    pointer(mdev);
	
	p= Parent(mdev);
	bm= peval('bestmdev',p);
	if bm==address(mdev)
		p.BestModel(xregpointer);
	end
	% this clears the status properly
	mdev= status(mdev,1,0);
	% assign status to 1 including any propogation up the tree
	mdev= status(mdev,1);
	
	
	p= Parent(mdev);
	if status(mdev)==2 & p.childindex==1 & get(model(mdev),'datumtype')
		% update datum link required if mdev is selected as best
		prf= children(mdev);
		pdatum= datumlink(mdev);
		% update datum links
		mdev= UpdateLinks(mdev,1);
		ptp= p.Parent;
		pr= ptp.children('datumlink');
		if sum([pr{:}]==pdatum)>1
            msg= 'The Datum Model has changed. All responses using datum links should be updated.';
		end
		
	end
	
   out =mdev;
   pointer(mdev);
end
