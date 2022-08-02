function T = addDesign(T,des,Stage);
%MDEVTESTPLAN/ADDDESIGN
%
% T = addDesign(T,des,Stage);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:07:30 $ 

if nargin<3
    Stage= length(T.DesignDev);
end

T.DesignDev = addDesign(T.DesignDev,Stage);

xregpointer(T);