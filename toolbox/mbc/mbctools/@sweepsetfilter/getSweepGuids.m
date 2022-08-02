function array = getSweepGuids(obj, varargin)
%SWEEPSETFILTER/GETSWEEPGUIDS returns the GUIDARRAY from a sweepsetfilter
%
%  OUT = GETSWEEPGUIDS(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:08:54 $ 

array = getSweepGuids(sweepset(obj), varargin{:});