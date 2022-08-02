% C166BITFIELDDATA create data for C166 bitfield demo model

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.2.4.2 $
%   $Date: 2004/04/19 01:18:43 $
  
tempAlarmLatched = SimulinkC166.Signal;
tempAlarmLatched.RTWInfo.CustomAttributes.BitFieldName = 'alarms';

rpmAlarmLatched = SimulinkC166.Signal;
rpmAlarmLatched.RTWInfo.CustomAttributes.BitFieldName = 'alarms';

rpmCheckEnabled = SimulinkC166.Parameter;
rpmCheckEnabled.RTWInfo.CustomAttributes.BitFieldName = 'control';
rpmCheckEnabled.Value = boolean(1);

tempCheckEnabled = SimulinkC166.Parameter;
tempCheckEnabled.RTWInfo.CustomAttributes.BitFieldName = 'control';
tempCheckEnabled.Value = boolean(1);

tempLimit = uint16(500);

rpmLimit = uint16(500);