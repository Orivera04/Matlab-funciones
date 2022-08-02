function opt = setOutputInfo(opt, okstat, errmsg, OUTPUT)
%SETOUTPUTINFO Set output information for the optimization
%
%  opt = SETOUTPUTINFO(opt, OK, ERRMSG, OUTPUT) sets output information for the
%  optimization in opt. The following information is set 
%  
%  OK     - (0/1), indicating whether the optimization has completed
%  without error
%  ERRMSG - Error message string if OK = 0. Must be an empty string if OK =
%  1
%  OUTPUT - Structure of algorithm statistics for the optimization.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:53 $ 

opt.lastOK = okstat;
opt.lastErr = errmsg;
opt.diagStat = OUTPUT;
