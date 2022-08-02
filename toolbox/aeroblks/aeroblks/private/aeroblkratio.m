function varargout = aeroblkratio(action)
%  AEROBLKRATIO - Aerospace Blockset relative ratio 
%  block helper function for mask parameters.

% Copyright 1990-2003 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/06 01:04:11 $

if nargin == 0, 
    action = 'dynamic'; 
end

blk = gcb;

switch action
 case 'icon'
  set_conversion_factor(blk);
  ports = set_ports(blk); 
  varargout = {ports};
  
 case {'theta','sq_theta','delta','sigma'}
  limit_num_ports(blk,action); 
  
 case 'dynamic'
 otherwise
  error('aeroblks:aeroblkratio:invalidiconaction','Icon action not defined');
end
return

% ----------------------------------------------------------
function limit_num_ports(blk,str)

theta_switch    = strcmp(get_param(blk,'theta'),'on');
sq_theta_switch = strcmp(get_param(blk,'sq_theta'),'on');
delta_switch    = strcmp(get_param(blk,'delta'),'on');
sigma_switch    = strcmp(get_param(blk,'sigma'),'on');    

%
% can't have zero ports
%
if ~(theta_switch || sq_theta_switch || delta_switch || sigma_switch)
    if strcmp(str,'theta')
        set_param(blk,'theta','on')
    elseif strcmp(str,'sq_theta')
        set_param(blk,'sq_theta','on')
    elseif strcmp(str,'delta')
        set_param(blk,'delta','on')
    else 
        set_param(blk,'sigma','on')
    end
end
return
% ----------------------------------------------------------
function set_conversion_factor(blk)

umode = get_param(blk,'units');

pvalues = get_param([blk '/Pressure Conversion'],'MaskValues');
dvalues = get_param([blk '/Density Conversion'],'MaskValues');
tvalues = get_param([blk '/Temperature Conversion'],'MaskValues');

switch umode
 case 'Metric (MKS)'
  set_param([blk '/Pressure Conversion'],'MaskValues',[{'Pa'} {pvalues{2}} ]);
  set_param([blk '/Density Conversion'],'MaskValues',[{'kg/m^3'} {dvalues{2}} ]);
  set_param([blk '/Temperature Conversion'],'MaskValues',[{'K'} {tvalues{2}} ]);
 case 'English'
  set_param([blk '/Pressure Conversion'],'MaskValues',[{'psi'} {pvalues{2}} ]);
  set_param([blk '/Density Conversion'],'MaskValues',[{'slug/ft^3'} {dvalues{2}} ]);
  set_param([blk '/Temperature Conversion'],'MaskValues',[{'R'} {tvalues{2}} ]);
 otherwise
  error('aeroblks:aeroblkratio:invalidunits','Unit conversion type not specified');
end

return

% ----------------------------------------------------------
function ports = set_ports(blk)

ports = struct('type',{'','','','','','','','',''},'port',{1},'txt',{''});

umode = get_param(blk,'units');

switch umode
 case 'Metric (MKS)'
  Tstr = 'T_o (K)';
  Pstr = 'P_o (Pa)';
  Rstr = '\rho_o (kg/m^3)';
 case 'English'
  Tstr = 'T_o (R)';
  Pstr = 'P_o (psi)';
  Rstr = '\rho_o (slug/ft^3)';
 otherwise
  error('aeroblks:aeroblkratio:invalidunits','Unit conversion type not specified');
end

theta_switch    = strcmp(get_param(blk,'theta'),'on');
sq_theta_switch = strcmp(get_param(blk,'sq_theta'),'on');
delta_switch    = strcmp(get_param(blk,'delta'),'on');
sigma_switch    = strcmp(get_param(blk,'sigma'),'on');        

ThBlk   = [blk '/theta'];
SThBlk  = [blk '/sqrt(theta)'];
DBlk    = [blk '/delta'];
SBlk    = [blk '/sigma'];

TempBlk = [blk '/Tstatic'];
PresBlk = [blk '/Pstatic'];
DensBlk = [blk '/rho_static'];

ports(1).type='input';
ports(1).port=1;
ports(1).txt='Mach';

ports(2).type='input';
ports(2).port=2;
ports(2).txt='\gamma';

[ports(3:5).type]=deal('input');
[ports(6:9).type]=deal('output');

