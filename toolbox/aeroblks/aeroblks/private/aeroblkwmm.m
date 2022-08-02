function varargout = aeroblkwmm(action)
%  AEROBLKWMM - Aerospace Blockset world magnetic model 
%  block helper function for mask parameters.

% Copyright 1990-2003 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/06 01:04:16 $

if nargin == 0, 
    action = 'dynamic'; 
end

blk = gcb;

switch action
    case 'icon'
        ports = get_labels(blk);
        set_conversion_factor(blk);
        set_out_of_range(blk);
        dyear = get_decimal_year(blk);
        varargout = {ports,dyear};
        
    case 'dynamic'
        mask_enable = get_param(blk,'maskenables');  % grey out non-options
        
        % Determine determine if model has external sources
        month_selected = get_param(blk,'month');
        year_selected = str2num(get_param(blk,'year'));
        tmode = get_param(blk,'time_in');
        day_selected = str2num(get_param(blk,'day'));
        
        switch month_selected
            case {'January','March','May','July','August','October','December'}
                % do nothing
            case 'February'
                % Check for leap year
                if (mod(year_selected,400)&&~mod(year_selected,100))
                    % leapyear = false;
                elseif ~mod(year_selected,4)
                    % leapyear = true;
                    if (day_selected > 29)
                        set_param(blk,'day','29');
                    end
                else 
                    % leapyear = false;
                    if (day_selected > 28)
                        set_param(blk,'day','28');
                    end
                end
            case {'April','June','September','November'}
                if (day_selected > 30)
                    set_param(blk,'day','30');
                end
            otherwise
                error('aeroblks:aeroblkwmm:invalidmonth','Month not defined');
        end
        
        if strcmp(tmode,'on')
            [mask_enable{3:5}]=deal('off');
        else
            [mask_enable{3:5}]=deal('on');            
        end
        
        set_param(blk,'maskenables',mask_enable);
        
    otherwise
        error('aeroblks:aeroblkwmm:invalidiconaction','Icon action not defined');
end
return

% ----------------------------------------------------------
function ports = get_labels(blk)

umode = get_param(blk,'units');
tmode = get_param(blk,'time_in');
TBlk  = [blk '/Decimal Year'];

% Input port labels:
ports(1).type='input';
ports(1).port=1;

ports(2).type='input';
ports(2).port=2;
ports(2).txt='Latitude (deg)';

ports(3).type='input';
ports(3).port=3;
ports(3).txt='Longitude (deg)';

ports(4).type='input';
if strcmp(tmode,'on')
    % Change Constant to Port
    addport(TBlk,'Inport','4')
    ports(4).port=4;
    ports(4).txt='Decimal Year';
else
    ports(4).port=1;
    ports(4).txt='';
    
    % Change Port to Constant
    if strcmp(get_param(TBlk,'blocktype'),'Inport')
        pos = get_param(TBlk,'Position');
        delete_block(TBlk);
        add_block('built-in/Constant',TBlk,'Position',pos,'Value','dyear','showname','on','OutDataTypeMode','Inherit via back propagation');
    end
end

% Output port labels:
[ports(5:9).type]=deal('output');
[ports(5:9).port]=deal(1);
[ports(6:9).txt]=deal('');

% Determine determine if model has additional outputs
Hout = get_param(blk,'h_out');
DECout = get_param(blk,'dec_out');
DIPout = get_param(blk,'inc_out');
TIout = get_param(blk,'ti_out');

HBlk   = [blk '/horizontal intensity'];
DECBlk  = [blk '/declination'];
DIPBlk    = [blk '/inclination'];
TIBlk    = [blk '/total intensity'];

HportIsPresent = strcmp(get_param(HBlk,'BlockType'),'Outport');
DECportIsPresent = strcmp(get_param(DECBlk,'BlockType'),'Outport');
DIPportIsPresent = strcmp(get_param(DIPBlk,'BlockType'),'Outport');
TIportIsPresent = strcmp(get_param(TIBlk,'BlockType'),'Outport');

