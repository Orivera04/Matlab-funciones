%% File : run(this, modelName )
%%
%% Abstract : 
%%  Run the executable associated with the current build
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
% $Revision: 1.1 $ 
% $Date: 2002/10/23 01:49:43 $
function test(obj,varargin)
    % Return the toolchain specific object
    dispatch(obj,'test',varargin{:});
