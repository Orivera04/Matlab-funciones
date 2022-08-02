function ind= isbad(S)
% SWEEPSET/ISBAD logical reference to bad data (NaN) points in sweepset
%
% logical reference to bad data points in sweepset

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:06:28 $



ind= isnan(S.data);