if sigma_switch 
   % Change terminal to sigma port
   addport(SBlk,'Outport',num2str(theta_switch+sq_theta_switch+delta_switch+sigma_switch));
   % Change ground to density inport
   addport(DensBlk,'Inport',num2str((theta_switch|sq_theta_switch)+delta_switch+sigma_switch+2));
   if delta_switch 
      % Change terminal to delta outport
      addport(DBlk,'Outport',num2str(theta_switch+sq_theta_switch+delta_switch));
      % Change ground to pressure inport
      addport(PresBlk,'Inport',num2str((theta_switch|sq_theta_switch)+delta_switch+2));
      if sq_theta_switch 
         % Change terminal to sqrt_theta outport
         addport(SThBlk,'Outport',num2str(theta_switch+sq_theta_switch));
         % Change ground to temperature inport
         addport(TempBlk,'Inport','3');
         if theta_switch 
            % Change terminal to theta outport
            addport(ThBlk,'Outport','1');
            
            ports(3).port=3;
            ports(3).txt=Tstr;
            
            ports(4).port=4;
            ports(4).txt=Pstr;
            
            ports(5).port=5;
            ports(5).txt=Rstr;
            
            ports(6).port=1;
            ports(6).txt='\theta';
            
            ports(7).port=2;
            ports(7).txt='sqrt(\theta)';
            
            ports(8).port=3;
            ports(8).txt='\delta';
            
            ports(9).port=4;
            ports(9).txt='\sigma';
         else
            ports(3).port=3;
            ports(3).txt=Tstr;
            
            ports(4).port=4;
            ports(4).txt=Pstr;
            
            ports(5).port=5;
            ports(5).txt=Rstr;
            
            ports(6).port=1;
            ports(6).txt='sqrt(\theta)';
            
            ports(7).port=2;
            ports(7).txt='\delta';
            
            ports(8).port=3;
            ports(8).txt='\sigma';
            
            ports(9).port=1;
            ports(9).txt='';
            
            % Change theta outport to terminal
            addstub(ThBlk,'Terminator');
         end
      else
         if theta_switch 
            % Change terminal to theta outport
            addport(ThBlk,'Outport','1');
            % Change ground to temperature inport
            addport(TempBlk,'Inport','3');
            
            ports(3).port=3;
            ports(3).txt=Tstr;
            
            ports(4).port=4;
            ports(4).txt=Pstr;
            
            ports(5).port=5;
            ports(5).txt=Rstr;
            
            ports(6).port=1;
            ports(6).txt='\theta';
            
            ports(7).port=2;
            ports(7).txt='\delta';
            
            ports(8).port=3;
            ports(8).txt='\sigma';
            
            ports(9).port=1;
            ports(9).txt='';
         else
            ports(3).port=3;
            ports(3).txt=Pstr;
            
            ports(4).port=4;
            ports(4).txt=Rstr;
            
            ports(6).port=1;
            ports(6).txt='\delta';
            
            ports(7).port=2;
            ports(7).txt='\sigma';
            
            [ports([5,8,9]).port]=deal(1);
            [ports([5,8,9]).txt]=deal('');
            
            % Change theta outport to terminal
            addstub(ThBlk,'Terminator');
            % Change temperature inport to ground 
            addstub(TempBlk,'Ground');
         end
            % Change sqrt_theta outport to terminal
            addstub(SThBlk,'Terminator');
      end
   else
      if sq_theta_switch 
         % Change terminal to sqrt_theta outport
         addport(SThBlk,'Outport',num2str(theta_switch+sq_theta_switch));
         % Change ground to temperature inport
         addport(TempBlk,'Inport','3');
         if theta_switch 
            % Change terminal to theta outport
            addport(ThBlk,'Outport','1');
            
            ports(3).port=3;
            ports(3).txt=Tstr;
            
            ports(4).port=4;
            ports(4).txt=Rstr;
            
            ports(6).port=1;
            ports(6).txt='\theta';
            
            ports(7).port=2;
            ports(7).txt='sq(\theta)';
            
            ports(8).port=3;
            ports(8).txt='\sigma';
            
            [ports([5,9]).port]=deal(1);
            [ports([5,9]).txt]=deal('');
            
         else
            ports(3).port=3;
            ports(3).txt=Tstr;
            
            ports(4).port=4;
            ports(4).txt=Rstr;
            
            ports(6).port=1;
            ports(6).txt='sq(\theta)';
            
            ports(7).port=2;
            ports(7).txt='\sigma';
            
            [ports([5,8,9]).port]=deal(1);
            [ports([5,8,9]).txt]=deal('');
            
            % Change theta outport to terminal
            addstub(ThBlk,'Terminator');
         end
      else
         if theta_switch 
            % Change terminal to theta outport
            addport(ThBlk,'Outport','1');
            % Change ground to temperature inport
            addport(TempBlk,'Inport','3');
            
            ports(3).port=3;
            ports(3).txt=Tstr;
            
            ports(4).port=4;
            ports(4).txt=Rstr;
            
            ports(6).port=1;
            ports(6).txt='\theta';
            
            ports(7).port=2;
            ports(7).txt='\sigma';
            
            [ports([5,8,9]).port]=deal(1);
            [ports([5,8,9]).txt]=deal('');
            
         else
            ports(3).port=3;
            ports(3).txt=Rstr;
            
            ports(6).port=1;
            ports(6).txt='\sigma';
            
            [ports([4,5,7:9]).port]=deal(1);
            [ports([4,5,7:9]).txt]=deal('');
            
            % Change theta outport to terminal
            addstub(ThBlk,'Terminator');   
            % Change temperature inport to ground 
            addstub(TempBlk,'Ground');
         end
         % Change sqrt_theta outport to terminal
         addstub(SThBlk,'Terminator');   
      end
      % Change delta outport to terminal
      addstub(DBlk,'Terminator');   
      % Change pressure inport to ground
      addstub(PresBlk,'Ground');
   end %end delta_switch