if strcmp(Hout,'off')
    if strcmp(DECout,'off')
        if strcmp(DIPout,'off')
            if strcmp(TIout,'off')
                [ports(6:9).port]=deal(1);
                [ports(6:9).txt]=deal('');
                % Change Port to Terminator
                addstub(TIBlk,'Terminator')
            else
                % Change Terminator to Port
                addport(TIBlk,'Outport','2')
                ports(6).port=2;
                ports(6).txt='Total Intensity';
                [ports(7:9).port]=deal(1);
                [ports(7:9).txt]=deal('');
            end
            % Change Port to Terminator
            addstub(DIPBlk,'Terminator')
        else  % DIP outport
            % Change Terminator to Port
            addport(DIPBlk,'Outport','2')
            ports(6).port=2;
            ports(6).txt='Inclination (deg)';
            
            if strcmp(TIout,'off')
                [ports(7:9).port]=deal(1);
                [ports(7:9).txt]=deal('');
                % Change Port to Terminator
                addstub(TIBlk,'Terminator')
            else
                % Change Terminator to Port
                addport(TIBlk,'Outport','3')
                ports(7).port=3;
                ports(7).txt='Total Intensity';
                [ports(8:9).port]=deal(1);
                [ports(8:9).txt]=deal('');
            end          
        end
        % Change Port to Terminator
        addstub(DECBlk,'Terminator')
    else % DEC outport
        % Change Terminator to Port
        addport(DECBlk,'Outport','2')
        ports(6).port=2;
        ports(6).txt='Declination (deg)';
        if strcmp(DIPout,'off')
            if strcmp(TIout,'off')
                [ports(7:9).port]=deal(1);
                [ports(7:9).txt]=deal('');
                % Change Port to Terminator
                addstub(TIBlk,'Terminator')
            else
                % Change Terminator to Port
                addport(TIBlk,'Outport','3')
                ports(7).port=3;
                ports(7).txt='Total Intensity';
                [ports(8:9).port]=deal(1);
                [ports(8:9).txt]=deal('');
            end
            % Change Port to Terminator
            addstub(DIPBlk,'Terminator')
        else % DIP outport
            % Change Terminator to Port
            addport(DIPBlk,'Outport','3')
            ports(7).port=3;
            ports(7).txt='Inclination (deg)';
            
            if strcmp(TIout,'off')
                [ports(8:9).port]=deal(1);
                [ports(8:9).txt]=deal('');
                % Change Port to Terminator
                addstub(TIBlk,'Terminator')
            else
                % Change Terminator to Port
                addport(TIBlk,'Outport','4')
                ports(8).port=4;
                ports(8).txt='Total Intensity';
                ports(9).port=1;
                ports(9).txt='';
            end          
        end
    end
    % Change Port to Terminator
    addstub(HBlk,'Terminator')
else
    % Change Terminator to Port
    addport(HBlk,'Outport','2')
    ports(6).port=2;
    ports(6).txt='Horizontal Intensity';
    if strcmp(DECout,'off')
        if strcmp(DIPout,'off')
            if strcmp(TIout,'off')
                [ports(7:9).port]=deal(1);
                [ports(7:9).txt]=deal('');
                % Change Port to Terminator
                addstub(TIBlk,'Terminator')
            else
                % Change Terminator to Port
                addport(TIBlk,'Outport','3')
                ports(7).port=3;
                ports(7).txt='Total Intensity';
                [ports(8:9).port]=deal(1);
                [ports(8:9).txt]=deal('');
            end
            % Change Port to Terminator
            addstub(DIPBlk,'Terminator')
        else  % DIP outport
            % Change Terminator to Port
            addport(DIPBlk,'Outport','3')
            ports(7).port=3;
            ports(7).txt='Inclination (deg)';
            
            if strcmp(TIout,'off')
                [ports(8:9).port]=deal(1);
                [ports(8:9).txt]=deal('');
                % Change Port to Terminator
                addstub(TIBlk,'Terminator')
            else
                % Change Terminator to Port
                addport(TIBlk,'Outport','4')
                ports(8).port=4;
                ports(8).txt='Total Intensity';
                ports(9).port=1;
                ports(9).txt='';
            end          
        end
        % Change Port to Terminator
        addstub(DECBlk,'Terminator')
    else % DEC outport
        % Change Terminator to Port
        addport(DECBlk,'Outport','3')
        ports(7).port=3;
        ports(7).txt='Declination (deg)';
        if strcmp(DIPout,'off')
            if strcmp(TIout,'off')
                [ports(8:9).port]=deal(1);
                [ports(8:9).txt]=deal('');
                % Change Port to Terminator
                addstub(TIBlk,'Terminator')
            else
                % Change Terminator to Port
                addport(TIBlk,'Outport','4')
                ports(8).port=4;
                ports(8).txt='Total Intensity';
                ports(9).port=1;
                ports(9).txt='';
            end
            % Change Port to Terminator
            addstub(DIPBlk,'Terminator')
        else % DIP outport
            % Change Terminator to Port
            addport(DIPBlk,'Outport','4')
            ports(8).port=4;
            ports(8).txt='Inclination (deg)';
            
            if strcmp(TIout,'off')
                ports(9).port=1;
                ports(9).txt='';
                % Change Port to Terminator
                addstub(TIBlk,'Terminator')
            else
                % Change Terminator to Port
                addport(TIBlk,'Outport','5')
                ports(9).port=5;
                ports(9).txt='Total Intensity';
            end          
        end
    end
end

