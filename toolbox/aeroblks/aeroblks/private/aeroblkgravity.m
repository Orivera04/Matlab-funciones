function varargout = aeroblkgravity(action)
%  AEROBLKGRAVITY - Aerospace Blockset gravity model block 
%  helper function for mask parameters.

% Copyright 1990-2003 The MathWorks, Inc.
% $Revision: 1.4.2.7 $ $Date: 2004/01/08 03:05:56 $

if nargin == 0, 
    action = 'dynamic'; 
end

blk = gcb;

switch action
case 'icon'
   str = get_model(blk);
   set_conversion_factor(blk);
   ports = get_labels(blk);
   varargout = {str,ports};
   
case 'dynamic'
   mask_visibility = get_param(blk,'maskvisibilities');  % remove non-options
   mask_enable = get_param(blk,'maskenables');  % grey out non-options
   
   % Determine which gravity model is being used
   gmode = get_param(blk,'model');
   
   if strcmp(gmode,'WGS84 Taylor Series'),
       [mask_visibility{3:8}]=deal('off');
   else % if (strcmp(gmode,'WGS84 Close Approximation') | strcmp(gmode,'WGS84 Exact')),
       [mask_visibility{3:8}]=deal('on');

       % Determine determine if model has precession
       ptype = get_param(blk,'precessing');

       if strcmp(ptype,'on')
           [mask_enable{5:7}]=deal('on');
       else
           [mask_enable{5:7}]=deal('off');
       end
       
       month_selected = get_param(blk,'month');
       year_selected = str2num(get_param(blk,'year'));
       day_selected = str2num(get_param(blk,'day'));
       
       if (day_selected < 1)
           set_param(blk,'day','1');
           warning('aeroblks:aeroblkgravity:invaliddate',...
                   'Day must be at least 1');
       end
       
       switch month_selected
           case {'January','March','May','July','August','October','December'}
               if (day_selected > 31)
                   set_param(blk,'day','31');
                   warning('aeroblks:aeroblkgravity:invaliddate',...
                           'Day must be no more than 31');
               end
           case 'February'
               % Check for leap year
               if (mod(year_selected,400)&&~mod(year_selected,100))
                   % leapyear = false;
                   if (day_selected > 28)
                       set_param(blk,'day','28');
                       warning('aeroblks:aeroblkgravity:invaliddate',...
                               'Day must be no more than 28');
                   end
               elseif ~mod(year_selected,4)
                   % leapyear = true;
                   if (day_selected > 29)
                       set_param(blk,'day','29');
                       warning('aeroblks:aeroblkgravity:invaliddate',...
                               'Day must be no more than 29');
                   end
               else 
                   % leapyear = false;
                   if (day_selected > 28)
                       set_param(blk,'day','28');
                        warning('aeroblks:aeroblkgravity:invaliddate',...
                               'Day must be no more than 28');
                  end
               end
           case {'April','June','September','November'}
               if (day_selected > 30)
                   set_param(blk,'day','30');
                   warning('aeroblks:aeroblkgravity:invaliddate',...
                           'Day must be no more than 30');
               end
           otherwise
               error('aeroblks:aeroblkgravity:invalidmonth','Month not defined');
       end    
   end

   set_param(blk,'maskvisibilities',mask_visibility);
   set_param(blk,'maskenables',mask_enable);
 
otherwise
   error('aeroblks:aeroblkgravity:invalidiconaction','Icon action not defined');
end
return

% ----------------------------------------------------------
function wtxt = get_model(blk)
 
gtype = get_param(blk,'model');
atype = get_param(blk,'no_atmos');

if strcmp(atype,'on')
    atmos_str = '    Exclude Atmosphere    ';
else
    atmos_str = '';
end

switch gtype,
case 'WGS84 Taylor Series',
    s = {sprintf(['           WGS84          ' '\n'...
                  '      (Taylor Series)     '])};
      
case  {'WGS84 Close Approximation', 'WGS84 Exact'}
    ptype = get_param(blk,'precessing');
    ctype = get_param(blk,'no_centrifugal');
    
    if strcmp(ctype,'on')
        centrif_str = '  No Centrifugal Effects  ';
    else
        centrif_str = '';
    end
    if strcmp(ptype,'on')
        precess_str = '   Precessing Ref. Frame  ';
    else
        precess_str = '';
    end
    if strcmp(gtype,'WGS84 Close Approximation')
        type_str = '   (Close Approximation)  ';
    else
        type_str = '          (Exact)         ';
    end
    
    s = {sprintf(['           WGS84          ' '\n' ...
                  type_str '\n' atmos_str '\n' precess_str ...
                  '\n' centrif_str ])};
otherwise
   error('aeroblks:aeroblkgravity:invalidmodel','Method not defined');
end

wtxt=s{1};
return

% ----------------------------------------------------------
function ports = get_labels(blk)

ports = struct('type',{'','','',''},'port',{1},'txt',{''});

gmode = get_param(blk,'model');
umode = get_param(blk,'units');

% Input port labels:
ports(1).type='input';
ports(1).port=1;

ports(2).type='input';
ports(2).port=2;
ports(2).txt='Lat (deg)';

ports(3).type='input';
ports(3).txt='';

switch gmode
case 'WGS84 Taylor Series'
   % Label all ports:
   ports(3).port=2;
   
   if strcmp(get_param(blk,'blocktype'),'SubSystem')
       addstub([blk '/longitude'],'Ground');
   end    
   
case {'WGS84 Close Approximation', 'WGS84 Exact'}
    
   if strcmp(get_param(blk,'blocktype'),'SubSystem')
       addport([blk '/longitude'],'Inport','3');
   end    

   % Label all ports:
   ports(3).port=3;
   ports(3).txt='Lon (deg)';
 
otherwise
   error('aeroblks:aeroblkgravity:invalidmodel','Method not defined');   
end
% Output port labels:

ports(4).type='output';
ports(4).port=1;

switch umode
case {'Metric','Metric (MKS)'}
   ports(1).txt='h (m)';
   ports(4).txt='g (m/s^2)';
   
case 'English'
   ports(1).txt='h (ft)';
   ports(4).txt='g (ft/s^2)';
 
otherwise
   error('aeroblks:aeroblkgravity:invalidunits','Unit conversion not defined');
end

return
% ----------------------------------------------------------
function set_conversion_factor(blk)

if strcmp(get_param(blk,'blocktype'),'SubSystem')
    umode = get_param(blk,'units');
    
    switch umode
        case 'Metric (MKS)'
            
            set_conversions(blk,'m','m/s^2');
            
        case 'English'
            
            set_conversions(blk,'ft','ft/s^2');
            
        otherwise
            error('aeroblks:aeroblkgravity:invalidunits','Unit conversion not defined');
    end
end
return
% ----------------------------------------------------------
function set_conversions(blk,length_in,accel_out)

l_blk    = [blk '/Length Conversion'];
a_blk    = [blk '/Acceleration Conversion'];

lmask = get_param(l_blk,'MaskValues');
convert = ~strcmp(lmask{1},length_in);

if convert
    set_param(l_blk,'MaskValues',[{length_in} {'m'}]);
    set_param(a_blk,'MaskValues',[{'m/s^2'} {accel_out}]);
end

return
% ----------------------------------------------------------







