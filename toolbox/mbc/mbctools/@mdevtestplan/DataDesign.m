function T=DataDesign(T,Dp);
% MDEVTESTPLAN/DATADESIGN

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:07:03 $


% set best design to root
dlist= DesignList(T.DesignDev);
T.DesignDev= setActualDesign(T.DesignDev,dlist{1});

T.Matched= 0;
pointer(T);

