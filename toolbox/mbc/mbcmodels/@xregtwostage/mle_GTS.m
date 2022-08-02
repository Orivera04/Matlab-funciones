function [TS,OK,xfinal]= mle_GTS(TS,Xgc,Yrf,W0,ProgTable,LinAlg,TolFun)
% TWOSTAGE/MLE_GTS Global Twostage MLE  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:53 $


% twostage covariance structure
[TS,OK]= pevinit(TS,Xgc,Yrf,W0,0,1);
xfinal=[];
if OK
	Nf= size(Yrf,2);
	% scale data
	[TS,Xs,Ys,W0s,S,SF]= mle_scale(TS,Xgc,Yrf,W0);
	

	TS= feval(LinAlg,TS,Xs,Ys,W0s,ProgTable,1,TolFun);

	% rescale
	TS.covmodel= unstruct_corr2cov(TS.covmodel,SF);
	
	xfinal=  double(TS.covmodel);  % index upper triangular elements
end