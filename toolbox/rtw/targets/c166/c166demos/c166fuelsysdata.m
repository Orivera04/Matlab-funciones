% C166FUELSYSDATA create data for C166 fuelsys demo model

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $
%   $Date: 2002/10/29 07:46:30 $

% Define Simulink data object that instruct the code generation process
% to use C166 bit-addressable memory.

throt_fail = SimulinkC166.Signal;
throt_fail.RTWInfo.CustomAttributes.BitFieldName = 'fail_state';

speed_fail = SimulinkC166.Signal;
speed_fail.RTWInfo.CustomAttributes.BitFieldName = 'fail_state';

o2_fail = SimulinkC166.Signal;
o2_fail.RTWInfo.CustomAttributes.BitFieldName = 'fail_state';

press_fail = SimulinkC166.Signal;
press_fail.RTWInfo.CustomAttributes.BitFieldName = 'fail_state';
