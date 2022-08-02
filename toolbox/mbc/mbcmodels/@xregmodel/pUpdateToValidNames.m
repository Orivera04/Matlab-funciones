function [m, lChanged, nameMap] = pUpdateToValidNames(m, nameMap, XnameMap);
%XREGMODEL/PUPDATETOVALIDNAMES
%
% m= pUpdateToValidNames(m,NameMap);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.2 $  $Date: 2004/04/04 03:30:24 $

    
%  Update input and output names
[m.Xinfo.Names, lXChanged] = pUpdateToValidNames(m.Xinfo.Names, nameMap);
[m.Yinfo.Name,  lYChanged] = pUpdateToValidNames(m.Yinfo.Name, nameMap);
    
% Did anything change?
lChanged = lXChanged || lYChanged;
