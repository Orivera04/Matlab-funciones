function TS= covinit(TS,Xgc,Yrf);
% TWOSTAGE/COVINIT initialise covariance for MLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:31 $

c = TS.covmodel;
if isempty(c)
   c= xregcovariance('','tscov');
end

if isempty(Xgc)
   TS.covmodel = update(c,[]);
else
   % get initial estimate
   Nf= length(TS.Global);
   Ns= size(Xgc,1);
   R= zeros(Ns,Nf);
   for i=1:Nf
      R(:,i)= lsqcost(TS.Global{i},code(TS.Global{i},Xgc),Yrf(:,i));
   end
	
   % GTS initialisation 
   % this is Steiner et al (biased) estimate
   G0= R'*R/(Ns-1);
	
	s= svd(R);
	tol=s(1)*eps*max(R(:))*4;
	if length(s)<size(G0,1) |  s(end) < tol
		G0= diag(diag(G0)); % + eye(size(G0))*tol
	end

	
   % could use diag(diag(G0))
   % G0= diag(diag(G0));
   % 
   TS.covmodel=  covupdate(c,G0);
end