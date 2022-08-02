function [s, lbl] = c28xpwm_callback(action)
% C2812PWM_CALLBACK Mask Helper Function for the c2812 adc blocks.
%
% $RCSfile: c28xpwm_callback.m,v $
% $Revision: 1.1.6.3 $
% $Date: 2004/04/20 23:20:10 $
% Copyright 2003 The MathWorks, Inc.

if nargin==0, action = 'dynamic'; end
blk = gcbh;

unit1statusidx   = 5;
unit1sourceidx   = unit1statusidx + 1;
unit1valueidx    = unit1sourceidx + 1;
unit2statusidx   = unit1valueidx + 1;
unit2sourceidx   = unit2statusidx + 1;
unit2valueidx    = unit2sourceidx + 1;
unit3statusidx   = unit2valueidx + 1;
unit3sourceidx   = unit3statusidx + 1;
unit3valueidx    = unit3sourceidx + 1;
unit1logic1idx   = unit3valueidx + 1;
unit1logic2idx   = unit1logic1idx + 1;
unit2logic1idx   = unit1logic2idx + 1;
unit2logic2idx   = unit2logic1idx + 1;
unit3logic1idx   = unit2logic2idx + 1;
unit3logic2idx   = unit3logic1idx + 1;
unit1deadbandidx = unit3logic2idx + 1;
unit2deadbandidx = unit1deadbandidx + 1;
unit3deadbandidx = unit2deadbandidx + 1;
deadbandprescaleridx = unit3deadbandidx + 1;
deadbandperiodidx = deadbandprescaleridx + 1;
generateSOCidx = deadbandperiodidx + 1;
retvalue = 1;
%
unit1Status = get_param(blk,'unit1Status');
unit2Status = get_param(blk,'unit2Status');
unit3Status = get_param(blk,'unit3Status');

switch action
case 'portlabels' 
    ind = 1;
    labelstr = '';
    periodsourceviainport = strcmp(get_param(blk,'timerSource'),'Input port');  
    if periodsourceviainport, 
        labelstr = [labelstr 'port_label(''input'',' num2str(ind) ', ''T'');']; ind = ind + 1; 
    end;
    if strcmp(unit1Status,'on'),
       if strcmp(get_param(blk,'unit1Source'),'Input port'), 
           labelstr = [labelstr 'port_label(''input'',' num2str(ind) ', ''W1'');']; ind = ind + 1;            
       end;      
    end                  
    if strcmp(unit2Status,'on'),
       if strcmp(get_param(blk,'unit2Source'),'Input port'), 
           labelstr = [labelstr 'port_label(''input'',' num2str(ind) ', ''W2'');']; ind = ind + 1;   
       end;      
    end          
    if strcmp(unit3Status,'on'),
       if strcmp(get_param(blk,'unit3Source'),'Input port'), 
           labelstr = [labelstr 'port_label(''input'',' num2str(ind) ', ''W3'');']; ind = ind + 1;
       end;      
    end    
    str = 'disp(''\nC28x PWM\n'');';
    str = [labelstr str];
    w = warning; 
    warning('off');
    set_param(blk,'maskdisplay',str); 
    warning(w);
