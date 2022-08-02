function hc12_master_mcb(desiredST, osc)
    %
    % Based on the desiredST and clock oscillator,
    % determine CRG settings for RTR30 and RTR64. 
    % These are set via the Master block. 
    %
    % $Revision: 1.1.6.2 $  $Date: 2004/04/19 01:23:19 $
    % Copyright 2002-2003 The MathWorks, Inc.
    
    [best_ST,rtr30,rtr64,percentError] = hc12_closest_st(desiredST,osc);
    
    RTR = uint8(rtr64);         % Bits 4:6
    RTR = bitshift(rtr64,4);
    RTR = bitor(RTR,rtr30);     % Bits 0:3
    modelRTWFields = struct( ...\
         'RTR',num2str(double(RTR)) );     
         
    % Insert modelRTWFields in the I/O block's S-Function
    % containing the Tag 'HC12DriverData' which allows 
    % acces in TLC as follows:
    %
    %  <block.RTWdata.RTR>
    
    hc12_setsfunrtwdata(modelRTWFields);
