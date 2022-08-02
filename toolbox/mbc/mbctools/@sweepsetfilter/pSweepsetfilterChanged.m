function [obj, ss] = pSweepsetfilterChanged(obj, ss)
%PSWEEPSETFILTERCHANGED respond to changes in the parent class
%
%  [OBJ, SS] = PSWEEPSETFILTERCHANGED(OBJ, SS)
%  
%  Classes derived from sweepsetfilter overload this method so as to be
%  informed of changes to the parent class. The input SS is the sweepset
%  produced by the sweepsetfilter object. For sweepsetfilter this method
%  updates the cache but derived classes are expected to carry out their
%  updates and then call pUpdateSweepsetCache in a similar fashion


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:09:18 $ 

[obj, ss] = pUpdateSweepsetCache(obj, ss);