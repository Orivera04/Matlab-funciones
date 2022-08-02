function out = precedit(in,pos,varargin)
%PRECEDIT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.4.2 $  $Date: 2004/02/09 06:55:06 $

% CGPRECLOOKUPFIX/PRECEDIT  invokes a GUI to edit properties of a CGPRECLOOKUPFIX object.
% Use varargin as in a set command to tailor the GUI to specific needs. Properties that may be 
% set are: 
%         RangeString - String to describ which range (e.g. input or output) is being edited
%                       If not explicitly set then string will just read 'Range:' otherwise
%                       it will read 'PROPERTY_VALUE Range:'.
% 


if nargin < 1, error('CGPRECLOOKUPFIX/PRECEDIT : Too few arguments for precedit'), end
if nargout ~= 1,  error('CGPRECLOOKUPFIX/PRECEDIT : Too few outputs for precedit'), end

rangestr = 'Range :'; % Set up rangestr here. if it gets altered so be it, 

if ~isempty(varargin)
    if (length(varargin)/2) ~= round(length(varargin)/2)
        error('CGPRECLOOKUPFIX/PRECEDIT : Wrong number of inputs')
    else
        for i = 1:2:length(varargin)
            property = varargin{i};
            property_value = varargin{i+1};
            if ~ischar(property)
                error('CGPRECLOOKUPFIX/PRECEDIT : Invalid Property')
            else
                switch lower(property)
                case 'rangestring'
                    if ~ischar(property_value)
                        error('CGPRECLOOKUPFIX/PRECEDIT : Invalid setting')
                    elseif ~isempty(property_value)
                        rangestr = [property_value,' ',rangestr];
                    end
                    % I was going to throw an error here, but since we are going to want to pass this 
                    % info onto another precedit if precision type gets changed, then we can't do that
                    % since what works in one precedit may not work in another, so we'll ignore it but 
                    % keep it around should it be needed.
                    %                otherwise 
                    %                    error('CGPRECLOOKUPFIX/PRECEDIT : Unknown property')
                end
            end
        end
    end
end

% check to see if this one is writable or not, and obtain precision object settings

editfig = figposition(in,pos);
ud = get(editfig,'userdata');
% set up a global variable should the cancel button be pushed
global CANCEL_FLAG PRECISION_TYPE
CANCEL_FLAG = 0;
PRECISION_TYPE = [];  

ud.radio(1) = xreguicontrol(editfig,...
    'style','radio',...
    'value',0,...
    'position',[220 200 160 15],...
    'string','BYTE',...
    'callback',@i_Radio);

ud.radio(2) = xreguicontrol(editfig,...
    'style','radio',...
    'value',0,...
    'position',[220 185 160 15],...
    'string','WORD',...
    'callback',@i_Radio);

ud.radio(3) = xreguicontrol(editfig,...
    'style','radio',...
    'value',0,...
    'position',[220 170 160 15],...
    'string','LONG',...
    'callback',@i_Radio);

ud.radio(4) = xreguicontrol(editfig,...
    'style','radio',...
    'value',0,...
    'position',[220 155 160 15],...
    'string','CUSTOM',...
    'callback',@i_Radio);

xreguicontrol(editfig,...
    'style','text',...
    'string','Number of Bits:',...
    'position',[220 125 120 20],...
    'horizontal','left');

ud.bits = xreguicontrol(editfig,...
    'style','edit',...
    'position',[340 125 40 20],...
    'horizontal','left',...
    'backgroundcolor',[1 1 1],...
    'callback',@i_Bits);



xreguicontrol(editfig,...
    'style','text',...
    'string','Fixed Point Position:',...
    'position',[220 95 120 20],...
    'horizontal','left');

ud.ptpos = xreguicontrol(editfig,...
    'style','edit',...
    'position',[340 95 40 20],...
    'horizontal','left',...
    'backgroundcolor',[1 1 1],...
    'callback',@i_Update);

ud.signed(1) = xreguicontrol(editfig,...
    'style','radio',...
    'string','Signed',...
    'position',[220 75 160 15],...
    'value',0,...
    'callback',@i_SignRadio);

ud.signed(2) = xreguicontrol(editfig,...
    'style','radio',...
    'string','Unsigned',...
    'position',[220 60 160 15],...
    'value',0,...
    'callback',@i_SignRadio);

