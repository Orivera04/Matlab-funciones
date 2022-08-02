function OK = isTestplanData(MP, pData)
%ISTESTPLANDATA determine if data is linked to a testplan
%
%  OUT = ISTESTPLANDATA(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:03:35 $ 

% At the moment this is determined by the class of the object, but could in
% future be more complicated
OK = isa(pData.info, 'testplansweepsetfilter');