function [BMIndex,Table]= validate(mdev,hFig)
%VALIDATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.4.4 $  $Date: 2004/04/04 03:31:19 $

TSModels = mdev.TwoStage;
selrf    = mdev.ResponseFeatures;

[Xag,Y]= getdata(mdev,'FIT');
X   = Xag{1};    % Local Input Data 
XG  = Xag{end};  % Global Input Data

Y(:,:,~mdev.FitOK)= NaN;

L= model(mdev);
G= children(mdev,'BestModel');

% Get Response Feature data from Local Fit
Yf= mdev.RFData.info;
Yf= double(Yf);
Nf= length(get(L,'Values'));
if size(Yf,2)>Nf
   rf1=RFstart(L);
   Yf(:,rf1)=[];
end

% You can only calculate PRESS for linearmods
CalcPRESS=1;
for i=1:length(G)
   CalcPRESS= CalcPRESS & islinear(G{i});
end
if DatumType(L)
   dm= children(mdev,1,'model');
   CalcPRESS = CalcPRESS & islinear(dm{1});
end

N= size(X,3);
sigma2= mdev.MLE.Pooled_MSE;

LogLi= zeros(N,length(TSModels));


Yf_pred= zeros(size(Y,3),length(TSModels));
RMSE= Yf_pred;

XGts= [zeros(size(XG,1),size(X,2)) double(XG)];

Lfpred = cell(1,length(TSModels));
SSr1= Y;
Yr= double(Y);

if CalcPRESS
   Table= zeros(length(TSModels),4+CalcPRESS);
   Yf_PRESS= Yf_pred;
   RPRESS= Yf_pred;
   SSr2= Y;
else
   Table= zeros(length(TSModels),4);
end

if nargin>1 && ishandle(hFig)
    mbH = MBrowser;
    DO_STATUS_UPDATE = true;
    setProgressBar(mbH, 'value', 0);
    msgID = mbH.addStatusMsg('Building Two-stage Models...');
else
    DO_STATUS_UPDATE = false;
end

Y_pred = cell(1, length(TSModels));
Y_PRESS = cell(1, length(TSModels));
for i= 1:length(TSModels)
   
   % log likelihood
   TS= TSModels{i};
   
   
   [Xg,Yrf,Sigma] = mledata(mdev,i);
	% initialise pev for univariate case
	TS= pevinit(TS,Xg,Yrf,Sigma,1);
   [TS,alg]=mle_Algorithm(TS);
   [f,G{i},Li,OK]= loglikFcn(TS,Xg,Yrf,Sigma);

   LogLi(OK,i)=Li;
   LogLi(~OK,i)= NaN;
   Table(i,end)= f;
   
   % Ordinary Predictions
   Y_pred{i}= TS(Xag);
   SSr1(:,1)= Yr-Y_pred{i};
   [Yg,Lfpred{i}]= EvalModel(TS,XGts);
   
   if CalcPRESS
      % PRESS Predictions
      [Y_PRESS{i},LfPRESS] = presspred(TS,{X,double(XG)});
      SSr2(:,1)= Yr-Y_PRESS{i};
   end
   
   rf= selrf(i,:);
   for k=1:N											
      
      %   for i=1:length(TSModels)
      % Response Feature residuals 
      % need to account for ytrans here !!!!!!!!!!!????????????
      
      if mdev.FitOK(k)
         % Response Feature Covariance Matrix for sweep k
         S= squeeze( mdev.MLE.Sigma(rf,rf,k) )*sigma2 + G{i};
      
         [Yf_pred(k,i),RMSE(k,i)]= i_CalcRFStats(Yf(k,rf),Lfpred{i}(k,:),S,SSr1(:,:,k));
         
         if CalcPRESS
            [Yf_PRESS(k,i),RPRESS(k,i)]= i_CalcRFStats(Yf(k,rf),LfPRESS(k,:),S,SSr2(:,:,k));
         end
      else
         Yf_pred(k,i)= NaN;
         RMSE(k,i) = NaN;
         Yf_PRESS(k,i)= NaN;
         RPRESS(k,i)= NaN;
      end
      
   end
	if DO_STATUS_UPDATE
		setProgressBar(mbH,'value',i./length(TSModels));
	end
end
if DO_STATUS_UPDATE
    setProgressBar(mbH,'value', 0);
    mbH.removeStatusMsg(msgID);
end

sn= statistics(mdev);

for i= 1:length(TSModels)
   ResAll= double(Y)- Y_pred{i};
   rOK= isfinite(ResAll);
	if any(rOK)
		ResAll=ResAll(rOK);
		VarR= sum(ResAll.^2,1)/(length(ResAll));
	else
		VarR=0;
	end
   s= sqrt(VarR);

   % Look at Response Features
   resids= Yf_pred(:,i);
   residsOK= all(isfinite(resids),2)';
   resids= resids(residsOK,:);
   dfFeat= length(resids);
   if dfFeat
      VarRF(1)= ( sum(resids,1)./dfFeat );
   else
      VarRF(1)= 0;
   end
   
   if CalcPRESS
		% PRESS RMSE
      ResAll= double(Y)- Y_PRESS{i};
      rOK= isfinite(ResAll);
		if any(rOK)
			ResAll=ResAll(rOK);
			VarPRESS= sum(ResAll.^2,1)/(length(ResAll));
		else
			VarPRESS= 0;
		end
      sp= sqrt(VarPRESS);
      
      Table(i,1:end-1)= [sn(1) s sp VarRF(1)];
   else
      Table(i,1:end-1)= [sn(1) s VarRF(1)];
      
   end
   
end

mdev.TSstatistics.Summary= Table;
mdev.TSstatistics.RespFeat= Yf_pred;
mdev.TSstatistics.LogL = LogLi;
mdev.TSstatistics.RMSE = RMSE;

if CalcPRESS
   mdev.TSstatistics.RPRESS = RPRESS;
   [dum,ind]= min(Table(:,3));
else
   [dum,ind]= min(Table(:,2));
end
if ~isempty(Table)
   BMIndex= ind(1);
   
   mdev.MLE.Validate=0;
   
   if isfield(mdev.MLE,'BestModel') 
      mdev.MLE= rmfield(mdev.MLE,'BestModel');
   end
   if isfield(mdev.MLE,'Model') 
      mdev.MLE= rmfield(mdev.MLE,'Model');
   end
   pointer(mdev);
else
   BMIndex= [];
end

return

% sweep residual stats
function [Yf_pred,RMSE]= i_CalcRFStats(Yf,Lf,S,SSr)

r= Yf - Lf;

% T^2 stats
if all(isfinite(r)) && all(isfinite(S(:))) && rank(S) == size(S,1)
   Yf_pred = r/S*r';
else
   Yf_pred = NaN;
end

% Predicted RMSE
res= double(SSr);
rok= isfinite(res);
if any(rok)
   RMSE = sqrt(sum(res(rok).^2)/sum(rok));
else
   RMSE = NaN;
end

   