ud.axes = axes('parent',editfig,...
    'units','pixels',...
    'position',[40 195 120 120]);

ud.line = [];

xreguicontrol(editfig,...
    'style','text',...
    'string','Physical Data :',...
    'position',[20 155 160 20],...
    'horizontal','left');

ud.TablePhysData = xreguicontrol(editfig,...
    'style','edit',...
    'horizontal','left',...
    'position',[20 135 160 20],...
    'background',[1 1 1],...
    'callback',@i_Update);

xreguicontrol(editfig,...
    'style','text',...
    'string','Hardware Data :',...
    'position',[20 110 160 20],...
    'horizontal','left');

ud.TableHWData = xreguicontrol(editfig,...
    'style','edit',...
    'horizontal','left',...
    'position',[20 90 160 20],...
    'background',[1 1 1],...
    'callback',@i_Update);

xreguicontrol(editfig,...
    'style','text',...
    'string',rangestr,...
    'position',[20 65 100 20],...
    'horizontal','left');

ud.rangemin = xreguicontrol(editfig,...
    'style','edit',...
    'backgroundcolor',[1 1 1],...
    'position',[20 45 40 20],...
    'horizontal','left',...
    'callback',@i_Update);

xreguicontrol(editfig,...
    'style','text',...
    'position',[85 45 30 20],...
    'string','to',...
    'horizontal','center');

ud.rangemax = xreguicontrol(editfig,...
    'style','edit',...
    'backgroundcolor',[1 1 1],...
    'position',[140 45 40 20],...
    'horizontal','left',...
    'callback',@i_Update);
ud.obj = in;
ud.writeEnableControls = [ud.radio,ud.bits,ud.ptpos,ud.signed,ud.TablePhysData,ud.TableHWData,ud.rangemin,ud.rangemax];
set(editfig,'user',ud);
i_Refresh;
go = 0;

while ~go
    uiwait(editfig);
    % From here on the OK button should have been pressed, we collect the data, if any of it is silly, then we return to the top
    % otherwise we continue and exit.
    go = i_Update;
end
ud = get(editfig,'userdata');
if isempty(PRECISION_TYPE)
    if CANCEL_FLAG
        out = [];
    else
        out = ud.obj;
    end
    delete(editfig);
else % They've chosen to alter the type, so we need to pass along the arguments, check to see if we have any.
    pos = get(editfig,'position');
    delete(editfig);
    if isempty(varargin)
        out = precedit(PRECISION_TYPE,pos); 
    else
        out = precedit(PRECISION_TYPE,pos,varargin{:});
    end
end

clear global CANCEL_FLAG;
clear global PRECISION_TYPE;

% -------------------------------------------------------------
function i_Refresh(src,obj)
% -------------------------------------------------------------
fig = findall(0,'tag','TableProperties');
ud = get(fig,'user');
Phys = get(ud.obj,'TablePhysData');
HW = get(ud.obj,'TableHWData');
TablePhysData = num2str(Phys);
TableHWData = num2str(HW);
R = get(ud.obj,'physrange');
rmin = num2str(R(1));
rmax = num2str(R(2));
signed = get(ud.obj,'signed');
ptpos = num2str(get(ud.obj,'ptpos'));
bits = get(ud.obj,'bits');
set(ud.bits,'string',num2str(bits));
set(ud.radio,'value',0);
switch bits
case 8
    set(ud.radio(1),'value',1);
case 16
    set(ud.radio(2),'value',1);
case 32
    set(ud.radio(3),'value',1);
otherwise
    set(ud.radio(4),'value',1);
end
set(ud.signed,'value',0);
if signed
    set(ud.signed(1),'value',1);
else
    set(ud.signed(2),'value',1);
end
set(ud.ptpos,'string',ptpos);
set(ud.TablePhysData,'string',TablePhysData);
set(ud.TableHWData,'string',TableHWData);
set(ud.rangemin,'string',rmin);
set(ud.rangemax,'string',rmax);

