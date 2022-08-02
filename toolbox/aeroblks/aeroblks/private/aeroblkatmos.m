function varargout = aeroblkatmos(action)
%  AEROBLKNSDAY - Aerospace Blockset COESA and non-standard day block 
%  helper function for mask parameters.

% Copyright 1990-2003 The MathWorks, Inc.
% $Revision.1 $ $Date: 2004/04/06 01:04:06 $

if nargin == 0, 
    action = 'dynamic'; 
end

blk = gcb;

switch action
    case 'icon'
        ports = get_labels(blk);
        set_conversion_factor(blk);
        set_help(blk);
        set_up_mask(blk);
        varargout = {ports};

    case 'dynamic'
        set_up_mask(blk);
        set_help(blk);
        
        otherwise
            error('aeroblks:aeroblkatmos:invalidiconaction','action not defined');
end
return

% ----------------------------------------------------------
function ports = get_labels(blk)

ports = struct('type',{'','','','',''},'port',{1},'txt',{''});
  
umode = get_param(blk,'units');
smode = get_param(blk,'spec');
mmode = get_param(blk,'model');
evmode = get_param(blk,'envelope_var');
epmode = get_param(blk,'envelope_percent');

% Input port labels:
ports(1).type='input';
ports(1).port=1;

Temperature=(strcmp(evmode,'High temperature') || strcmp(evmode,'Low temperature'));
Density = (strcmp(evmode,'High density') || strcmp(evmode,'Low density'));
Percent = strcmp(epmode,'Extreme values')||strcmp(epmode,'1%');

heightstr = 'h ';
tempstr = 'T ';
sosstr = 'a ';
presstr = 'P ';
densstr = '\rho ';

PBlk = [blk '/Air Pressure'];
TBlk = [blk '/Temperature'];
SBlk = [blk '/Speed of Sound'];
RBlk = [blk '/Air Density'];

if (strcmp(mmode,'Envelope')&& ...
    ~(strcmp(smode,'1976 COESA-extended U.S. Standard Atmosphere')) && ...
    ~((Temperature||Density)&&Percent))
    % in an Envelope case for MIL-STD or MIL-HDBK
    [ports(2:5).type]=deal('output');
    [ports(2:5).port]=deal(1);
    [ports(3:5).txt]=deal('');
                       
    if (strcmp(evmode,'High pressure') || strcmp(evmode,'Low pressure'))
        switch umode
            case 'Metric (MKS)'
                ports(1).txt=[heightstr '(m)'];
                ports(2).txt=[presstr '(Pa)'];
                
            case {'English (Velocity in ft/s)','English (Velocity in kts)'}
                ports(1).txt=[heightstr '(ft)'];
                ports(2).txt=[presstr '(psi)'];
            otherwise
                error('aeroblks:aeroblkatmos:invalidunits','Unit conversion not defined');                
        end
        
        addport(PBlk,'Outport','1');
        addstub(RBlk,'Terminator');
        addstub(SBlk,'Terminator');
        addstub(TBlk,'Terminator');
        
    elseif ~(Percent)
        if (Temperature)
            switch umode
                case 'Metric (MKS)'
                    ports(1).txt=[heightstr '(m)'];
                    ports(2).txt=[tempstr '(K)'];
                    
                case {'English (Velocity in ft/s)','English (Velocity in kts)'}
                    ports(1).txt=[heightstr '(ft)'];
                    ports(2).txt=[tempstr '(R)'];
                otherwise
                    error('aeroblks:aeroblkatmos:invalidunits','Unit conversion not defined');
            end
       
        addport(TBlk,'Outport','1');
        addstub(RBlk,'Terminator');
        addstub(SBlk,'Terminator');
        addstub(PBlk,'Terminator');
            
        else % High Density or Low Density
            switch umode
                case 'Metric (MKS)'
                    ports(1).txt=[heightstr '(m)'];
                    ports(2).txt=[densstr '(kg/m^3)'];
                    
                case {'English (Velocity in ft/s)','English (Velocity in kts)'}
                    ports(1).txt=[heightstr '(ft)'];
                    ports(2).txt=[densstr '(slug/ft^3)'];
                otherwise
                    error('aeroblks:aeroblkatmos:invalidunits','Unit conversion not defined');        
            end
       
        addport(RBlk,'Outport','1');
        addstub(TBlk,'Terminator');
        addstub(SBlk,'Terminator');
        addstub(PBlk,'Terminator');
           
        end
    end
else
        addport(TBlk,'Outport','1');
        addport(SBlk,'Outport','2');
        addport(PBlk,'Outport','3');
        addport(RBlk,'Outport','4');
    
    % Output port labels:
    
    [ports(2:5).type]=deal('output');
    ports(2).port=1;
    ports(3).port=2;
    ports(4).port=3;
    ports(5).port=4;
    
    switch umode
        case 'Metric (MKS)'
            ports(1).txt=[heightstr '(m)'];
            ports(2).txt=[tempstr '(K)'];
            ports(3).txt=[sosstr '(m/s)'];
            ports(4).txt=[presstr '(Pa)'];
            ports(5).txt=[densstr '(kg/m^3)'];
            
        case 'English (Velocity in ft/s)'
            ports(1).txt=[heightstr '(ft)'];
            ports(2).txt=[tempstr '(R)'];
            ports(3).txt=[sosstr '(ft/s)'];
            ports(4).txt=[presstr '(psi)'];
            ports(5).txt=[densstr '(slug/ft^3)'];
            
        case 'English (Velocity in kts)'
            ports(1).txt=[heightstr '(ft)'];
            ports(2).txt=[tempstr '(R)'];
            ports(3).txt=[sosstr '(kts)'];
            ports(4).txt=[presstr '(psi)'];
            ports(5).txt=[densstr '(slug/ft^3)'];
        otherwise
            error('aeroblks:aeroblkatmos:invalidunits','Unit conversion not defined');

    end
