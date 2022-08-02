function [num,SharedData,TPs] = numSharedData(MP,Dp)
%MDEVPROJECT/NUMSHAREDDATA
%
% [num,SharedData] = numSharedData(MP,Dp)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.2.6.2 $  $Date: 2004/02/09 08:03:44 $

pTSSF= children(MP,'DataLinkPtr');
pTSSF= [pTSSF{:}];
SameOriginal = Dp == pTSSF;

num    = sum(SameOriginal);
SharedData = pTSSF(SameOriginal);
TPs= children(MP,SameOriginal);

