function [D,vars]= simvars(D)
%% DYNAMIC/SIMVARS     [D,vars]= simvars(D)
%% interrogates the simulink model for those variables
%% that are required (by SIM) from the workspace
%% returns D with D.simVars set to match its simulink model
%% vars = {'var1', 'var2'} is a cell array of var name strings 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:06 $

vars = feval(name(D),D,'simvars');

if isempty(vars)
   if isa(D,'dynamic') & exist(name(D))==4
      load_system(name(D));
      str= find_system(name(D));
      vars={};
      for i=1:length(str)
         try
            tmp=get_param(str{i},'MaskValueString');
            if ~isempty(tmp)
               tmp=list2cell(tmp);
               vars= {vars{:} tmp{:}};
            end %% if string empty
         end %% try
      end %% for loop on all subsystem names
      close_system(name(D));
   end
end

%% set field in object to match the simulink model
D.simVars=vars;

%% ============= NOTE =====================
%% Simulink model's variables that are defined by the 
%% variable names returned above can be found using
%% get_param(str{i},'MaskVariables')
%% returns a string  'gainVal=@1;ConstVal=@2;'
%% in the order found on the Initialization tab