end

return

% ----------------------------------------------------------
function set_conversion_factor(blk)

umode = get_param(blk,'units');

lvalues = get_param([blk '/Length Conversion'],'MaskValues');
tvalues = get_param([blk '/Temperature Conversion'],'MaskValues');
pvalues = get_param([blk '/Pressure Conversion'],'MaskValues');
vvalues = get_param([blk '/Velocity Conversion'],'MaskValues');
dvalues = get_param([blk '/Density Conversion'],'MaskValues');

switch umode
    case 'Metric (MKS)'
        set_param([blk '/Length Conversion'],'MaskValues',[{'m'} {lvalues{2}}]);
        set_param([blk '/Temperature Conversion'],'MaskValues',[{tvalues{1}} {'K'}]);
        set_param([blk '/Pressure Conversion'],'MaskValues',[{pvalues{1}} {'Pa'}]);
        set_param([blk '/Velocity Conversion'],'MaskValues',[{vvalues{1}} {'m/s'}]);
        set_param([blk '/Density Conversion'],'MaskValues',[{dvalues{1}} {'kg/m^3'}]);
        
    case 'English (Velocity in ft/s)'
        set_param([blk '/Length Conversion'],'MaskValues',[{'ft'} {lvalues{2}}]);
        set_param([blk '/Temperature Conversion'],'MaskValues',[{tvalues{1}} {'R'}]);
        set_param([blk '/Pressure Conversion'],'MaskValues',[{pvalues{1}} {'psi'}]);
        set_param([blk '/Density Conversion'],'MaskValues',[{dvalues{1}} {'slug/ft^3'}]);
        set_param([blk '/Velocity Conversion'],'MaskValues',[{vvalues{1}} {'ft/s'}]);
        
    case 'English (Velocity in kts)'
        set_param([blk '/Length Conversion'],'MaskValues',[{'ft'} {lvalues{2}}]);
        set_param([blk '/Temperature Conversion'],'MaskValues',[{tvalues{1}} {'R'}]);
        set_param([blk '/Pressure Conversion'],'MaskValues',[{pvalues{1}} {'psi'}]);
        set_param([blk '/Density Conversion'],'MaskValues',[{dvalues{1}} {'slug/ft^3'}]);
        set_param([blk '/Velocity Conversion'],'MaskValues',[{vvalues{1}} {'kts'}]);
    otherwise
        error('aeroblks:aeroblkatmos:invalidunits','Unit conversion not defined');
end

return

%-------------------------------------------------------------------------
function set_up_mask(blk)

mask_visibility = get_param(blk,'maskvisibilities');  % remove non-options
mask_enable = get_param(blk,'maskenables');  % grey out non-options

% Determine which atmosphere model is being used
dtype = get_param(blk,'spec');

switch dtype
    case '1976 COESA-extended U.S. Standard Atmosphere'
        if ~strcmp(mask_visibility(3),'off')
            [mask_visibility{3:8}]=deal('off');
        end
    case {'MIL-HDBK-310','MIL-STD-210C'}   
        mask_visibility{3}='on';
        % Determine which non-standard day model is being used
        mtype = get_param(blk,'model');
        
        switch mtype
            case 'Profile'
                [mask_visibility{4:6}]=deal('on');
                [mask_visibility{7:8}]=deal('off');
            case 'Envelope'
                [mask_visibility{4:6}]=deal('off');
                [mask_visibility{7:8}]=deal('on');
            otherwise
                error('aeroblks:aeroblkatmos:invalidmodel','model type not defined');
        end
    otherwise
        error('aeroblks:aeroblkatmos:invalidspec','specification type not defined');
end
set_param(blk,'maskvisibilities',mask_visibility);

set_param(blk,'maskenables',mask_enable);        

return
%-------------------------------------------------------------------------
function set_help(blk)

% Determine which atmosphere model is being used
dtype = get_param(blk,'spec');

coesastr  = 'web(asbhelp(''COESA Atmosphere Model''));';
mil310str = 'web(asbhelp(''Non-Standard Day 310''));';
mil210str = 'web(asbhelp(''Non-Standard Day 210C''));';

switch dtype
    case '1976 COESA-extended U.S. Standard Atmosphere'
        set_mask_help(blk,coesastr)
    case 'MIL-HDBK-310'
        set_mask_help(blk,mil310str)
    case 'MIL-STD-210C'   
        set_mask_help(blk,mil210str)
    otherwise
        error('aeroblks:aeroblkatmos:invalidspec','specification type not defined');                
end

return



