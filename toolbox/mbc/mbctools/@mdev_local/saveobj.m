function md= saveobj(md);
% MODELDEV/SAVEOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:05:08 $


if isfield(md.MLE,'Model')
   md.MLE.Model= 1; % saveobj(md.MLE.Model);
end

for i= 1:length(md.TwoStage)
   if isa(md.TwoStage{i},'xregtwostage')
      md.TwoStage{i}= saveobj(md.TwoStage{i});
   end
end

if isfield(md.MLE,'Init')
	md.MLE= mv_rmfield(md.MLE,'Init');
end
% clear history
md.modeldev= saveobj(md.modeldev);


