% File : get_current_toolchain
%
% Abstract :
%   Will return either
%
%           CodeWarrior
%     or    Diab
%

% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.2.4.1 $
%   $Date: 2004/04/19 01:30:55 $

function toolchain = get_current_toolchain
    toolchain = get_debugger_toolchain;
    