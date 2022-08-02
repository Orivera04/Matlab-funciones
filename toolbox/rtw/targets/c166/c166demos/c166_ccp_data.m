% Script to setup Simulink data objects used by ASAP2 / CCP

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2004/04/19 01:18:42 $
 
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
STEP_PARAM.Value = uint16(1);
STEP_PARAM.RTWInfo.StorageClass = 'ExportedGlobal';
 
% canlib.Signal for DAQ List Signal Monitoring
PULSE_SIGNAL = canlib.Signal;
PULSE_SIGNAL.Description = 'Step signal';
PULSE_SIGNAL.DocUnits = 'pulse units';
PULSE_SIGNAL.Min = 0;
PULSE_SIGNAL.Max = 65000;
 
% canlib.Signal for DAQ List Signal Monitoring
PULSE_PER_2 = canlib.Signal;
PULSE_PER_2.Description = '';
PULSE_PER_2.DocUnits = '';
PULSE_PER_2.Min = 0;
PULSE_PER_2.Max = 2;
 
% canlib.Signal for DAQ List Signal Monitoring
PULSE_PER_3 = canlib.Signal;
PULSE_PER_3.Description = '';
PULSE_PER_3.DocUnits = '';
PULSE_PER_3.Min = 0;
PULSE_PER_3.Max = 2;
 
% canlib.Signal for DAQ List Signal Monitoring
PULSE_PER_4 = canlib.Signal;
PULSE_PER_4.Description = '';
PULSE_PER_4.DocUnits = '';
PULSE_PER_4.Min = 0;
PULSE_PER_4.Max = 2;
 
% canlib.Signal for DAQ List Signal Monitoring
PULSE_PER_5 = canlib.Signal;
PULSE_PER_5.Description = '';
PULSE_PER_5.DocUnits = '';
PULSE_PER_5.Min = 0;
PULSE_PER_5.Max = 2;
 
% canlib.Signal for DAQ List Signal Monitoring
PULSE_PER_6 = canlib.Signal;
PULSE_PER_6.Description = '';
PULSE_PER_6.DocUnits = '';
PULSE_PER_6.Min = 0;
PULSE_PER_6.Max = 2;
 
% canlib.Signal for DAQ List Signal Monitoring
PULSE_PER_7 = canlib.Signal;
PULSE_PER_7.Description = '';
PULSE_PER_7.DocUnits = '';
PULSE_PER_7.Min = 0;
PULSE_PER_7.Max = 2;
 
% canlib.Signal for DAQ List Signal Monitoring
PULSE_PER_8 = canlib.Signal;
PULSE_PER_8.Description = '';
PULSE_PER_8.DocUnits = '';
PULSE_PER_8.Min = 0;
PULSE_PER_8.Max = 2;