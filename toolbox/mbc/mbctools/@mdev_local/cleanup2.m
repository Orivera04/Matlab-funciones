function mdev = cleanup2(mdev)
%CLEANUP2

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:21 $

if isfield(mdev.MLE,'Model')
   mdev.MLE.Model= saveobj(mdev.MLE.Model);
end

for i= 1:length(mdev.TwoStage)
   if isa(mdev.TwoStage{i},'xregtwostage')
      mdev.TwoStage{i}= saveobj(mdev.TwoStage{i});
   end
end
