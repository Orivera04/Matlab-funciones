function [TS,OK] =pevinit(TS,Xgc,Yrf,W0,univariate,isCoded);
% XREGTWOSTAGE/PEVINIT initializes a two-stage model ready for evaluating pev

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.6.4.2 $  $Date: 2004/02/09 08:00:09 $


if nargin<5
	univariate=0;
end
if nargin<6 | ~isCoded
	[Xgc,Yrf,W0,OkGroups,lossdf]= checkdata(TS,Xgc,Yrf,W0);
else
	lossdf=0;
end
if length(TS.covmodel)==0
   TS= covinit(TS,Xgc,Yrf);
end

nf= size(Yrf,2);
nc= length(TS.covmodel);
% degrees of freedom
% nf*ns - p - numDispersionParams
% df= numel(Yrf)-numParams(TS)- nc - length(covmodel(TS.Local)) - lossdf; % local dispersion parameters
df= numel(Yrf)-numParams(TS)-  lossdf; % local dispersion parameters


OK= df>0;

if OK
	
   if univariate
	  % make covariance diagonal
	  sig= unstruct(TS.covmodel);
	  sig= diag(diag(sig));
	  TS.covmodel= covupdate(TS.covmodel,sig);
     	lam= RidgeMatrix(TS);
   else
      lam= [];
   end
   
   % scale data
   [Ts2,Xs,Ys,W0s,S]= mle_scale(TS,Xgc,Yrf,W0);
   
   Wci= choltinv(Ts2.covmodel,W0s);
   % make sure we are doing qr on a full matrix
	

	if nnz(lam)
		Xa= [Wci*Xs;lam];
	else
		Xa= Wci*Xs;
	end
	
	[Xs,S]= xregprecond(Xa);
	R= qr(Xs,0);
	if issparse(R)
		ri= S/R;
	else
		n= size(R,2);
		ri= S/(triu(R(1:n,:)));
	end
   
   % store results
   TS= var(TS,ri,[],df);
end