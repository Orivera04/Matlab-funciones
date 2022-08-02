function [OK, msg, OUTPUT] = getOutputInfo(cos)
%GETOUTPUTINFO Set output information for the optimization
%
%  [OK, ERRMSG, OUTPUT] = GETOUTPUTINFO(COS) returns output information for
%  the optimization in COS. 
%
%  See also SETOUTPUTINFO

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:17 $ 

OK = cos.lastOK;
msg = cos.lastErr;
OUTPUT = cos.diagStat;

