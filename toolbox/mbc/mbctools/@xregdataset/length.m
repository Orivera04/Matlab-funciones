function s = length(T);
% DATASET/LENGTH

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 08:18:48 $

% NOT up to Version 2 standard yet.
% Supports new cell array structure but only refers to lowest level.

s = length(T.sizes{1});