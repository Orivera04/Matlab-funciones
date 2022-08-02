function [L,ok]= LocalModel(mdev,SweepNos)
%LOCALMODEL Return local model for given Sweep Number(s)
%
%  [L,ok]= LocalModel(mdev,SNo) returns a local model given a sweep number.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.5 $  $Date: 2004/04/04 03:31:08 $

if nargin<2 || strcmp(SweepNos,':')
    SweepNos= 1:size(mdev.AllModels,2);
end

L= model(mdev);

if DatumType(L)==3
    % get datum link
    pdatum= datumlink(mdev);
    % get datum (no outliers)
    D= double(pdatum.getdata('Y',0));
end

selrf= SelectRF(L);
if mdev.IsLinearised && ~isempty(selrf) && allLinearRF(L) && isfield(mdev.MLE,'Sigma');
    quickPEV= true;
    L = EvalDelG(L);
    L2= SelFeat(L,selrf(1,:));
    dG= inv(delG(L2));
else
    quickPEV= false;
end


[X,Y]= getdata(mdev);
if length(SweepNos)==1
    ok= mdev.FitOK(SweepNos);
    if ok
        if DatumType(L)==3
            % use datum
            L= update(L,mdev.AllModels(:,SweepNos),[]);
            L= datum(L,D(SweepNos));
        else
            L= update(L,mdev.AllModels(:,SweepNos));
        end
        % update delG matrix
        selrf= SelectRF(L);
        if quickPEV;
            V= mdev.MLE.Sigma(selrf(1,:),selrf(1,:),SweepNos);
            [ri,pr] = chol(V);
            if pr
                ri= zeros(size(V));
            else
                ri= ri';
            end
            L= var(L,ri,mdev.MLE.Pooled_MSE,mdev.MLE.df(SweepNos));
        else
            % Full GTS
            L = EvalDelG(L);
            L= pevinit(L,X(:,:,SweepNos),Y(:,:,SweepNos));
        end
    end
else
    AllModels= cell(1,length(SweepNos));
    SweepNos= SweepNos(:)';
    for i= SweepNos
        if mdev.FitOK(i)
            if DatumType(L)==3
                L= update(L,mdev.AllModels(:,i),D(i));
            else
                L= update(L,mdev.AllModels(:,i));
            end
            if quickPEV;
                V  = mdev.MLE.Sigma(selrf(1,:),selrf(1,:),i);
                [ri,pr] = chol(dG*V*dG');
                if pr
                    ri= zeros(size(V));
                else
                    ri= ri';
                end
                L  = var(L,ri,mdev.MLE.Pooled_MSE,mdev.MLE.df(i));
            else
                % Full GTS
                L = EvalDelG(L);
                L= pevinit(L,X(:,:,i),Y(:,:,i));
            end
        end
        AllModels{i}= L;
    end
    L= AllModels;
    ok= mdev.FitOK(SweepNos);
    ok= ok(:)';
end
