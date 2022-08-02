function obj = emptyClusterInfoCache(obj)
%EMPTYCLUSTERINFOCACHE A short description of the function
%
%  OUT = EMPTYCLUSTERINFOCACHE(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:11:18 $ 

obj.codeddesign = [];

% Empty clusters maintaining the structure
obj.clusters(:) = [];

obj.cachedInfo = struct(....
    'dataindesign', [],...
    'designindata', [],...
    'globaldata', [],...
    'uncodeddesign', [],...
    'meandata', []);