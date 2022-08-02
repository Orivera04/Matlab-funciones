function X= x2fx(TS,Xgc)
%X2FX

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:00:21 $

Nf= length(TS.Global);

% Global Models
Models = TS.Global;

for i= 1:Nf
   Xi=x2fx(Models{i},Xgc);
   x{i}= Xi(:,Terms(Models{i}));
end

X= blkdiag(x{:});
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
