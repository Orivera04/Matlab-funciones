function [OK,mdev]= fitmodel(mdev,varargin)
%FITMODEL Fit sweeps
%
%  [OK,B] = FITMODEL(mdev,SweepNos,ProcessResults)
%    mdev            mdev_local object (normally called via pointer as p.FitModel
%    SweepNos        optional argument to specify sweeps to update
%    ProcessResults  boolean to specify whether to update stats and rfs

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.4.5 $  $Date: 2004/04/04 03:31:15 $

if mdev.IsLinearised
    [mdev,OK] = FitLinearisedTwoStage( mdev, varargin{:} );
else
    [OK,mdev]= FitGTSLocal(mdev,varargin{:});
end



function [OK,mdev]= FitGTSLocal(mdev,SweepNos,ProcessResults)

% Get Data
[X,Y]= getdata(mdev);
Ns= size(X,3);

L= model(mdev);
if ~isGTS(L)
    % fit all tests for average fit model (+linearised in future?)
    % would prefer a method to tell me this
    SweepNos=':';
end


Nl=size(L,1);

B= mdev.AllModels;
Wc= mdev.GLSWeights;
if isempty(B)
    B= NaN*zeros(Nl,Ns);
    mdev.FitOK= false(1,Nl);
elseif size(B,2)<Ns
    Nl=size(B,1);
    B= [B NaN*zeros(Nl,Ns-size(B,2))];
    mdev.FitOK= [mdev.FitOK(:)' false(1,Nl)];
elseif size(B,2)>Ns
    B= B(:,1:Ns);
    mdev.FitOK= mdev.FitOK(1:Ns);
end
mdev.AllModels= B;


if isempty(Wc)
    Wc= cell(1,Ns);
elseif length(Wc)<Ns
    Wc= [Wc cell(1,Ns-length(Wc))];
elseif length(Wc)>Ns
    Wc= Wc(1:Ns);
end
mdev.GLSWeights= Wc;


if nargin > 1 && ~strcmp(SweepNos,':')
    X= X(:,:,SweepNos);
    Y= Y(:,:,SweepNos);
    if ~isempty(B)
        B= B(:,SweepNos);
    end
    if ~isempty(Wc)
        Wc= Wc(SweepNos);
    end
end

L= model(mdev);
DatumMode= get(L,'DatumType');

% turn warning off as flops gives 10^6 warnings in Optim Tbx
ws = warning('off');

if DatumMode==3
    % link to other Datum
    pdatum= datumlink(mdev);
    DATUM= double(pdatum.getdata('Y',0));
    if nargin > 1 && ~strcmp(SweepNos,':')
        DATUM= DATUM(SweepNos,:);
    end
    X= X-DATUM;
end

try
    [L,Bhat,Wchat,OK]= fitmodel(L,X,Y,B,Wc);
    % convert OK into true/false for inserting into FitOK field
    newFitOK = (OK>0);
    warning(ws);
catch
    warning(ws);
    rethrow(lasterror);
end

if nargin > 1 && ~strcmp(SweepNos,':')
    % Only processing a limited number of sweeps
    Nb=size(mdev.AllModels,1);
    % this augmentation is required for localmutli models
    if size(Bhat,1)<Nb
        % pad new parameters with zeros
        Bhat= [Bhat ; zeros(Nb-size(Bhat,1),size(Bhat,2)) ];
    elseif size(Bhat,1)>Nb
        % pad all parameters with zeros
        mdev.AllModels= [mdev.AllModels ; zeros(size(Bhat,1)-Nb,size(mdev.AllModels,2)) ];
    end
    mdev.AllModels(:,SweepNos)= Bhat;
    if ~isempty(Wchat)
        mdev.GLSWeights(SweepNos)= Wchat;
    end
    mdev.FitOK(SweepNos)= newFitOK;

    mdev= Change_RespFeat(mdev,SweepNos);

else
    % update model (incl covmodel)
    % only do this if all sweeps are processed
    mdev= model(mdev,L);

    % update model fit
    mdev.AllModels= Bhat;
    mdev.GLSWeights= Wchat;
    mdev.FitOK= newFitOK;

    mdev= Change_RespFeat(mdev);

end


% Update statistics
mdev.MLE.SSE(~mdev.FitOK)= 0;
mdev.MLE.SSE_nat(~mdev.FitOK)= 0;
mdev.MLE.df(~mdev.FitOK)= 0;

SSE= mdev.MLE.SSE;
df = mdev.MLE.df;

% Summary Statistics for local model
DFT= sum(df(mdev.FitOK));
if DFT
    Pooled_MSE= sum(SSE(mdev.FitOK))/DFT;
else
    Pooled_MSE= NaN;
end
mdev.MLE.Pooled_MSE= Pooled_MSE;

SSE= mdev.MLE.SSE_nat;
ind= isfinite(SSE(:)) & mdev.FitOK(:);
DFT= sum(df(ind));
if DFT
    Pooled_MSE= sum(SSE(ind))/DFT;
else
    Pooled_MSE= NaN;
end

if nargin <= 2 || ProcessResults
    % mdev_local summary stats
    ch  = colhead(mdev);
    mdev= statistics(mdev,[sqrt(Pooled_MSE) repmat(NaN,1,length(ch)-1)]);
    return
end
mdev= BestModel(mdev,0);

% Update heap copy of object
pointer(mdev);