else
   if delta_switch 
      % Change terminal to delta outport
      addport(DBlk,'Outport',num2str(theta_switch+sq_theta_switch+delta_switch));
      % Change ground to pressure inport
      addport(PresBlk,'Inport',num2str((theta_switch|sq_theta_switch)+delta_switch+2));
      if sq_theta_switch 
         % Change terminal to sqrt_theta outport
         addport(SThBlk,'Outport',num2str(theta_switch+sq_theta_switch));
         % Change ground to temperature inport
         addport(TempBlk,'Inport','3');
         if theta_switch 
            % Change terminal to theta outport
            addport(ThBlk,'Outport','1');
            
            ports(3).port=3;
            ports(3).txt=Tstr;
            
            ports(4).port=4;
            ports(4).txt=Pstr;
            
            ports(6).port=1;
            ports(6).txt='\theta';
            
            ports(7).port=2;
            ports(7).txt='sqrt(\theta)';
            
            ports(8).port=3;
            ports(8).txt='\delta';
            
            [ports([5,9]).port]=deal(1);
            [ports([5,9]).txt]=deal('');
            
         else
            ports(3).port=3;
            ports(3).txt=Tstr;
            
            ports(4).port=4;
            ports(4).txt=Pstr;
            
            ports(6).port=1;
            ports(6).txt='sqrt(\theta)';
            
            ports(7).port=2;
            ports(7).txt='\delta';
            
            [ports([5,8,9]).port]=deal(1);
            [ports([5,8,9]).txt]=deal('');
            
            % Change theta outport to terminal
            addstub(ThBlk,'Terminator');
         end
      else
         if theta_switch 
            % Change terminal to theta outport
            addport(ThBlk,'Outport','1');
            % Change ground to temperature inport
            addport(TempBlk,'Inport','3');
            
            ports(3).port=3;
            ports(3).txt=Tstr;
            
            ports(4).port=4;
            ports(4).txt=Pstr;
            
            ports(6).port=1;
            ports(6).txt='\theta';
            
            ports(7).port=2;
            ports(7).txt='\delta';
            
            [ports([5,8,9]).port]=deal(1);
            [ports([5,8,9]).txt]=deal('');
         else
            ports(3).port=3;
            ports(3).txt=Pstr;
            
            ports(6).port=1;
            ports(6).txt='\delta';
            
            [ports([4,5,7:9]).port]=deal(1);
            [ports([4,5,7:9]).txt]=deal('');
            
            % Change theta outport to terminal
            addstub(ThBlk,'Terminator');
            % Change temperature inport to ground 
            addstub(TempBlk,'Ground');
         end
         % Change sqrt_theta outport to terminal
         addstub(SThBlk,'Terminator');
      end
   else
      if sq_theta_switch 
         % Change terminal to sqrt_theta outport
         addport(SThBlk,'Outport',num2str(theta_switch+sq_theta_switch));
         % Change ground to temperature inport
         addport(TempBlk,'Inport','3');
         if theta_switch 
            % Change terminal to theta outport
            addport(ThBlk,'Outport','1');
            ports(3).port=3;
            ports(3).txt=Tstr;
            
            ports(6).port=1;
            ports(6).txt='\theta';
            
            ports(7).port=2;
            ports(7).txt='sqrt(\theta)';
            
            [ports([4,5,8,9]).port]=deal(1);
            [ports([4,5,8,9]).txt]=deal('');
         else
            ports(3).port=3;
            ports(3).txt=Tstr;
            
            ports(6).port=1;
            ports(6).txt='sqrt(\theta)';
            
            [ports([4,5,7:9]).port]=deal(1);
            [ports([4,5,7:9]).txt]=deal('');
            
            % Change theta outport to terminal
            addstub(ThBlk,'Terminator');
         end
      else
         if theta_switch 
            % Change terminal to theta outport
            addport(ThBlk,'Outport','1');
            % Change ground to temperature inport
            addport(TempBlk,'Inport','3');
            
            ports(3).port=3;
            ports(3).txt=Tstr;
            
            ports(6).port=1;
            ports(6).txt='\theta';
            
            [ports([4,5,7:9]).port]=deal(1);
            [ports([4,5,7:9]).txt]=deal('');
         end
         % Change sqrt_theta outport to terminal
         addstub(SThBlk,'Terminator');
      end
      % Change delta outport to terminal
      addstub(DBlk,'Terminator');
      % Change pressure inport to ground
      addstub(PresBlk,'Ground');
      
   end %end delta_switch
   
   % Change sigma outport to terminal
   addstub(SBlk,'Terminator');
   % Change density inport to ground
   addstub(DensBlk,'Ground');
   
end %end signa_switch

return
