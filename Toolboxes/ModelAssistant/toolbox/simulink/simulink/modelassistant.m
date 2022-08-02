function modelassistant(system)
% MODELASSISTANT Using the Model Assistant Tool, you can quickly
% configure a model for code generation, and identify aspects of your
% model that impede Real-Time Workshop Embedded Coder deployment or limit 
% generated code efficiency.
%
% There are four components of the Model Assistant Tool:
%
% 1.  General Code Generation Goals
% 2.  Detailed Code Generation Goals
% 3.  Model Advisor
% 4.  Search and Modify
%
% Usage:  Run the Model Assistant on a desired model or subsystem.
%
% >> modelassistant('model')        % Entire model
% >> modelassistant('model/system') % Specific system
% >> modelassistant(gcb)            % Selected (subsystem) block
%
% >> modelassistant('help')         % Launch help page for Model Assistnat Tool
%
 
%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:12 $

cmdPath = [matlabroot filesep 'toolbox' filesep 'simulink' filesep 'simulink' filesep 'ModelAssistant'];
helpfile = [cmdPath filesep 'ModelAssistantTool.html'];

if nargin == 0
   help modelassistant
   return
end

if strcmpi(system,'help')
    helpview(helpfile);
else
    disp('Type modelassistant(''help'') for Model Assistant Help Page.');
    addpath(cmdPath);
    open_system(system);
    ModelAdvisor(system);
end
