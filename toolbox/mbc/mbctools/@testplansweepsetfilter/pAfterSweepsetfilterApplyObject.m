function [out] = pAfterSweepsetfilterApplyObject(obj, out)
%PAFTERSWEEPSETFILTERAPPLYOBJECT 
%
%  OUT = PAFTERSWEEPSETFILTERAPPLYOBJECT(OBJ, OUT)
%  
%  Classes derived from sweepsetfilter should overload this method to
%  become part of the ApplyObject chain that modifies the input sweepset in
%  the defined way. The input OUT is the sweepset generated in 
%  sweepsetfilter/private/ApplyObject and should be changed according to
%  the rules of the derived class and passed back to the calling routine

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:11:24 $ 

out = ApplyObject(obj, out);