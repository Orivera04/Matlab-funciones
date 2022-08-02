function mdev= Change_RespFeat(mdev,RFno,L)
%CHANGE_RESPFEAT Change response feature data update
%
%  mdev= CHANGE_RESPFEAT(mdev,RFno,varargin);  % change rf definition for RFno
%  mdev= CHANGE_RESPFEAT(mdev,SweepNos);       % change rf for SweepNos
%  mdev= CHANGE_RESPFEAT(mdev);                % change all sweeps/rfs

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/02/09 08:03:57 $



SweepNos= 1:size(mdev.AllModels,2);

if nargin>2
	% change rf defn
	mdev= model(mdev,L);
	RFno= RFno + RFstart(L);
else
	L= model(mdev);
	% change all rfs
	if nargin==2
		% sweeps specified
		SweepNos= RFno;
	end
	RFno= 1:numfeats(L);
	if RFstart(L);
		RFno= [1 RFno+1];
	end
end



% this is now a way to get clean data
[X,Yresp]= getdata(mdev);
[X,Y,DataOK,bd]= checkdata(L,X,Yresp);
Yresp(bd)= NaN;
% bad sweeps
Yresp(:,:,~DataOK)= NaN;
if any(DataOK)
	X(:,:)= invcode(L,double(X));
end
if ~isempty(mdev.GLSWeights)
	Wc= mdev.GLSWeights;
else
	Wc= cell(1,size(X,3));   
end



Nf= numfeats(L);
Ns= length(SweepNos);
NewRF=zeros(Ns,Nf);
nl= nfactors(L);
D= zeros(Ns,nl);

if isempty(mdev.MLE) || size(mdev.AllModels,2) ~= size(mdev.MLE.Sigma,3)
	% size of data may have changed
	Ns= size(mdev.AllModels,2);
	Sigma   = zeros(Nf,Nf,Ns);
	SSE_nat = zeros(Ns,1);
	sse     = zeros(Ns,1);
	df      = ones(Ns,1);
else
	Sigma   = mdev.MLE.Sigma;
	SSE_nat = mdev.MLE.SSE_nat;
	sse     = mdev.MLE.SSE;
	df      = mdev.MLE.df;
end

if Nf~=size(Sigma,1)
	Sigma   = zeros(Nf,Nf,Ns);
end

mdev.IsLinearised = false;
j=1;
m=1;
for i= SweepNos
	if mdev.FitOK(i)
		j= sum(DataOK(1:i));
		L= LocalModel(mdev,i);
		Xc= code(L,X{j});
		D(m,:)= datum(L);
		NewRF(m,:)= evalfeatures(L);
		% need to re-evaluate covariance matrix as well
		if ~isempty(Wc{i}) && length(Y{j})~=size(Wc{i},1)
			yhat= eval(L,Xc);
			if isTBS(L)
				yhat= ytrans(L,yhat);
			end
			Wc{i}= choltinv(covmodel(L),yhat);
			mdev.GLSWeights{i}= Wc{i};
		end
		
		[SummStats,sig]= localstats(L,Xc,Y{j},Wc{i});
		
		SSE_nat(i) = SummStats.SSE_natural;
		sse(i)     = SummStats.sse;
		df(i)      = SummStats.df;
		Sigma(:,:,i)= sig;
		j=j+1;
	else
		SSE_nat(i) = Inf;
		sse(i)     = Inf;
		df(i)      = 0;
		
		NewRF(m,:)  = NaN;
		D(m,:)        = NaN;
	end
	m=m+1;
end


mdev.MLE.Sigma  = Sigma  ;
mdev.MLE.SSE_nat= SSE_nat;
mdev.MLE.SSE    = sse;
mdev.MLE.df     = df; 


if RFstart(L)
	NewRF= [D NewRF];
end

% set up guids for response feature data and remove any global outliers which change
sguids = getSweepGuids(Yresp,'goodonly');
RF = mdev.RFData.info;
RF  = setGuids(RF,sguids);
% update rf data
if ~isempty(NewRF)
    RF(SweepNos,:)= NewRF;
end
mdev.RFData.info= RF;
mdev   = updateOutlierIndices(mdev,Yresp,RF);

pointer(mdev);
