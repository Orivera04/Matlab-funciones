function Disp=DisplayList(f)
% LOCALMOD/DISPLAYLIST cell array of available response features

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:36 $

FList= DatumDisplay(f,features(f));

Disp= {FList.Display};