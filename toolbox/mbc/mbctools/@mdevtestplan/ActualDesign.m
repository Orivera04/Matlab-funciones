function [des,index] = ActualDesign(T,Stage);
%MDEVTESTPLAN/ACTUALDESIGN
%
% [des,index] = ActualDesign(T,Stage);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:06:55 $ 

if nargin<2
    Stage= length(T.DesignDev);
end

[des,index] = ActualDesign(T.DesignDev,Stage);