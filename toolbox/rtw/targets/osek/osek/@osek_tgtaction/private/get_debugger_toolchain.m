% File : get_current_toolchain
%
% Abstract :
%   Will return either
%
%           CodeWarrior
%     or    Diab
%

% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $
%   $Date: 2004/04/19 01:30:56 $

function toolchain = get_debugger_toolchain
    prefs = osek.prefs.load('osek.prefs');
    toolchain = lower(prefs.ToolChain.Debugger);
    toolchain = ['osek_' toolchain];