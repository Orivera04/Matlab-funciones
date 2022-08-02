% File : build(obj, modelName, rtwRoot, tmf, buildOpts, buildArgs)
%
% Abstract :
%   Initiate a build for model specified
%
%   This will throw a warning if there is no build function
%   for the current toolchain

% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $
%   $Date: 2004/04/19 01:30:50 $
function build(obj,varargin)
    dispatch(obj,'build',varargin{:});
