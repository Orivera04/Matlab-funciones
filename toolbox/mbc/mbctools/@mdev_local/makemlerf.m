function mdev= makemlerf(mdev,Diags);
% MDEVMLERF/MAKEMLERF

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 08:04:41 $




TS= BestModel(mdev);
if ~isempty(TS) & ismle(TS)
	L= model(mdev);
	G= get(TS,'global');
	TSmle= mdev.MLE.Model;
	D= cov(TSmle);
   if nargin<2
     [Xg,Yrf,Sigma]= mledata(mdev,0,mdev.MLE.Modes(2));
      Diags= diagnosticStats(TSmle,Xg,Yrf,Sigma);
   end
	
	% Diags= struct('Observed',Yrf,'Yhat',P,'Residuals',e,'SResiduals',VarE);
	
	ch= children(mdev,RFstart(L)+mdev.ResponseFeatures(1,:));
	for i=1:length(ch)
		
		DS= struct('Observed',Diags.Observed(:,i),...
			'Yhat',Diags.Yhat(:,i),...
			'Residuals',Diags.Residuals(:,i),...
			'SResiduals',Diags.SResiduals(:,i));

        % set up pev matrix for rf model
        [ri,s2,df]= var(ch(i).model);
        if s2~=0
            ri= ri*sqrt(D(i,i)/s2);
            G{i}= var(G{i},ri,D(i,i),df);
        end
        
		% make mle response feature
		md= ch(i).mdevmlerf(G{i},DS);
		ch(i).status(2,0);
	end
	mbH= MBrowser;
	if mbH.GUIExists
		try
			mbH.doDrawTree(ch)
		end
	end
else
	% turn back into modeldev
	children(mdev,'modeldev');
	children(mdev,mdev.ResponseFeatures(1,:)+RFstart(model(mdev)),'status',2,0);
	mbH= MBrowser;
	if mbH.GUIExists
		try
			mbH.doDrawTree(children(mdev))
		end
	end
end
