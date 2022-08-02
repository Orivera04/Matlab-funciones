%% File : run(this, modelName )
%%
%% Abstract : 
%%  Kill the execution associated with the current build
%%  of the current model or the model argument.
%%
%% Arguments :
%%  this        -   osek_tgtaction object
%%  modelName   -   Optional argument
%%                  The name of the model to execute on target.
%%                  Defaults to the current model if no argument
%%                  is passed.
%%
%%

% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $
%   $Date: 2004/04/19 01:30:52 $
function kill(obj,varargin)
    dispatch(obj,'kill',varargin{:});
