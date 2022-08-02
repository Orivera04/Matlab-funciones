function retvalue = c28xgpio_callback(action)
% C28XGPIO_CALLBACK Mask Helper Function for the c28xgpio blocks.
%
% $RCSfile: c28xgpio_callback.m,v $
% $Revision: 1.1.6.1 $ 
% $Date: 2004/04/01 16:13:42 $
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
        case 'GPIOA'
             for i=1:16           
                 mask_visibilities {i+OFFSET} = 'on';
             end            
        case 'GPIOB'
             for i=1:16
                 mask_visibilities {i+OFFSET} = 'on';
             end           
        case 'GPIOD'
             for i=1:16
                 if(i==1)||(i==2)||(i==6)||(i==7)
                     mask_visibilities {i+OFFSET} = 'on';   
                 else
                     mask_visibilities {i+OFFSET} = 'off';
                     set_param(blk,['GPIO_Bit', num2str(i-1)],'off');                      
                 end
             end  
        case 'GPIOE'
             for i=1:16
                 if(i==1)||(i==2)||(i==3)
                     mask_visibilities {i+OFFSET} = 'on';      
                 else
                     mask_visibilities {i+OFFSET} = 'off';
                     set_param(blk,['GPIO_Bit', num2str(i-1)],'off')                       
                 end
             end              
         case 'GPIOF'
             for i=1:15
                 mask_visibilities {i+OFFSET} = 'on';
             end   
                 mask_visibilities {17} = 'off';             
             set_param(blk,'GPIO_Bit15','off')           
        case 'GPIOG'
             for i=1:16
                 if(i==5)||(i==6)
                     mask_visibilities {i+OFFSET} = 'on';      
                 else
                     mask_visibilities {i+OFFSET} = 'off';
                     set_param(blk,['GPIO_Bit', num2str(i-1)],'off')                       
                 end               
             end              
    end             
        
    set_param(blk,'MaskVisibilities', mask_visibilities);    

end

return

% [EOF] c28xgpio_callback.m.m
