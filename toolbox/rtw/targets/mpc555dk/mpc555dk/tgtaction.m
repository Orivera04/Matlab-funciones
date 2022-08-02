%% File : tgtaction(action, varargin)
%%
%% Abstract :
%%  Affords some level of backwards compatability to
%%  the old test files that uses tgtaction directly.
%%  Use of this function should be deprecated. See
%%  mpc555_tgtaction for details on correct usage
%%
%%  Brad Phelan

% Copyright 2001-2002 The MathWorks, Inc.
% $Revision: 1.7.4.1 $ 
% $Date: 2004/04/19 01:27:15 $

function varargout = tgtaction(action,varargin)
    if nargout > 0
        varargout = { mpc555_tgtaction(action,varargin{:}) };
    else
        varargout = {};
        mpc555_tgtaction(action,varargin{:});
    end
    
    