% plot graph of object's effect
wrnstate = warning;
warning('off');
delete(ud.line); ud.line = [];
physdata = linspace(Phys(1),Phys(2),50);
newphysdata = resolve(ud.obj,physdata);
ud.line = line(physdata,newphysdata,'parent',ud.axes);
ud.line(2) = line(Phys,HW,'parent',ud.axes,'color',[0 1 0]);
set(gcf,'user',ud);
warning(wrnstate);
% -------------------------------------------------------------
function OK = i_Update(src,obj)
% -------------------------------------------------------------
OK = 1;
global PRECISION_TYPE CANCEL_FLAG
fig = findall(0,'tag','TableProperties');
ud = get(fig,'user');
if isempty(PRECISION_TYPE) & ~CANCEL_FLAG
    TablePhysData = str2num(get(ud.TablePhysData,'string'));
    TableHWData = str2num(get(ud.TableHWData,'string'));
    rmin = str2num(get(ud.rangemin,'string'));
    rmax = str2num(get(ud.rangemax,'string'));
    writable = get(ud.writable,'value');
    bits = str2num(get(ud.bits,'string'));
    if get(ud.signed(1),'value') == 1
        signed = 1;
    else
        signed = 0;
    end
    ptpos = str2num(get(ud.ptpos,'string'));
    if isempty(TablePhysData) | ~isnumeric(TablePhysData)
        msgbox('Please enter a vector for the Physical Data','Table Properties','modal');
        OK = 0;
    end
    if isempty(bits) | round(bits) ~= bits
        msgbox('Please enter an integer for the number of bits.','Table Properties','modal');
        OK = 0;
    end
    if isempty(ptpos) | round(ptpos) ~= ptpos
        msgbox('Please enter a integer for the fixed point position.','Table Properties','modal');
        OK = 0;
    end
    if isempty(TableHWData) | ~isnumeric(TableHWData)
        msgbox('Please enter a vector for the Hardware Data','Table Properties','modal');
        OK = 0;
    end
    if length(TableHWData) ~= length(TablePhysData)
        msgbox('The Physical Data and Hardware Data vectors must be the same length','Table Properties','modal');
        OK = 0;
    end
    if isempty(rmin) 
        msgbox('Please enter a number for the range minimum','Table Properties','modal');
        OK = 0;
    end
    if isempty(rmax) | ~isnumeric(rmax)
        msgbox('Please enter a number for the range maximum','Table Properties','modal');
        OK = 0;
    end
    if rmin > rmax
        msgbox('Please make sure range is increasing','Table Properties','modal');
        OK = 0;
    end 
    % | min(TablePhysData) < rmin | max(TablePhysData) > rmax
    if any(diff(sign(diff(TablePhysData)))) | any(diff(sign(diff(TableHWData))))
        msgbox('These values result in a multiple valued mapping','Table Properties','modal');
        OK = 0;
    end    
    if OK
        ud.obj = set(ud.obj,'bits',bits);
        ud.obj = set(ud.obj,'signed',signed);
        ud.obj = set(ud.obj,'TablePhysData',TablePhysData);
        ud.obj = set(ud.obj,'TableHWData',TableHWData);
        ud.obj = set(ud.obj,'physrange',[rmin rmax]);
        ud.obj = set(ud.obj,'writable',writable);
        ud.obj = set(ud.obj,'ptpos',ptpos);
        set(fig,'userdata',ud);
        i_Refresh;
    end
end

% ------------------------------------------------------
function i_Radio(src,obj)
% ------------------------------------------------------
fig = findall(0,'tag','TableProperties');
ud = get(fig,'user');
index = find(ud.radio == src);
set(ud.radio,'value',0);
set(src,'value',1);
switch(index)
case 1
    set(ud.bits,'string',num2str(8)); 
case 2
    set(ud.bits,'string',num2str(16));
case 3
    set(ud.bits,'string',num2str(32));
case 4
    set(ud.bits,'string','');
end
i_Update;

% ------------------------------------------------------
function i_SignRadio(src,obj)
% ------------------------------------------------------
fig = findall(0,'tag','TableProperties');
ud = get(fig,'user');
set(ud.signed,'value',0);
set(src,'value',1);
i_Update;

% ------------------------------------------------------
function i_Bits(src,obj)
% ------------------------------------------------------
fig = findall(0,'tag','TableProperties');
ud = get(fig,'user');
bits = str2num(get(ud.bits,'string'));
if isnumeric(bits) & bits > 0 & bits < 33
    ud.obj = set(ud.obj,'bits',bits);
    set(fig,'userdata',ud);
else
    set(ud.bits,'string',num2str(get(ud.obj,'bits')));
end
i_Refresh;

