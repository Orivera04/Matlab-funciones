function [vars,vals]= simconstants(D)
%% DYNAMIC/SIMCONSTANTS     [D,vars]= simconstants(D)
%% interrogates the simulink model for those variables
%% that are required (by SIM) from the workspace
%% returns D with D.simVars set to match its simulink model
%% vars = {'var1', 'var2'} is a cell array of var name strings 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:05 $

[vars,vals]= feval(name(D),D,'simconstants');
