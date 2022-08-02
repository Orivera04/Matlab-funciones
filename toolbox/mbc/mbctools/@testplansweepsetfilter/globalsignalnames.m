function signalNames = globalsignalnames(obj)
%GLOBALSIGNALNAMES returns signal names (from data) of the input factors to
%the global level of the testplan
%
%  SIGNALNAMES = GLOBALSIGNALNAMES(TSSF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.3 $    $Date: 2004/02/09 08:11:21 $ 

T = getTestplan(obj);
signalNames = factorNames(designdev(T), numstages(T));
