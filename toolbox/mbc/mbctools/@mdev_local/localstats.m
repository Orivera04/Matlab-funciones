function [OK,Stats,InSig,labs,head,ls]=localstats(mdev,SNo,Type,L,X,Y)
% MDEV_LOCAL/LOCALSTATS local statistics
%
% [Stats,InSig,labs,head,ls]=localstats(mdev,SNo,Type,L,X,Y)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.8.4.4 $  $Date: 2004/02/09 08:04:40 $




if nargin<=3
    % get local model and data
    [L,OK]=LocalModel(mdev,SNo);
    [X,Y]= getdata(mdev);
    X= X(:,:,SNo);
    Y= Y(:,:,SNo);
else
    OK= mdev.FitOK(SNo);
end


if OK
    % summary stats
    Pooled_RMSE= sqrt(mdev.MLE.Pooled_MSE);
    [Xs,Ys]= checkdata(L,X,Y);
    Wc= mdev.GLSWeights{SNo};
    [ls,S,W]= localstats(L,Xs{1},Ys{1},Wc);
    [ri,s2]= var(L);
    S= S*s2;
    W= W*s2;


    switch Type
        case 1  % parameters
            labs= labels(L,0);
            head= {'Value','Std Error'};
            if isempty(W)
                Stats= zeros(0,2);
                InSig= false(0,0);
            else
                Stats= [double(L) sqrt(diag(W))];
                InSig= abs(Stats(:,1))<tinv(0.99,mdev.MLE.df(SNo))*Stats(:,2);
            end
        case 2  % correlation matrix
            labs= labels(L,0);
            head = labs;
            if isempty(W)
                labs= {''};
                head={''};
                Stats= NaN;
            else
                [s,Stats]= xregcov2corr(W);
            end
            InSig= false(size(Stats,1),1);
        case 3  % 'rf'
            labs= children(mdev,RFstart(L)+1:numChildren(mdev),'name')';
            %		labs= detex(labs);
            head= {'Value','Std Error'};
            Vals= evalfeatures(L);
            if ~isempty(Vals)
                Stats= [Vals(:) sqrt(diag(S))];
                InSig= abs(Stats(:,1))<tinv(0.99,mdev.MLE.df(SNo))*Stats(:,2);
            else
                Stats= zeros(0,2);
                InSig= Stats;
            end
        case 4 % global variables
            [Xtp,Ytp]= getdata(mdev,'FIT');
            labs= get(Xtp{end},'name');
            TP= mdevtestplan(mdev);
            mg= model(TP);
            Ytp= getdata(TP,'Y');

            yg= Ytp(:,labs,SNo);
            labs= get(mg,'symbol');
            head= {'Value','Std Error'};
            Stats= [mean(yg)' std(yg{1})'];
            InSig= false(size(Stats,1),1);

        case 5 % diagnostics
            if ls.df==0
                se=0;
            else
                se= sqrt(ls.sse/ls.df);
            end
            %      labs= {'s_i','n_{obs}','df_{error}','R^2','Cond(J)','Cond(\Sigma)'}';
            labs= {'s_i','n_obs','df_error','R^2','Cond(J)','Cond(Sigma)'}';
            Stats= [se ls.nobs ls.df ls.R2 ls.Cond_Jacob]';
            InSig= false(size(Stats,1),1);
            head='';

        case 6 % global covariance
            if numfeats(L)>0
                if ~isempty(mdev.ResponseFeatures)
                    bind= RFstart(L)+mdev.ResponseFeatures(1,:);
                else
                    bind= (RFstart(L)+1):numChildren(mdev);
                end
                labs= children(mdev,bind,'name')';
                head= labs';
                TS= BestModel(mdev);
                if ~isempty(TS);
                    Stats= cov(TS);
                    if isempty(Stats)
                        Stats= zeros(length(labs));
                        Stats(:)=NaN;
                    end
                else
                    Stats= zeros(length(labs));
                    Stats(:)=NaN;
                end

                InSig= false(size(Stats,1),1);
            else
                labs=cell(1,0);
                head= labs';
                Stats= zeros(0,0);
                InSig= Stats;
            end

    end
else
    Stats=[];
    InSig=[];
    labs=[];
    head=[];
    ls=[];
end


