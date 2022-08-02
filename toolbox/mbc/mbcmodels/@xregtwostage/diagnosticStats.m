function Diags= mle_diagnostics(TS,Xg,Yrf,Sigma);
%DIAGNOSTICSTATS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:34 $

% [x0,Z,W,Nf,bd,SF,S]=mleinit(mdev,0,1,0);



[Xgc,Yrf,W0]=checkdata(TS,Xg,Yrf,Sigma);

[TS,J,y,W0,S,SF]= mle_scale(TS,Xgc,Yrf,W0);


Nf= size(Yrf,2);
Ns= size(Yrf,1);


% J= jacobian(TS,Xgc,1);

Wci= choltinv(TS.covmodel,W0);
Wf= cov(TS.covmodel,W0);
D= unstruct(TS.covmodel);

df= numel(Yrf)-numParams(TS)-length(TS.covmodel) - length(covmodel(TS.Local))-1; % local dispersion parameters
OK= df>0;



% Predicted Values
P= zeros(size(Yrf));
for i= 1:Nf
   P(:,i)= eval(TS.Global{i},Xgc);
end

% Error
e= Yrf-P;	%Equation 13

if ~OK
	VarE= NaN*e;
	% Output Structure
	Diags= struct('Observed',Yrf,'Yhat',P,'Residuals',e,'SResiduals',VarE);
	return
end

% Calculate stats
% Correlation of G

Zc= Wci*J;
% make sure we use full qr algorithm - sparse is nasty

ri= var(TS);
if isempty(ri)
	R=qr(full(Zc));
	R= triu(R(1:size(R,2),:));
	% Predicted Variances
	
	ri= inv(R);
	
end

Jw= J*ri;
VarP = sum((Jw).^2,2);	%Equation 18
% Error Variances
H=  sqrt(diag(Wf)-VarP);

% Parameter Variance
VarB = ri*ri';						%Equation 16

% Reshape Data into Response Feature Order
Zind= reshape(1:Nf*Ns,Nf,Ns)';

Wc= diag(sqrt(diag(D)));
H= reshape(H(Zind),Ns,Nf)*Wc;

VarE= e./H*SF;

% Output Structure
Diags= struct('Observed',Yrf,'Yhat',P,'Residuals',e,'SResiduals',VarE);


