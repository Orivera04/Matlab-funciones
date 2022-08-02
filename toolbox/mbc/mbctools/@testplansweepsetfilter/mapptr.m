function tssf= mapptr(tssf,RefMap);
%TESTPLANSWEEPSETFILTER/MAPPTR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 08:11:22 $


tssf.ptestplan= mapptr(tssf.ptestplan,RefMap);
tssf.sweepsetfilter= mapptr(tssf.sweepsetfilter,RefMap);