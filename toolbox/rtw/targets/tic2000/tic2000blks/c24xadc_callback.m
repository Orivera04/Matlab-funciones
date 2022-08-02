function retvalue = c24xadc_callback(action)
% C2812ADC_CALLBACK Mask Helper Function for the c2812 adc blocks.
%
% $RCSfile: c24xadc_callback.m,v $
% $Revision: 1.1.6.2 $
% $Date: 2004/04/08 20:58:43 $
% Copyright 2003-2004 The MathWorks, Inc.

if nargin==0, action = 'dynamic'; end
blk = gcbh;

OFFSET = 1;
retvalue = 1;

switch action
case 'dynamic'
    
    mask_visibilities_orig  = get_param(blk,'MaskVisibilities');
    mask_visibilities  = mask_visibilities_orig;  
    
    moduleUsed         = get_param(blk,'useModule');
    
    if (strcmp(moduleUsed,'A') || strcmp(moduleUsed,'A and B')), visModA = 'on'; else, visModA = 'off'; end;
    if (strcmp(moduleUsed,'B') || strcmp(moduleUsed,'A and B')), visModB = 'on'; else, visModB = 'off'; end;
    
    for i=1:8
        mask_visibilities {i+OFFSET} = visModA;
    end
    for i=9:16
        mask_visibilities {i+OFFSET} = visModB;
    end
        
    set_param(blk,'MaskVisibilities', mask_visibilities);    
  
end

return

% [EOF] c24xadc_callback.m.m
