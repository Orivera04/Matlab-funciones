%TRANSIENTDATA  Assign data to Simulink model ports
%
%   h = ParameterEstimator.TransientData('block')
%   h = ParameterEstimator.TransientData('block', data, time/Ts)
%   h = ParameterEstimator.TransientData('block', portnumber)
%   h = ParameterEstimator.TransientData('block', portnumber, data, time/Ts)
%
%   TRANSIENTDATA  Constructs a data object to represent time-series data
%   associated with a Simulink I/O port or signal.
%
%   BLOCK      is a Simulink block name or handle.
%   PORTNUMBER is the port number of the block whose signal is logged.

%  Author(s): Bora Eryilmaz
%  Revised:
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.1 $ $Date: 2004/04/19 01:33:18 $