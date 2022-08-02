function ssf= template(ssf);
% SWEEPSETFILTER/TEMPLATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:12:26 $

ssf.pSweepset        = xregpointer;
ssf.recordsToRemove  = [];
ssf.sweepsToRemove   = {};
ssf.variablesToKeep  = {};
ssf.reorderSweeps    = {};
ssf.variableSweepset = sweepset;

% ssf.variables: [0x0 struct]
% ssf.filter: [0x0 struct]
% ssf.defineTests: = [0x0 struct]
% ssf.allowsFlag:      = bitmax;
