% Script to setup Simulink data objects used by ASAP2 / CCP

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2004/04/19 01:26:25 $
 
% canlib.Signal for DAQ List Signal Monitoring
COUNTER_SIGNAL = canlib.Signal;
COUNTER_SIGNAL.Description = 'Count in seconds';
COUNTER_SIGNAL.DocUnits = 'seconds';
COUNTER_SIGNAL.Min = 0;
COUNTER_SIGNAL.Max = 10000;
 
% Simulink.Parameter for Parameter Tuning
STEP_PARAM = Simulink.Parameter;
STEP_PARAM.Description = 'Tunable Step Parameter';
STEP_PARAM.DocUnits = 'No units.';
STEP_PARAM.Min = 0;
STEP_PARAM.Max = 20;
STEP_PARAM.Value = single(1);
STEP_PARAM.RTWInfo.StorageClass = 'ExportedGlobal';
 
% canlib.Signal for DAQ List Signal Monitoring
SINE_SIGNAL = canlib.Signal;
SINE_SIGNAL.Description = 'Sine Wave Signal';
SINE_SIGNAL.DocUnits = 'sine units';
SINE_SIGNAL.Min = -130;
SINE_SIGNAL.Max = 130;
 
% canlib.Signal for DAQ List Signal Monitoring
PULSE_SIGNAL = canlib.Signal;
PULSE_SIGNAL.Description = 'Step signal';
PULSE_SIGNAL.DocUnits = 'pulse units';
PULSE_SIGNAL.Min = 0;
PULSE_SIGNAL.Max = 65000;
 
% canlib.Signal for DAQ List Signal Monitoring
RANDOM1 = canlib.Signal;
RANDOM1.Description = '';
RANDOM1.DocUnits = 'no units';
RANDOM1.Min = 0;
RANDOM1.Max = 10;
 
% canlib.Signal for DAQ List Signal Monitoring
RANDOM2 = canlib.Signal;
RANDOM2.Description = '';
RANDOM2.DocUnits = 'no units';
RANDOM2.Min = 0;
RANDOM2.Max = 10;
 
% canlib.Signal for DAQ List Signal Monitoring
RANDOM3 = canlib.Signal;
RANDOM3.Description = '';
RANDOM3.DocUnits = 'no units';
RANDOM3.Min = 0;
RANDOM3.Max = 10;
 
% canlib.Signal for DAQ List Signal Monitoring
RANDOM4 = canlib.Signal;
RANDOM4.Description = '';
RANDOM4.DocUnits = 'no units';
RANDOM4.Min = 0;
RANDOM4.Max = 10;
 
% canlib.Signal for DAQ List Signal Monitoring
RANDOM5 = canlib.Signal;
RANDOM5.Description = '';
RANDOM5.DocUnits = 'no units';
RANDOM5.Min = 0;
RANDOM5.Max = 10;
 
% canlib.Signal for DAQ List Signal Monitoring
RANDOM6 = canlib.Signal;
RANDOM6.Description = '';
RANDOM6.DocUnits = 'no units';
RANDOM6.Min = 0;
RANDOM6.Max = 10;
 
% canlib.Signal for DAQ List Signal Monitoring
RANDOM7 = canlib.Signal;
RANDOM7.Description = '';
RANDOM7.DocUnits = 'no units';
RANDOM7.Min = 0;
RANDOM7.Max = 10;