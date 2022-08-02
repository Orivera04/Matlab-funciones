function X= JacobGlobalVar(TS,Xg)
%JACOBGLOBALVAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:14 $


Nf= length(TS.Global);

% Global Models
Models = TS.Global;

x= cell(Nf,1);
for i= 1:Nf
    Xgc= code(Models{i},Xg);
    x{i}=CalcJacob(Models{i},Xgc);
    yi= get(Models{i},'yinv');
    isyt=0;
    if ~isempty(yi)
        isyt=1;
        yhat = eval(Models{i},Xgc);
        DY= yinvdiff(Models{i},yhat);
    elseif isTBS(Models{i})
        isyt=1;
        % Calculate inverse transformation using symbolic toolbox
        yhat = ytrans(Models{i},eval(Models{i},Xgc));
        DY= yinvdiff(Models{i},yhat);
    end
    if isyt
        % adjust rf jacobian by ytrans factor
        sdy= length(DY);
        if sdy>100
            DY= spdiags(DY(:),0,sdy,sdy);
        else
            DY= diag(DY(:));
        end
        x{i}= DY*x{i};
    end
    
    
end

X= spblkdiag(x{:});
% Augmented Data Matrix


% order is
% [F1 F2 F3 ... Fq]
% Reorder so it is 
% [S1;S2;S3 ; ... Sn];
%  New row order is [1:N:end 2:N:end ... m:N:end]

% don't want to change coeff order otherwise it is going to be
% hard to put models back together

Ns= round(size(X,1)/Nf);
if Ns>1
    Zind= reshape(1:Nf*Ns,Ns,Nf)';
    X= X(Zind(:),:);
end



