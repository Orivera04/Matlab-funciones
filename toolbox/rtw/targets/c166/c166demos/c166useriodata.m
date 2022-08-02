% C166USERIODATA create data for C166 user i/o demo model

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.2 $
%   $Date: 2002/10/09 11:14:05 $

output_led_D3 = SimulinkC166.Signal;
output_led_D3.RTWInfo.CustomAttributes.BitFieldName = 'dig_outputs';

output_dig1 = SimulinkC166.Signal;
output_dig1.RTWInfo.CustomAttributes.BitFieldName = 'dig_outputs';

