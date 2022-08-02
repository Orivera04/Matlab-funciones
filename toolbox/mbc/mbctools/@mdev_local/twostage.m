function TSModels= twostage(mdev,selrf)
%TWOSTAGE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.4.5 $  $Date: 2004/04/04 03:31:18 $

if nargin == 1
    TSModels= mdev.TwoStage;
else
    presp= Parent(mdev);

    % mdev= localinfo(mdev);
    L= model(mdev);

    TS= presp.model;

    X = getdata(mdev,'FIT');
    XGd= double(X{end});

    prf= children(mdev);

    DatumModel= get(TS,'Datum');
    Xcode= gcode(TS,XGd);

    RF1= RFstart(L);
    DatumType= get(L,'DatumType');
    switch DatumType
        case {1,2}
            DatumModel= prf(1).model;
            Yrf= double(prf(1).getdata('Y'));
            bd= ~isfinite(Yrf);
            DatumModel= InitStore(DatumModel,Xcode,Yrf,bd,false);
        case 3
            pdatum= datumlink(mdev);
            DatumModel= pdatum.model;
            Yrf= double(pdatum.getdata('Y'));
            bd= ~isfinite(Yrf);
            DatumModel= InitStore(DatumModel,Xcode,Yrf,bd,false);
    end

    sse=  mdev.MLE.SSE;
    df= mdev.MLE.df;
    DFT= sum(df(mdev.FitOK));
    if DFT
        s2= sum(sse(mdev.FitOK))/DFT;
    else
        s2= 0;
    end
    % Yrf= double(info(mdev.RFData));

    Yrf= children(mdev,'getdata','Y');
    for i=1:length(Yrf)
        Yrf{i}= double(Yrf{i});
    end
    Yrf= [Yrf{:}];
    mrf= children(mdev,'model');
    for j= RF1+1:length(mrf);
        % initialise response feature models
        Yrfi= Yrf(:,j);
        bd= ~isfinite(Yrfi);
        mrf{j}= InitStore(mrf{j},Xcode,Yrfi,bd);
    end

    TSok= false( size(selrf,1),1 );
    TSModels= cell(size(TSok));
    for i=1:size(selrf,1);
        % select response features for localmod
        Lf= EvalDelG(SelFeat(L,selrf(i,:)));
        % select global models
        G= mrf(RF1+selrf(i,:));
        TS= xregtwostage(Lf,G,DatumModel);
        % use real covariance rather than inv(X'*X)
        srf= selrf(i,:);
        dok= all(isfinite(Yrf(:,srf+RF1)),2);
        Sigma= s2*mdev.MLE.Sigma(srf,srf,dok);
        % initialise PEV for univariate model
        [TSModels{i},TSok(i)]= pevinit(TS,XGd(dok,:),Yrf(dok,srf+RF1),Sigma,1);
    end
    TSModels= TSModels(TSok);
    selrf= selrf(TSok,:);
    mdev.TwoStage= TSModels;

    OldBest= bestmdev(mdev);
    if OldBest~=0
        OldRF=mdev.ResponseFeatures(OldBest,:);
        ind= ismember(selrf,OldRF,'rows');
        if any(ind)
            mdev.modeldev= BestModel(mdev.modeldev,find(ind));
        else
            mdev= BestModel(mdev,0);
        end
    end
    mdev.ResponseFeatures   = selrf;

    TS= pointer(mdev);
end
