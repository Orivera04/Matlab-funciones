function [RfStr,sigmaStr] = sweep_plot(mdev,Xs,Ys,ModelNos,SNo,AxHand,PlotOpts,PlotModes)
%SWEEP_PLOT Plot twostage sweep predictions

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.4 $  $Date: 2004/02/09 08:05:12 $

RfStr='';
sigmaStr='';

[PredType,MultiModel,MLEMode]= deal(PlotModes{:});
% PredType = normal/PRESS
% MultiModel = MultiSelected or not
% MLEMode = Verify MLE or not

[bdflag,Trans,CIFlag,AbsX,ModelRange]= deal(PlotOpts{:});

% all TS models of this mdev_local
Models= mdev.TwoStage;
if MLEMode==2 && length(Models)>1
    % make sure evaluation picks up the right model
    ModelNos=2;
end
if MLEMode
    selrf  = mdev.ResponseFeatures([1 1],:);
    sm= mdev.MLE.Pooled_MSE;    % pooled mean squared error
    sigma2 = [sm sm];
else
    selrf  = mdev.ResponseFeatures;
    sigma2 = repmat(mdev.MLE.Pooled_MSE,length(Models),1);
end
LogL= mdev.TSstatistics.LogL;
TSModels= Models(ModelNos);
selrf= selrf(ModelNos,:);
sigma2= sigma2(ModelNos);

% ----------------------------------------------------------------------


% the local model
L= model(mdev);
XL= Xs{1};
XG= Xs{2};


% all values of response features of this local model
Yf= mdev.RFData.double;
% and just get data for this sweep
Yf= Yf(SNo,RFstart(L)+1:end);

Sigma= squeeze(mdev.MLE.Sigma(:,:,SNo));

% validate two stage models
switch PredType
    case 1
        [h,Lpred,Lfpred]= plot(TSModels{:},Xs,Ys,[PlotOpts{:},0],AxHand(1));
        t2= mdev.TSstatistics.RespFeat(SNo,ModelNos);
    case 2
        [h,Lpred,Lfpred]= plot(TSModels{:},Xs,Ys,[PlotOpts{:},SNo],AxHand(1));
        t2= NaN*ones(1,length(ModelNos));
end

State= get(AxHand(1),'nextplot');
set(AxHand(1),'nextplot','add')
[L,LfitOK]= LocalModel(mdev,SNo);

mbh=MBrowser;
ATLOCALNODE = strcmp(mbh.CurrentNode.guid,'local');
if LfitOK && (~MultiModel || ATLOCALNODE)
    % Generate local fit curve (to compare with TS)
    L= SelFeat(L,selrf);

    [XL,YL,DataOK]= FitData(mdev,SNo);
    plot(L,XL,YL,DataOK,[PlotOpts{:}],AxHand(1));

else
    % do not draw local fit
    X=Xs;
    Y= Ys;
    XGcoded = gcode(TSModels{1},double(XG));
    for i=1:length(TSModels)
        Xs= X;
        Ys= Y;
        TS= TSModels{i};
        % local model not fitted so use estimated datum
        if ~AbsX && get(TS,'datumtype')
            dmodel= get(TS,'datum');
            XL= XL- dmodel(XGcoded);
            xn= get(XL,'name');
            set(XL,'name',[xn{1},'-Datum']);
        end
        if Trans
            % what to do for multimodels?
            yunits= get(Ys,'units');
            Fy= get(L,'ytrans');
            if  ~isempty(Fy)
                Ys{1}= ytrans(L,Ys{1});
                Units= char( subs(sym(Fy),'MVUNits') );
                yunits= strrep(Units,'MVUNits',char([yunits{:}]));
                set(Ys,'units',yunits)
            end
        end
        L= get(TS,'local');
        if sum(InputFactorTypes(L)==1)==1
            % plot against data
            Xplt= Xs{1};
            if bdflag
                [hLine,hLeg] = plot(Xplt(:,1),Ys,'b.','bd','parent',AxHand(1));
            else
                [hLine,hLeg] = plot(Xplt(:,1),Ys,'b.','parent',AxHand(1));
            end
            delete(hLeg);
        end;
    end
end
set(AxHand(1),'nextplot',State)

% output RFStr?
if nargout
    if ~MultiModel && LfitOK
        % display response feature info
        r=  (Lfpred{1}-Yf(:,selrf));
        S= Sigma *sigma2;
        S=S(selrf,selrf);
        sd= diag(1./sqrt(diag(S)));
        S= sd*S*sd;
        r= r*sd;
        if all(isfinite(S(:))) && rank(S)==size(S,1)
            rn= r/chol(S);
        else
            rn= repmat(Inf,1,size(S,1));
        end

        chnames= char(children(mdev,'name'));
        chnames= chnames(RFstart(L)+1:end,:);
        % don't let displayed RF names be longer than 25
        maxNameLength = min(size(chnames,2),25);
        % concatenate strings
        rfname = strvcat('RF Name',chnames(selrf,1:maxNameLength));
        rfhat = strvcat(' RFhat',num2str(Lfpred{1}(:),'%10.2g'));
        rf = strvcat(' RF',num2str(Yf(:,selrf)','%10.2g'));
        rfT = strvcat(' RF t',num2str(rn(:),'%6.2f'));

        RfStr = [ rfname,...
            blanks(length(selrf)+1)',rfhat,...
            blanks(length(selrf)+1)',rf,...
            blanks(length(selrf)+1)',rfT];
    end
end

% output sigmaStr?
if nargout>1
    % display info
    for ModNo=1:length(ModelNos)
        rf= selrf(ModNo,:);
        S= Sigma(rf,rf)*sigma2(ModNo);
        rp=(double(Ys)-Lpred{ModNo});
        rp= rp(isfinite(rp));
        if length(rp)>0
            sp = sqrt( sum(rp.^2)/(size(rp,1)-size(S,1)) );
        else
            sp = NaN;
        end

        sigmaStr= sprintf('%10.3g %10.3g %10.3g',t2(ModNo),LogL(SNo,ModNo),sp);
    end
end
