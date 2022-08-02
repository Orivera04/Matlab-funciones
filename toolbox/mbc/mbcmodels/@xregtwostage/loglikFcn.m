function [f,G,Li,OK]= loglikFcn(TS,Xg,Yrf,Sigma)
% TWOSTAGE/LOGLIKFCN log likelihood function for twostage model
%
% [f,G,Li,OK]= loglikFcn(TS,Xg,Yrf,Sigma)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:49 $


[Xgc,Yrf,W0,OK]= checkdata(TS,Xg,Yrf,Sigma);

if length(TS.covmodel)==0
	% initialise covariance to be diagona;
   TS= covinit(TS,Xgc,Yrf);
   c= unstruct(TS.covmodel);
   TS.covmodel= covupdate(TS.covmodel,diag(diag(c)));
end

% rescale first
[TS,Xs,Ys,W0s,S,SF]= mle_scale(TS,Xgc,Yrf,W0);

c= TS.covmodel;
% predicted output
yhat= zeros(size(Yrf));
recode= ~isSameTgt(TS);
for i=1:size(yhat,2);
    if recode
        yhat(:,i) = eval(TS.Global{i},code(TS.Global{i},Xgc));
    else
        yhat(:,i) = eval(TS.Global{i},Xgc);
    end
	if isTBS(TS.Global{i})
		yhat(:,i)= ytrans(m,yhat(:,i));
	end
end
yhat= yhat';
% scale yhat
yhat= S*yhat(:);

% covmodel cost function returns the cost function
[f,Beta,G,W,Li,T2]= mlelincost(double(c),c,Ys,yhat,W0s,0);

% now undo the scaling
f= f - 2*sum(log(diag(S)));
G = SF\G/SF;

Nf= size(Yrf,2);
Ns= size(Yrf,1);
S2= reshape(diag(S),Nf,Ns)';

Li= Li - 2*sum(log(S2),2);

