% HC12FUELSYSDATA create data for HC12 fuelsys demo model

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.4.6.2 $
%   $Date: 2004/02/11 19:36:52 $

% Define Simulink data object for as a bitfield. 

[hc12_base_st] = hc12_closest_st(0.001024,16000000);

throt_fail = Simulink.CustomSignal;
throt_fail.RTWInfo.StorageClass = 'Custom';
throt_fail.RTWInfo.CustomStorageClass = 'BitField';
throt_fail.RTWInfo.CustomAttributes.BitFieldName = 'fail_state';

speed_fail = Simulink.CustomSignal;
speed_fail.RTWInfo.StorageClass = 'Custom';
speed_fail.RTWInfo.CustomStorageClass = 'BitField';
speed_fail.RTWInfo.CustomAttributes.BitFieldName = 'fail_state';

o2_fail = Simulink.CustomSignal;
o2_fail.RTWInfo.StorageClass = 'Custom';
o2_fail.RTWInfo.CustomStorageClass = 'BitField';
o2_fail.RTWInfo.CustomAttributes.BitFieldName = 'fail_state';

press_fail = Simulink.CustomSignal;
press_fail.RTWInfo.StorageClass = 'Custom';
press_fail.RTWInfo.CustomStorageClass = 'BitField';
press_fail.RTWInfo.CustomAttributes.BitFieldName = 'fail_state';