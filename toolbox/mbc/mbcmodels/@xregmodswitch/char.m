function c = char(m,TeX)
%CHAR Convert model to a string representation
%
%  STR = CHAR(MODEL, TEXFLAG) creates a string that describes the model.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 07:53:35 $

xi= xinfo(m);
s= getSwitchFactors(m);
s= sprintf('%s,',xi.Symbols{s});
c= ['Local Maps: [',s(1:end-1),']'];
