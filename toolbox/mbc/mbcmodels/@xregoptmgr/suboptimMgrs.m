function [slist,subOM]= suboptimMgrs(om);
% OPTIMMGRS/SUBOPTIMMGRS lsit of properties which are optimMgrs

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:57:04 $

isom= cellfun('isclass',{om.foptions.Value},'xregoptmgr');
slist= {om.foptions(isom).Param};
subOM= {om.foptions(isom).Value};