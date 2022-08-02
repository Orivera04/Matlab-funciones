function out = precedit(in,pos,varargin)
%PRECEDIT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 06:54:58 $

% CGPRECFLOAT/PRECEDIT  invokes a GUI to edit properties of a CGPRECFLOAT object.
% Use varargin as in a set command to tailor the GUI to specific needs. Properties that may be 
% set are: 
%         RangeString - String to describ which range (e.g. input or output) is being edited
%                       If not explicitly set then string will just read 'Range:' otherwise
%                       it will read 'PROPERTY_VALUE Range:'.
% 


if nargin < 1, error('CGPRECFLOAT/PRECEDIT : Too few arguments for precedit'), end
if nargout ~= 1,  error('CGPRECFLOAT/PRECEDIT : Too few outputs for precedit'), end

rangestr = 'Range :'; % Set up rangestr here. if it gets altered so be it, otherwise it's around to 
                      % be dumped into the text box when needed.

if ~isempty(varargin)
    if (length(varargin)/2) ~= round(length(varargin)/2)
        error('CGPRECFLOAT/PRECEDIT : Wrong number of inputs')
    else
        for i = 1:2:length(varargin)
            property = varargin{i};
            property_value = varargin{i+1};
            if ~ischar(property)
                error('CGPRECFLOAT/PRECEDIT : Invalid Property')
            else
                switch lower(property)
                case 'rangestring'
                    if ~ischar(property_value)
                        error('CGPRECFLOAT/PRECEDIT : Invalid setting')
                    elseif ~isempty(property_value)
                        rangestr = [property_value,' ',rangestr];
                    end
                    % I was going to throw an error here, but since we are going to want to pass this 
                    % info onto another precedit if precision type gets changed, then we can't do that
                    % since what works in one precedit may not work in another, so we'll ignore it but 
                    % keep it around should it be needed.
                    %                otherwise 
                    %                    error('CGPRECFLOAT/PRECEDIT : Unknown property')
                end
            end
        end
    end
end
% check to see if this one is writable or not, and obtain precision object settings

mbits = num2str(get(in,'mbits'));
ebits = num2str(get(in,'ebits'));
R = get(in,'physrange');
rmin = num2str(R(1));
rmax = num2str(R(2));
if get(in,'writable');
    writeflag = 'on';
else
    writeflag = 'off';
end
editfig = figposition(in,pos);
ud = get(editfig,'userdata');
% set up a global variable should the cancel button be pushed
global CANCEL_FLAG PRECISION_TYPE
CANCEL_FLAG = 0;
PRECISION_TYPE = []; 

ud.radio(1) = xreguicontrol(editfig,...
    'style','radio',...
    'string','IEEE Double precision',...
    'position',[20 220 160 20],...
    'value',0,...
    'callback',@i_Radio);

ud.radio(2) = xreguicontrol(editfig,...
    'style','radio',...
    'string','IEEE Single precision',...
    'position',[20 200 160 20],...
    'value',0,...
    'callback',@i_Radio);

ud.radio(3) = xreguicontrol(editfig,...
    'style','radio',...
    'string','Custom precision',...
    'position',[20 180 160 20],...
    'value',0,...
    'callback',@i_Radio);

xreguicontrol(editfig,...
    'style','text',...
    'string','Mantissa Bits:',...
    'position',[20 155 100 20],...
    'horizontal','left');
    
ud.mantissa = xreguicontrol(editfig,...
    'style','edit',...
    'horizontal','left',...
    'position',[140 155 40 20],...
    'background',[1 1 1],...
    'enable',writeflag,...
    'string',mbits);

xreguicontrol(editfig,...
    'style','text',...
    'string','Exponent Bits:',...
    'position',[20 125 100 20],...
    'horizontal','left');

ud.exponent = xreguicontrol(editfig,...
    'style','edit',...
    'horizontal','left',...
    'position',[140 125 40 20],...
    'background',[1 1 1],...
    'enable',writeflag,...
    'string',ebits);

xreguicontrol(editfig,...
    'style','text',...
    'string',rangestr,...
    'position',[20 100 100 20],...
    'horizontal','left');

ud.rangemin = xreguicontrol(editfig,...
    'style','edit',...
    'backgroundcolor',[1 1 1],...
    'enable',writeflag,...
    'position',[20 75 40 20],...
    'horizontal','left',...
    'string',rmin);

xreguicontrol(editfig,...
    'style','text',...
    'position',[85 65 30 30],...
    'string','to',...
    'horizontal','center');

ud.rangemax = xreguicontrol(editfig,...
    'style','edit',...
    'backgroundcolor',[1 1 1],...
    'enable',writeflag,...
    'position',[140 75 40 20],...
    'horizontal','left',...
    'string',rmax);

if str2num(mbits) == 52 & str2num(ebits) == 11
    set(ud.radio(1),'value',1);
    set([ud.mantissa; ud.exponent],'enable','off');
elseif str2num(mbits) == 23 & str2num(ebits) == 8
    set(ud.radio(2),'value',1);
    set([ud.mantissa; ud.exponent],'enable','off');
else
    set(ud.radio(3),'value',1);
end
ud.obj = in;
ud.writeEnableControls = [ud.radio,ud.mantissa,ud.exponent,ud.rangemin,ud.rangemax];
set(editfig,'user',ud);

go = 0;

while go == 0
    uiwait(editfig);
    % From here on the OK button should have been pressed, we collect the data, if any of it is silly, then we return to the top
    % otherwise we continue and exit.
    go = 1;
    if isempty(PRECISION_TYPE)
        if CANCEL_FLAG == 0
            mbits = str2num(get(ud.mantissa,'string'));
            ebits = str2num(get(ud.exponent,'string'));
            rmin = str2num(get(ud.rangemin,'string'));
            rmax = str2num(get(ud.rangemax,'string'));
            writable = get(ud.writable,'value');
            if isempty(mbits) | mbits ~= round(mbits)
                msgbox('Please enter an integer for the mantissa','Problem with Mantissa','modal');
                go = 0;
            end
            if isempty(ebits) | ebits ~= round(ebits)
                msgbox('Please enter an integer for the exponent','Problem with Exponent','modal');
                go = 0;
            end
            if isempty(rmin) 
                msgbox('Please enter a number for the range minimum','Problem with Range Minimum','modal');
                go = 0;
            end
            if isempty(rmax) 
                msgbox('Please enter a number for the range maximum','Problem with Range Maximum','modal');
                go = 0;
            end
            if rmin > rmax
                msgbox('Please make sure range is increasing','Problem with range','modal');
                go = 0;
            end            
        end
    end
end

if isempty(PRECISION_TYPE)
    if CANCEL_FLAG == 0
        in = set(in,'mbits',mbits);
        in = set(in,'ebits',ebits);
        in = set(in,'physrange',[rmin rmax]);
        in = set(in,'writable',writable);
    else
        in = [];
    end
    out = in;
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

% -------------------------------------------
function i_Radio(src,obj)
% -------------------------------------------
ud = get(gcf,'user');
index = find(src==ud.radio);
set(ud.radio,'value',0);set(src,'value',1);
switch(index)
case 1
    set(ud.mantissa,'string',num2str(52),'enable','off');
    set(ud.exponent,'string',num2str(11),'enable','off');
case 2
    set(ud.mantissa,'string',num2str(23),'enable','off');
    set(ud.exponent,'string',num2str(8),'enable','off');
case 3
    set(ud.mantissa,'string','','enable','on');
    set(ud.exponent,'string','','enable','on');
end