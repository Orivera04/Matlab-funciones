% Simulink Parameter Estimation 
% Version 1.0 (R14) 05-May-2004 
%
% Adaptive Lookup Table libraries v1.0
%   spelib     - Open Simulink Parameter Estimation library
%   spelookup  - Adaptive Lookup Tables (stair fit)
%
% Graphical User Interface
%   spetool - Open the Simulink Parameter Estimation GUI for a Simulink 
%             model
%
% Input and Output Data Sets
%   ParameterEstimator/TransientData - Assign data to Simulink model ports
%   ParameterEstimator/StateData     - Define known states of dynamic 
%                                      Simulink blocks
%
% Experimental Data
%   ParameterEstimator/TransientExperiment - Create dataset for transient 
%                                            experiment
%
% Model States and Parameters
%   ParameterEstimator/State     - Define estimated states of dynamic 
%                                  Simulink blocks
%   ParameterEstimator/Parameter - Define estimated parameters of Simulink
%                                  model
%
% Parameter estimation.
%   ParameterEstimator/Estimation - Create estimation object for given 
%                                   Simulink model
%   ParameterEstimator/estimate   - Perform parameter estimation
%   ParameterEstimator/findpar    - Find specifications for given estimated
%                                   parameter
%   ParameterEstimator/initpar    - Initialize estimated parameters
%   ParameterEstimator/simset     - Modify simulation settings
%   ParameterEstimator/simget     - Retrieve current simulation settings
%   ParameterEstimator/optimset   - Modify optimizer settings
%   ParameterEstimator/optimget   - Retrieve current optimizer settings
%
% Helper functions
%   ParameterEstimator/hiliteBlock - Highlight block associated with an 
%                                    object
%   ParameterEstimator/update      - Update content of object after 
%                                    changing Simulink model
%   ParameterEstimator/select      - Extract subset of data from Simulink
%                                    block
%   ParameterEstimator/copy        - Create copy of object
%
% Demos
%  Type "demo" or "help slestdemos" for a list of available demos.

% Copyright 2002-2004 The MathWorks, Inc.
% Generated from Contents.m_template revision 1.1.6.4 $Date: 2004/04/19 01:33:35 $
