function varargout = mask_can_callback(block,callback,float_flag)
%MASK_CAN_CALLBACK
%      Parameter processing function for the block CAN CALLBACK. Generates function
%      prototype and function registration code snippets to be placed in the 
%      specialized blocks which are under the mask
%
%   Parameters
%
%      block        -     The block instigating the callback
%      module       -     A number representing the CAN module
%      callback     -     A number representing the source of the callback
%      float_flag   -     1 == Uses Floating Point | 2 == Does not use floating point
% 
%  Returns
%
%      f_proto         -     The function prototype for the generated code
%      dispstr         -     A string to display on the block
%      reg_callback    -     The piece of C code to execute to register the function
%      callback_enable -     The piece of C code to enable the callback routine

%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.8.4.1 $
%   $Date: 2004/04/19 01:29:40 $

x_callback = { 'EXT_IRQ0','INT_LEVEL0','EXT_IRQ1','INT_LEVEL1','EXT_IRQ2', ...
        'INT_LEVEL2','EXT_IRQ3','INT_LEVEL3','EXT_IRQ4','INT_LEVEL4','EXT_IRQ5', ...
        'INT_LEVEL5','EXT_IRQ6','INT_LEVEL6','EXT_IRQ7','INT_LEVEL7','INT_LEVEL8', ...
        'INT_LEVEL9','INT_LEVEL10','INT_LEVEL11','INT_LEVEL12','INT_LEVEL13','INT_LEVEL14',...
        'INT_LEVEL15','INT_LEVEL16','INT_LEVEL17','INT_LEVEL18','INT_LEVEL19','INT_LEVEL20',...
        'INT_LEVEL21','INT_LEVEL22','INT_LEVEL23','INT_LEVEL24','INT_LEVEL25','INT_LEVEL26',...
        'INT_LEVEL27','INT_LEVEL28','INT_LEVEL29','INT_LEVEL30','INT_LEVEL31' };


x_callback=x_callback{callback};

f_name  = [ 'isr_callback_' x_callback ];
f_proto = [ 'void  ' f_name '(MPC555_IRQ_LEVEL module)'];

switch float_flag
case 2
    reg_callback = ... 
        [ 'registerIRQ_Handler( ' x_callback ', ' f_name ',  NULL , FLOAT_NOT_USED_IN_ISR );'];
    float_str = 'No Floating Point';
case 1
     reg_callback = ... 
        [ 'registerIRQ_Handler( ' x_callback ', ' f_name ',  NULL , FLOAT_USED_IN_ISR );'];
    float_str = 'Floating Point';
otherwise
    error([num2str(float_flag) ' is an invalid option for float_flag.']);
end

dispstr = sprintf( 'ISR for %s\n\n%s' , x_callback,float_str);





varargout = { f_proto,dispstr,reg_callback };

