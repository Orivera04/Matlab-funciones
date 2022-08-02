function array = getGuids(obj, varargin)
%SWEEPSETFILTER/GETGUIDS returns the GUIDARRAY from a sweepsetfilter
%
%  OUT = GETGUIDS(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:08:52 $ 

array = getGuids(sweepset(obj), varargin{:});