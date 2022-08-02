function mdev= ChooseAsBest(mdev,Index)
%CHOOSEASBEST choose best model from sub-models
% 
% OK= ChooseAsBest(mdev,Index)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:09:26 $

ch= children(mdev);

if isa(Index,'xregpointer') && ~any(Index==ch)
    error('mbc:modeldev:InvalidIndex','Invalid model selected as best');
elseif Index<1 || Index>length(ch);
    error('mbc:modeldev:InvalidIndex','Invalid model selected as best');
end    

if ~isa(Index,'xregpointer')
    Index= ch(Index);
end
% select best model
mdev= BestModel(mdev,Index);


