%% File : osek_tgtaction(action, varargin)
%%
%% Abstract :
%%  Affords M-file function level access to 
%%  tgtaction('<action>') style invocation directly.
%%
%%  See mpc555_tgtaction for details on correct usage
%%
%%  Brad Phelan

% Copyright 2002 The MathWorks, Inc.
% $Revision: 1.2 $ 
% $Date: 2002/10/25 15:41:21 $

function varargout = osektgtaction(action,varargin)
    if nargout > 0
        varargout = { osek_tgtaction(action,varargin{:}) };
    else
        osek_tgtaction(action,varargin{:});
    end
    
    