case 'dynamic' 
    mask_enables = get_param(blk,'MaskEnables');  
    mask_visibilities = get_param(blk,'MaskVisibilities'); 
    mask_visibilities{3} = 'on';
    periodsourceviainport = strcmp(get_param(blk,'timerSource'),'Input port');  
    if periodsourceviainport, 
        mask_visibilities{3} = 'off';      
    end;
    mask_enables {unit1sourceidx} = unit1Status;
    mask_enables {unit1valueidx} = unit1Status;
    mask_enables {unit1logic1idx} = unit1Status;
    mask_enables {unit1logic2idx} = unit1Status;
    if strcmp(unit1Status,'on'),
       if strcmp(get_param(blk,'unit1Source'),'Input port'), 
           mask_visibilities{unit1valueidx} = 'off';
       else
           mask_visibilities{unit1valueidx} = 'on';           
       end;      
    end  
    mask_enables {unit2sourceidx} = unit2Status;
    mask_enables {unit2valueidx} = unit2Status;
    mask_enables {unit2logic1idx} = unit2Status;
    mask_enables {unit2logic2idx} = unit2Status;
    if strcmp(unit2Status,'on'),
       if strcmp(get_param(blk,'unit2Source'),'Input port'), 
           mask_visibilities{unit2valueidx} = 'off'; 
       else
           mask_visibilities{unit2valueidx} = 'on'; 
       end;      
    end  
    mask_enables {unit3sourceidx} = unit3Status;
    mask_enables {unit3valueidx} = unit3Status;
    mask_enables {unit3logic1idx} = unit3Status;
    mask_enables {unit3logic2idx} = unit3Status;    
    if strcmp(unit3Status,'on'),
       if strcmp(get_param(blk,'unit3Source'),'Input port'), 
           mask_visibilities{unit3valueidx} = 'off'; 
       else
           mask_visibilities{unit3valueidx} = 'on';            
       end;      
    end    
    mask_enables {unit1deadbandidx} = unit1Status;
    mask_enables {unit2deadbandidx} = unit2Status;
    mask_enables {unit3deadbandidx} = unit3Status;
    u1 = logicalANDcheckboxes ({unit1Status, get_param(gcb,'enableDeadband1')});
    u2 = logicalANDcheckboxes ({unit2Status, get_param(gcb,'enableDeadband2')});
    u3 = logicalANDcheckboxes ({unit3Status, get_param(gcb,'enableDeadband3')});
    deadbandflag = logicalORcheckboxes ({u1, u2, u3});
    mask_enables {deadbandprescaleridx} = deadbandflag;
    mask_enables {deadbandperiodidx} = deadbandflag;
    set_param(blk,'MaskEnables', mask_enables);
    set_param(blk,'MaskVisibilities', mask_visibilities);
case 'modulechanged'  
    mask_prompts = get_param(gcb,'MaskPrompts');   
    if (get_param(gcb,'UseModule') == 'A');
        mask_prompts{unit1statusidx} = 'Enable PWM1/PWM2';
        mask_prompts{unit2statusidx} = 'Enable PWM3/PWM4';
        mask_prompts{unit3statusidx} = 'Enable PWM5/PWM6';
        mask_prompts{unit1logic1idx} = 'PWM1 control logic:';
        mask_prompts{unit1logic2idx} = 'PWM2 control logic:';
        mask_prompts{unit2logic1idx} = 'PWM3 control logic:';
        mask_prompts{unit2logic2idx} = 'PWM4 control logic:';
        mask_prompts{unit3logic1idx} = 'PWM5 control logic:';
        mask_prompts{unit3logic2idx} = 'PWM6 control logic:';       
        mask_prompts{unit1deadbandidx} = 'Use deadband for PWM1/PWM2';
        mask_prompts{unit2deadbandidx} = 'Use deadband for PWM3/PWM4';
        mask_prompts{unit3deadbandidx} = 'Use deadband for PWM5/PWM6';    
    else
        mask_prompts{unit1statusidx} = 'Enable PWM7/PWM8';
        mask_prompts{unit2statusidx} = 'Enable PWM9/PWM10';
        mask_prompts{unit3statusidx} = 'Enable PWM11/PWM12';
        mask_prompts{unit1logic1idx} = 'PWM7 control logic:';
        mask_prompts{unit1logic2idx} = 'PWM8 control logic:';
        mask_prompts{unit2logic1idx} = 'PWM9 control logic:';
        mask_prompts{unit2logic2idx} = 'PWM10 control logic:';
        mask_prompts{unit3logic1idx} = 'PWM11 control logic:';
        mask_prompts{unit3logic2idx} = 'PWM12 control logic:';
        mask_prompts{unit1deadbandidx} = 'Use deadband for PWM7/PWM8';
        mask_prompts{unit2deadbandidx} = 'Use deadband for PWM9/PWM10';
        mask_prompts{unit3deadbandidx} = 'Use deadband for PWM11/PWM12';          
    end     
    set_param(blk,'MaskPrompts', mask_prompts); 
end

return


% ------------------------------------------------------------
function ret = logicalORcheckboxes ( statusarray )

if isempty(strmatch('on',statusarray))
    ret = 'off';
else
    ret = 'on';
end


% ------------------------------------------------------------
function ret = logicalANDcheckboxes ( statusarray )

if isempty(strmatch('off',statusarray))
    ret = 'on';
else
    ret = 'off';
end

% [EOF] c28xpwm_callback.m
