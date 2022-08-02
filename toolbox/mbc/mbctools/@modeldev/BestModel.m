function bm=BestModel(mdev,p,Climb);
% MODELDEV/BESTMODEL
%
% bm= BestModel(mdev); returns 
% mdev= BestModel(mdev,p); 
%           p is pointer to modeldev object
%           assigns bestmodel to the model 
%           this copies model, statistics and outliers from p to mdev

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:09:23 $

if nargin==1
   if isa(mdev.BestModel,'xregpointer') 
		if mdev.BestModel==0
			% best model is current node
			bm= mdev.Model;
		else
			% get best model from child
			bm= BestModel(info(mdev.BestModel));
		end
	else
		bm= mdev.BestModel;
	end
else
	if nargin<3
		Climb=0;
	end
   if isa(p,'xregpointer') 
      ch= children(mdev);
      if p~=0
         % copy model info up tree
         mdev.Statistics= p.statistics;
         mdev.Model= p.BestModel;
         mdev.Outliers= p.outliers;
			pointer(mdev);
			if Climb==0
				% assign status of p to 2 to indicate it is the best model
				p.status(2,0);
				% make current node status 1 - > this will trigger autobest selection if only one child
				mdev= status(mdev,1);
			end

			% make sure all other children are not best
         children(mdev,ch~=p,'status',1,0);
      else
			children(mdev,ch~=Climb,'status',1,0);
			if mdev.Status==2
				% set status back to one
				mdev= status(mdev,1,Climb);
			end
		end
	end
   mdev.BestModel= p;
   pointer(mdev);
   bm=mdev;
end
