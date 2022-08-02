function ch= selectModel(mdev,mbH)
%SELECTMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 08:05:09 $




%% hit compare/verify then we need to check the current rfs allow twostage 
%% models to be reconstructed. If many, the user gets to choose which to verify.
hFig= gcbf;
mbH= MBrowser;
p= mbH.CurrentNode;
View= mbH.GetViewData;

ch=[];


if mle_best(mdev) & ~View.Update
	hFig= Validate_mle('create',p,mbH.Figure);
	set(mbH.Figure,'pointer',get(0,'defaultFigurePointer'));
	mbH.RegisterSubFigure(hFig);
else
   if ~isempty(p.children)
      pbest= p.children('bestmdev');
      pbest=[pbest{:}];
      if any(pbest==0)
         unvalmdev=p.children(find(pbest==0),'name');
         errordlg(str2mat('You must validate all submodels ',...
            'before validating this model',...
            'The following sub-models have not been validated:',...
            unvalmdev{:}),...
            'Validation Error','modal');
         return
      end
   end   


   
   
   f=  find(mdev.FitOK);
   if ~isempty(f)
      % use fitted coefficients if possible to account for proper delG
      L= LocalModel(mdev,f(1));
   else
      L= model(mdev);
   end
	ch= p.children;
	RFNames= children(mdev,'name');
	[selrf,rfcond]=SelectRF(L);
	
	if size(selrf,1)>0
		if View.Update
			% do we need to update links
			mdev= UpdateLinks(mdev,View.Update);
			
			View.Update=0;
			mbH.SetViewData(View);
		end
		
		
		Nf= length(get(L,'values'));
		if length(RFNames)>Nf
			RFNames(1:length(RFNames)-Nf)=[];
		end
		
		%Find longest RFNames
		maxlen = 0;
		for i=1:length(RFNames)
			maxlen = max(maxlen,length(RFNames{i}));
		end
		% Construct formating string based o the max length
		formatstr = sprintf('%%-%ds ',maxlen); 
		
		% construct List
		List=cell(size(selrf,1),1);
		for i=1:size(selrf,1)
			List{i}= sprintf(formatstr,RFNames{selrf(i,:)});
		end
		
		
		ch= validate_local('create',p,selrf,List,gcbf);
		
		mbH.RegisterSubFigure(ch);
	else
		errordlg(['There are insufficent independent Response Features',...
				' available to reconstruct this local model'],...
			'Local Regression Error','modal');
	end
end
