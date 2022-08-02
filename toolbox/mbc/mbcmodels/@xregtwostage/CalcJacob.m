function X= CalcJacob(TS,Xgc)
%XREGTWOSTAGE/CALCJACOB

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:59:09 $

Nf= length(TS.Global);

% Global Models
Models = TS.Global;
x= cell(1,Nf);
for i= 1:Nf
   x{i}= jacobian(Models{i},Xgc);
end

% if size(Xgc,1)>100
%    % use sparse if more than 100 sweeps
%    X= spblkdiag(x{:});
% else
%    X= blkdiag(x{:});
% end

X= spblkdiag(x{:});


% Augmented Data Matrix


% order is
% [F1 F2 F3 ... Fq]
% Reorder so it is 
% [S1;S2;S3 ; ... Sn];
% New row order is [1:N:end 2:N:end ... m:N:end]

% don't want to change coeff order otherwise it is going to be
% hard to put models back together

Ns= round(size(X,1)/Nf);
if Ns>1
   Zind= reshape(1:Nf*Ns,Ns,Nf)';
   X= X(Zind(:),:);
end