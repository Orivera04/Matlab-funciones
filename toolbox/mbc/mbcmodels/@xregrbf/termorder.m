function [NewOrder,numorder,orderlabels] = termorder(m)
%TERMORDER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:57:26 $

NewOrder= 1:size(m,1);
numorder= size(m,1);
orderlabels={'Radial Basis Function Terms'};
