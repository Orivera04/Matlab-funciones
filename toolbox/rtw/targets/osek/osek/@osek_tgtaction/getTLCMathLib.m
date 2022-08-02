%% File : getTLCMathLib
%%
%% Abstract :
%%  Return the full path to the TLC file implementing the
%%  target specific math library functions.
%%

%% $Revision: 1.1 $
%% $Date: 2002/10/09 16:18:21 $
%%
%% Copyright 2002 The MathWorks, Inc.
function tlc_path = getTLCMathLib(obj)
    tlc_path = dispatch(obj,'getTLCMathLib');

