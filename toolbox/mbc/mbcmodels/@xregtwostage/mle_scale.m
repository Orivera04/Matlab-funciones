function [Tscale,Xs,Ys,W0s,S,SF]= mle_scale(TS,Xgc,Yrf,W0)
%MLE_SCALE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:57 $


cd = TS.covmodel;
cd= xregcovariance('','unstruct');
cd= update(cd,double(TS.covmodel));
% work out scalings
[Gs,SF,cd]= unstruct_cov2corr(cd);

X= jacobian(TS,Xgc,1);
y= Yrf';
y=y(:);

% do we do this - yes
S= repmat(diag(SF),size(Yrf,1),1);
S=spdiags(S,0,length(S),length(S));
% scale data
Xs= S*X;
Ys= S*y;  
% scale covariance
W0s= S*W0*S;

Tscale= TS;
Tscale.covmodel= update(TS.covmodel,double(cd));