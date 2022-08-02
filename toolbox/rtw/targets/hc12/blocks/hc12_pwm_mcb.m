function hc12_pwm_mcb(PWMChannelChoice)
    %
    % HC12 PWM Output Mask Initialization callback.
    %   supports channels 0 thru 8
    %
    % $Revision: 1.1.6.2 $  $Date: 2004/04/19 01:23:20 $
    % Copyright 2002-2003 The MathWorks, Inc.

    % Create resource keyword to be reserved in resource database
    PWMDTYbyteStr    = strcat('PWMDTY',PWMChannelChoice);

    % Try reserving one of 'PWMDUTY0', ..., 'PWMDTY8' for this block instance
    % If the resource is not available, it will error out immediately.
    reservationmanager('pwm', {PWMDTYbyteStr} );
  
    % Store Mask strings propagates symbols directly to the 
    % .rtw file in the form of block.RTWdata record.
    %
    % Insert modelRTWFields in the I/O block's S-Function
    % containing the Tag 'HC12DriverData'
    modelRTWFields = struct( ...\
         'PWMDTYbyteStr',   PWMDTYbyteStr,                   ...\
         'PWMPOLbitStr', strcat('PPOL',   PWMChannelChoice), ...\      
         'PWMCLKbitStr', strcat('PCLK',   PWMChannelChoice), ...\    
         'PWMCAEbitStr', strcat('CAE',    PWMChannelChoice), ...\
         'PWMEbitStr',   strcat('PWME',   PWMChannelChoice), ...\
         'PWMPERbyteStr',strcat('PWMPER', PWMChannelChoice));
         
    % Data is then available in the .rtw file in the form:
    %     
    %     %<block.RTWdata.PWMDTYbyteStr>
    %     %<block.RTWdata.PWMPOLbitStr>
    %     %<block.RTWdata.PWMCLKbitStr>
    %     %<block.RTWdata.PWMCAEbitStr>
    %     %<block.RTWdata.PWMEbitStr>
    %     %<block.RTWdata.PWMPERbyteStr>
    hc12_setsfunrtwdata(modelRTWFields);
