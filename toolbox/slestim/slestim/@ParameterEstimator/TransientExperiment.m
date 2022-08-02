%TRANSIENTEXPERIMENT  Create dataset for transient experiment
%
%   TRANSIENTEXPERIMENT Constructs an object to represent the experimental I/O
%   data and the known initial states of a Simulink model to be used for
%   parameter estimation.
%
%   h = ParameterEstimator.TransientExperiment('model')
%   h = ParameterEstimator.TransientExperiment('model', hIn, hOut, hIc)
%
%   MODEL is a Simulink model name or handle.

%  Author(s): Bora Eryilmaz
%  Revised:
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.1 $ $Date: 2004/04/19 01:33:19 $