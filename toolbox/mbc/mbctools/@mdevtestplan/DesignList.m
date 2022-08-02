function [dlist,index] = DesignList(T,Stage);
%MDEVTESTPLAN/DESIGNLIST
%
% [dlist,index] = DesignList(T,Stage);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:07:10 $ 

if nargin<2
    Stage= length(T.DesignDev);
end

[dlist,index] = DesignList(T.DesignDev,Stage);