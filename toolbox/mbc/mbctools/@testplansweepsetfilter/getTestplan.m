function T = getTestplan(tssf)
%GETTESTPLAN A short description of the function
%
%  OUT = GETTESTPLAN(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:11:20 $ 

if isvalid(tssf.ptestplan)
    T = tssf.ptestplan.info;
else
    T = mdevtestplan;
end