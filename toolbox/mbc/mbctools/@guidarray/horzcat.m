function obj = horzcat(varargin)
%HORZCAT concatenate GUIDARRAY object together
%
%  OUT = HORZCAT(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:00:49 $ 

% Shortcut for concatenating cellarrays of guidarrays
obj = vertcat(varargin{:});