function out = cgrules(varargin)
% CGRULES constructor

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:55:19 $

out = struct('fact_i1',[],...
    'min1',[],...
    'max1',[],...
    'fact_i2',[],...
    'min2',[],...
    'max2',[],...
    'enable',[],...
    'exclude',[]);

out = class(out,'cgrules');
if nargin>0
    out = set(out,varargin{:});
end
