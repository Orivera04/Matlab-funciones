function retvalue = c24xgpio_callback(action)
% C24XGPIO_CALLBACK Mask Helper Function for the c24xgpio blocks.
%
% $RCSfile: c24xgpio_callback.m,v $
% $Revision: 1.1.6.1 $ 
% $Date: 2004/04/01 16:13:39 $
% Copyright 2004 The MathWorks, Inc.

if nargin==0, action = 'dynamic'; end
blk = gcbh;

OFFSET = 1;
retvalue = 1;

switch action
case 'dynamic'
    
    mask_visibilities_orig  = get_param(blk,'MaskVisibilities');
    mask_visibilities  = mask_visibilities_orig;
    moduleUsed = get_param(blk,'useIOPort');
    
    switch moduleUsed
        case 'IOPA'
             for i=1:8
                 mask_visibilities {i+OFFSET} = 'on';
             end             
        case 'IOPB'
             for i=1:8
                 mask_visibilities {i+OFFSET} = 'on';
             end                
        case 'IOPC'
             for i=1:8
                 mask_visibilities {i+OFFSET} = 'on';
             end             
        case 'IOPD'
             for i=1:8
                 mask_visibilities {i+OFFSET} = 'on';
             end    
        case 'IOPE'
             for i=1:8
                 mask_visibilities {i+OFFSET} = 'on';
             end             
        case 'IOPF'
             for i=1:7
                 mask_visibilities {i+OFFSET} = 'on';
             end              
             set_param(blk,'GPIO_Bit7','off');                  
             mask_visibilities {8+OFFSET} = 'off';             
     end             
        
    set_param(blk,'MaskVisibilities', mask_visibilities);    
  
end

return

% [EOF] c24xgpio_callback.m
