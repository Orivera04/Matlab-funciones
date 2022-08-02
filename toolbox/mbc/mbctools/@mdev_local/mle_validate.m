function [Table,Models,mdev]= mle_validate(mdev,hFig)
%MLE_VALIDATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 08:04:54 $



if ~isfield(mdev.MLE,'Validate') | ~mdev.MLE.Validate
   ModelNo= BMIndex(mdev);
else
   ModelNo= 1;
end   


TSmle= mdev.MLE.Model;
[Xg,Yrf,Sigma] = mledata(mdev,1,mdev.MLE.Modes(2));
[f,Gamma,Li,OK]= loglikFcn(TSmle,Xg,Yrf,Sigma);
sigma2= mdev.MLE.Pooled_MSE;
Ng= size(Gamma,1);

bd= ~OK;

rf = mdev.ResponseFeatures(1,:);

% get global data

presp= Parent(mdev);
L= model(mdev);
G= children(mdev,'BestModel');

[Xts,Y]= getdata(mdev,'FIT');
X = Xts{1};
XG= Xts{2};
Y(:,:,~mdev.FitOK)= NaN;



Yf_pred= zeros(size(Y,3),1);


% Get Response Feature data from Local Fit
Yf = mdev.RFData.double;
if RFstart(L)
   Yf(:,1)=[];
end

nl= nfactors(L);

RMSE= zeros(size(XG,1),1);
SSr1= Y;

[Y_pred,Lfpred]= EvalModel(TSmle,Xts);

SSr1(:,1)= double(Y)-Y_pred;

N= size(Y,3);
for k=1:N											
   
   if mdev.FitOK(k)
      % Response Feature residuals 
      % need to account for ytrans here !!!!!!!!!!!????????????
      r= Lfpred(k,:)-Yf(k,rf);
      % Response Feature Covariance Matrix for sweep k
      S= squeeze( mdev.MLE.Sigma(rf,rf,k) )*sigma2 + Gamma;
      
      if all(isfinite(r)) & all(isfinite(S(:))) & rank(S)== size(S,1)
         Yf_pred(k,1) = r/S*r';
      else
         Yf_pred(k,1) = NaN;
      end
      
      r= double(SSr1(:,:,k));
      rok= isfinite(r);
      if any(rok)
         RMSE(k) = sqrt(sum(r(rok).^2)/sum(rok));
      end
   else
      RMSE(k)= NaN;
      Yf_pred(k,1)= NaN;
   end
   
end

ResAll= double(Y)- Y_pred; %(i)
rOK= isfinite(ResAll);
ResAll=ResAll(rOK);
if ~isempty(ResAll)
	VarR= sum(ResAll.^2,1)/length(ResAll);
	s= sqrt(VarR);
else
	s= NaN;
end

% Look at Response Features
Yf_pred(bd)=NaN;
resids= Yf_pred;
residsOK= all(isfinite(resids),2);
resids= resids(residsOK,:);
dfFeat= length(resids);
VarRF(1)= ( sum(resids,1)./dfFeat );

% Sweep Contributions to log L
LogLi= zeros(N,1);
LogLi(~bd,1)=Li;
LogLi(bd,1)= NaN;

if isfield(mdev.TSstatistics,'Summary') & ~isempty(mdev.TSstatistics.Summary)
	s_un= mdev.TSstatistics.Summary(1,:);
	switch length(s_un)
	case 4
		if islinear(mdev.TwoStage{1})
			% need press r,mse
			s_un= [s_un(1:2) NaN s_un(3:end)];
		end
	case 5
	otherwise
		% old summary table of wrong size
		s_un= statistics(mdev);
	end
else
	s_un= statistics(mdev);
end

sLp= yinv( model(mdev) ,sqrt(sigma2));

% display [Local RMSE , Pred RMSE , Pred T^2 , -log L]
% log L is last element in table
chead= colhead(mdev);
lind= length(chead);
if length(s_un)==5
	% use NaN for MLE PRESS RMSE
	Table= [s_un;s_un(1) s NaN VarRF(1) f];
else
	Table= [s_un;s_un(1) s VarRF(1) f];
end

% store the results
mdev.ResponseFeatures= mdev.ResponseFeatures([ModelNo,ModelNo],:);
mdev.TSstatistics.Summary= Table;
mdev.TSstatistics.LogL = [mdev.TSstatistics.LogL(:,ModelNo) LogLi];
mdev.TSstatistics.RespFeat= [mdev.TSstatistics.RespFeat(:,ModelNo) Yf_pred];
mdev.TSstatistics.RMSE= [mdev.TSstatistics.RMSE(:,ModelNo) RMSE];

% twostage info setup
%[mdev.MLE.Model        ,mdev] = tsinfo(mdev,mdev.MLE.Model);
%[mdev.TwoStage{1},mdev] = tsinfo(mdev,mdev.TwoStage{1});

% initialise PEV calcs
[Xg,Yrf,Sigma] = mledata(mdev,1);
if ~pevcheck(mdev.MLE.Model)
   mdev.MLE.Model= pevinit(mdev.MLE.Model,Xg,Yrf,Sigma);
end
if ~pevcheck(mdev.TwoStage{1})
   mdev.TwoStage{1}= pevinit(mdev.TwoStage{1},Xg,Yrf,Sigma);
end
pointer(mdev);

Models= {mdev.TwoStage{1} mdev.MLE.Model};

mdev.MLE.Validate=1;

mdev.TwoStage= Models;

pointer(mdev);

