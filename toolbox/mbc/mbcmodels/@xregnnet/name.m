function n= name(m)
% XREGNNET/NAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:56:26 $

neurs = get(m,'hiddenneurons');
if length(neurs)==1
    n = sprintf('nnet_[%d]', neurs);
else
    n = sprintf('nnet_[%d,%d]', neurs);
end
