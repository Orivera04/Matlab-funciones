function m = model(xsm, newm)
%MODEL Internal function to access the underlying model
%
%  XM = MODEL(M) returns the xregmodel that is underlying the
%  xregStatsModel M.
%
%  M = MODEL(M, XM) replaces the underying xregmodel with a new one, XM.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.7.2.4 $  $Date: 2004/02/09 07:57:54 $

if nargin==1
    m = xsm.mvModel;
else
    xsm.mvModel = newm;
    m = xsm;
end