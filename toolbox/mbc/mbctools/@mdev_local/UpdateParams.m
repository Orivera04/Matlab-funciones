function mdev= UpdateParams(mdev,SweepNos,Bhat,Wchat);
%MDEV_LOCAL/UPATEPARAMS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 08:04:19 $

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

mdev.GLSWeights{SweepNos}= Wchat;


xregpointer(mdev);