switch umode
    case 'Metric (MKS)'
        ports(1).txt='Height (m)';
        ports(5).txt='Magnetic Field (nT)';
        if strcmp(ports(6).txt,'Horizontal Intensity')
            ports(6).txt='Horizonal Intensity (nT)';
        end
        for i=6:9
            if strcmp(ports(i).txt,'Total Intensity')
                ports(i).txt='Total Intensity (nT)';
            end
        end
        
    case 'English'
        ports(1).txt='Height (ft)';
        ports(5).txt='Magnetic Field (nGauss)';
        if strcmp(ports(6).txt,'Horizontal Intensity')
            ports(6).txt='Horizonal Intensity (nGauss)';
        end
        for i=6:9
            if strcmp(ports(i).txt,'Total Intensity')
                ports(i).txt='Total Intensity (nGauss)';
            end
        end
        
    otherwise
        error('aeroblks:aeroblkwmm:invalidunits','Unit conversion not defined');
end

return

% ----------------------------------------------------------
function set_conversion_factor(blk)

umode = get_param(blk,'units');

lvalues = get_param([blk '/Length Conversion'],'MaskValues');

switch umode
    case 'Metric (MKS)'
        set_param([blk '/Length Conversion'],'MaskValues',[{'m'} {lvalues{2}}]);
        set_param([blk '/Power Conversion'],'Gain','1.0');
        set_param([blk '/Power Conversion1'],'Gain','1.0');
        set_param([blk '/Power Conversion2'],'Gain','1.0');
    case 'English'
        set_param([blk '/Length Conversion'],'MaskValues',[{'ft'} {lvalues{2}}]);
        set_param([blk '/Power Conversion'],'Gain','10000.0');
        set_param([blk '/Power Conversion1'],'Gain','10000.0');
        set_param([blk '/Power Conversion2'],'Gain','10000.0');
    otherwise
        error('aeroblks:aeroblkwmm:invalidunits','Unit conversion not defined');
end

return
% ----------------------------------------------------------
function set_out_of_range(blk)

amode = get_param(blk,'action');
lonblk = [blk '/Check Longitude'];
latblk = [blk '/Check Latitude'];
altblk = [blk '/Check Altitude'];
timeblk = [blk '/geomg1/Is time within model limits'];

lonMaskVals = get_param(lonblk,'MaskValues');
latMaskVals = get_param(latblk,'MaskValues');
altMaskVals = get_param(altblk,'MaskValues');
timeMaskVals = get_param(timeblk,'MaskValues');

switch amode
    case 'None'
        set_param(lonblk,'MaskValues',{lonMaskVals{1:4} 'off' lonMaskVals{6} 'off' lonMaskVals{8:end}}');
        set_param(latblk,'MaskValues',{latMaskVals{1:4} 'off' latMaskVals{6} 'off' latMaskVals{8:end}}');
        set_param(altblk,'MaskValues',{altMaskVals{1:4} 'off' altMaskVals{6} 'off' altMaskVals{8:end}}');
        set_param(timeblk,'MaskValues',{timeMaskVals{1:4} 'off' timeMaskVals{6} 'off' timeMaskVals{8:end}}');
    case 'Warning'
        set_param(lonblk,'MaskValues',{lonMaskVals{1:4} 'on' lonMaskVals{6} 'off' lonMaskVals{8:end}}');
        set_param(latblk,'MaskValues',{latMaskVals{1:4} 'on' latMaskVals{6} 'off' latMaskVals{8:end}}');
        set_param(altblk,'MaskValues',{altMaskVals{1:4} 'on' altMaskVals{6} 'off' altMaskVals{8:end}}');
        set_param(timeblk,'MaskValues',{timeMaskVals{1:4} 'on' timeMaskVals{6} 'off' timeMaskVals{8:end}}');
    case 'Error'
        set_param(lonblk,'MaskValues',{lonMaskVals{1:4} 'on' lonMaskVals{6} 'on' lonMaskVals{8:end}}');
        set_param(latblk,'MaskValues',{latMaskVals{1:4} 'on' latMaskVals{6} 'on' latMaskVals{8:end}}');
        set_param(altblk,'MaskValues',{altMaskVals{1:4} 'on' altMaskVals{6} 'on' altMaskVals{8:end}}');
        set_param(timeblk,'MaskValues',{timeMaskVals{1:4} 'on' timeMaskVals{6} 'on' timeMaskVals{8:end}}');
    otherwise
        error('aeroblks:aeroblkwmm:invalidaction','Out of Range method not defined');
end

return
%-------------------------------------------------------------------------
function dyear = get_decimal_year(blk)

year = get_param(blk,'year');
year_selected = str2num(year);
month = get_param(blk,'month');

if (mod(year_selected,400)&&~mod(year_selected,100))
    % leapyear = false;
    ndays = 365;
elseif ~mod(year_selected,4)
    % leapyear = true;
    ndays = 366;
else 
    % leapyear = false;
    ndays = 365;
end

day = get_param(blk,'day');

day_of_year = datenum([day '-' month '-' year])-datenum(['1-january-' year]);
dyear = year_selected + day_of_year/ndays;

return
