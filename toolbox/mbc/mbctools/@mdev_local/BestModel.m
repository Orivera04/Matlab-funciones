function [bm,msg]=BestModel(mdev,TSIndex,Climb);
%BESTMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.4 $  $Date: 2004/04/04 03:31:06 $


msg= '';
if nargin==1
   if isempty(mdev.TwoStage)
      bm= [];
   else
      bmIndex= BestModel(mdev.modeldev);
      if isa(bmIndex,'double') & bmIndex~=0
         bm= mdev.TwoStage{bmIndex};
      else
         bm= [];
      end
   end
else
	if nargin<3
		Climb=0;
	end

	
   if isa(TSIndex,'double') & TSIndex~=0 
      s= statistics(mdev);
      if TSIndex~=2
         mdev.MLE.BestModel= 0;
      end
      mdev.modeldev= BestModel(mdev.modeldev,TSIndex);
      
      pointer(mdev);
      rfind= mdev.ResponseFeatures(TSIndex,:);
      ch=children(mdev);
      L=model(mdev);
      if RFstart(L);
         rfind= [1 rfind+1];
      end
      children(mdev,rfind,'status',2);
      mdev= status(mdev,1);
      NotBest= setdiff(1:length(ch),rfind);
      children(mdev,NotBest,'status',1);
      
      mdev= statistics(mdev,mdev.TSstatistics.Summary(TSIndex,:));
		%mdev.TSstatistics.Summary=[];
      if isfield(mdev.MLE,'Init')
         mdev.MLE= rmfield(mdev.MLE,'Init');
      end
      if isfield(mdev.MLE,'Model')
         mdev.MLE= rmfield(mdev.MLE,{'Model','Solution'});
      end
		
		p= Parent(mdev);
		if isbest(mdev)
			p.BestModel(xregpointer);
		end
		
		if Climb==0
			% this clears the status properly
			mdev= status(mdev,1,0);
			mdev= status(mdev,1);
		end

		if status(mdev)==2 & p.childindex==1 & get(L,'datumtype')
			% update datum link required if mdev is selected as best
			prf= children(mdev);
			pdatum= datumlink(mdev);
			% update datum links
			mdev= UpdateLinks(mdev,1);
			
			if pdatum~= prf(1)
				% assign datum to new value
				p.AssignData('Data',prf(1));
			end
				
			ptp= p.Parent;
			pr= ptp.children('datumlink');
			if sum([pr{:}]==pdatum)>1
                pointer(mdev);
                msg= 'The datum model has changed. All responses using datum links should be updated.';
			end
		end

	else
		% unset best model
      
		if isbest(mdev)
			p= Parent(mdev);
			p.BestModel(xregpointer);
		end
      mdev.MLE.BestModel= 0;
      mdev.modeldev= BestModel(mdev.modeldev,0);
		% assign twostage stats to NaN
      s= statistics(mdev);
      s(2:end)= NaN;
      mdev= statistics(mdev,s);
		% change status of children to 1 if they are 2
		ch= children(mdev);
		ind= find(ch~=Climb);
		for i=1:numChildren(mdev)	
			ch(i).modeldev;
			st= ch(i).status;
			if st==2
				ch(i).status(1,0);
			end	
      end
   end

   pointer(mdev);
   bm= mdev;
end
