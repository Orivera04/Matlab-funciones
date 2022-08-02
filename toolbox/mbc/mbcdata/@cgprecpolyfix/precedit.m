function out = precedit(in,pos,varargin)
%PRECEDIT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.4.2 $  $Date: 2004/02/09 06:55:14 $

% CGPRECPOLYFIX/PRECEDIT  invokes a GUI to edit properties of a CGPRECPOLYFIX object.
% Use varargin as in a set command to tailor the GUI to specific needs. Properties that may be 
% set are: 
%         RangeString - String to describ which range (e.g. input or output) is being edited
%                       If not explicitly set then string will just read 'Range:' otherwise
%                       it will read 'PROPERTY_VALUE Range:'.
%


if nargin < 1, error('CGPRECPOLYFIX/PRECEDIT : Too few arguements for precedit'), end
if nargout ~= 1,  error('CGPRECPOLYFIX/PRECEDIT : Too few outputs for precedit'), end

rangestr = 'Range :'; % Set up rangestr here. if it gets altered so be it, otherwise it's around to 
% be dumped into the text box when needed.

if ~isempty(varargin)
    if (length(varargin)/2) ~= round(length(varargin)/2)
        error('CGPRECPOLYFIX/PRECEDIT : Wrong number of inputs')
    else
        for i = 1:2:length(varargin)
            property = varargin{i};
            property_value = varargin{i+1};
            if ~ischar(property)
                error('CGPRECPOLYFIX/PRECEDIT : Invalid Property')
            else
                switch lower(property)
                case 'rangestring'
                    if ~ischar(property_value)
                        error('CGPRECPOLYFIX/PRECEDIT : Invalid setting')
                    elseif ~isempty(property_value)
                        rangestr = [property_value,' ',rangestr];
                    end
                    % I was going to throw an error here, but since we are going to want to pass this 
                    % info onto another precedit if precision type gets changed, then we can't do that
                    % since what works in one precedit may not work in another, so we'll ignore it but 
                    % keep it around should it be needed.
                    %                otherwise 
                    % error('CGPRECPOLYFIX/PRECEDIT : Unknown property')
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

ud.message = [];
ud.line = [];

xreguicontrol(editfig,...
    'style','text',...
    'string','Numerator Coefficients :',...
    'position',[20 155 160 20],...
    'horizontal','left');

ud.numerator = xreguicontrol(editfig,...
    'style','edit',...
    'horizontal','left',...
    'position',[20 135 160 20],...
    'background',[1 1 1],...
    'callback',@i_Update);

xreguicontrol(editfig,...
    'style','text',...
    'string','Denominator Coefficients :',...
    'position',[20 110 160 20],...
    'horizontal','left');

ud.denominator = xreguicontrol(editfig,...
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
ud.writeEnableControls = [ud.radio,ud.bits,ud.ptpos,ud.signed,ud.numerator,ud.denominator,ud.rangemin,ud.rangemax];
set(editfig,'user',ud);
i_Refresh;
go = 0;

while go == 0
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

return

% -----------------------------------------
function i_Refresh(src,obj)
% -----------------------------------------
fig = findall(0,'tag','TableProperties');
ud = get(fig,'user');
num = get(ud.obj,'numcoeff');den = get(ud.obj,'dencoeff');
numcoeff = num2str(num);dencoeff = num2str(den);
R = get(ud.obj,'physrange');
rmin = num2str(R(1));
rmax = num2str(R(2));
bits = get(ud.obj,'bits');
signed = get(ud.obj,'signed');
ptpos = num2str(get(ud.obj,'ptpos'));
set(ud.signed,'value',0);
if signed
    set(ud.signed(1),'value',1);
else
    set(ud.signed(2),'value',1);
end
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
set(ud.ptpos,'string',ptpos);
set(ud.bits,'string',num2str(bits));
set(ud.numerator,'string',numcoeff);
set(ud.denominator,'string',dencoeff);
set(ud.rangemin,'string',rmin);
set(ud.rangemax,'string',rmax);

% plot graph of object's effect
wrnstate = warning;
warning('off');
delete(ud.line,ud.message); ud.line = []; ud.message = [];
if ~any(isinf(R))
    x = linspace(R(1),R(2),50);
    y = polyval(num,x)./polyval(den,x);
    newphysdata = resolve(ud.obj,x);
    ud.line = line(x,newphysdata,'parent',ud.axes);
    ud.line(2) = line(x,y,'parent',ud.axes,'color',[0 1 0]);
    axis tight
end
set(gcf,'user',ud);
warning(wrnstate);

% -------------------------------------------------------------
function go = i_Update(src,obj)
% -------------------------------------------------------------
go = 1;
global PRECISION_TYPE CANCEL_FLAG
fig = findall(0,'tag','TableProperties');
ud = get(fig,'user');

if isempty(PRECISION_TYPE) & ~CANCEL_FLAG
    numcoeff = str2num(get(ud.numerator,'string'));
    dencoeff = str2num(get(ud.denominator,'string'));
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
    if isempty(numcoeff) | ~isnumeric(numcoeff)
        msgbox('Please enter a vector for the numerator.','Table Properties','modal');
        go = 0;
    end
    if isempty(dencoeff) | ~isnumeric(dencoeff)
        msgbox('Please enter a vector for the denominator.','Table Properties','modal');
        go = 0;
    end
    if isequal(dencoeff,0)
        msgbox('Please enter a non-zero denominator.','Table Properties','modal');
        go = 0;
    end
    if isempty(bits) | round(bits) ~= bits
        msgbox('Please enter an integer for the number of bits.','Table Properties','modal');
        go = 0;
    end
    if isempty(ptpos) | round(ptpos) ~= ptpos
        msgbox('Please enter a integer for the fixed point position.','Table Properties','modal');
        go = 0;
    end
    if isempty(rmin) | ~isnumeric(rmin)
        msgbox('Please enter a number for the range minimum.','Table Properties','modal');
        go = 0;
    end
    if isempty(rmax) | ~isnumeric(rmax)
        msgbox('Please enter a number for the range maximum.','Table Properties','modal');
        go = 0;
    end
    if go
        temp = i_check(numcoeff,dencoeff,[rmin,rmax]);
        if temp == 0
            msgbox('These values result in a multiple valued mapping.','Table Properties','modal');
            go = 0;
        elseif temp == -1
            msgbox('There is a zero in the denominator in the given physical range.','Table Properties','modal');
            go = 0;
        end
        if rmin > rmax
            msgbox('Please make sure range is increasing.','Table Properties','modal');
            go = 0;
        end      
    end
    if go
        ud.obj = set(ud.obj,'numcoeff',numcoeff);
        ud.obj = set(ud.obj,'dencoeff',dencoeff);
        ud.obj = set(ud.obj,'physrange',[rmin rmax]);
        ud.obj = set(ud.obj,'writable',writable);
        ud.obj = set(ud.obj,'bits',bits);
        ud.obj = set(ud.obj,'signed',signed);
        ud.obj = set(ud.obj,'ptpos',ptpos);
        set(fig,'userdata',ud);
        i_Refresh;
    end
end

% -----------------------------------------
function out = i_check(num,den,R)
% -----------------------------------------
% checks to see if the settings give a valid mapping, i.e. one that is monontonic and non singular on the given range R.
% first check that there are no zeros of the denominator in the chosen range

S = roots(den);
if isequal(den,0)
    out = -1;
    return
end
Sreal = [];
N = length(S);
for count = 1:N
    if isreal(S(count));
        Sreal = [Sreal;S(count)];
    end
end
I = zeros(length(Sreal));
I(Sreal(:)>R(1) & Sreal(:) < R(2)) = 1;
if any(I)
    out = -1;
    return
end

% Now do a test on the derivative to see if it's a monotonic function
% construct derivative and find it's zeros. then check either side of 
% any relevant zero.

num1 = num(1:end-1);
den1 = den(1:end-1);
m1 = length(num1);
m2 = length(den1);
num1 = [0 num1.*[m1:-1:1]];
den1 = [0 den1.*[m2:-1:1]];
num2 = conv(num1,den)-conv(num,den1);

T = roots(num2);
if isempty(T)
    if num2 == 0
        out = 0;
    else
        out = 1;
    end
    return
end
N = length(T);
Treal = [];
for count = 1:N
    if isreal(T(count));
        Treal = [Treal;T(count)];
    end
end
J = zeros(length(Treal));
I(Treal(:)>R(1) & Treal(:) < R(2)) = 1;
if any(I)
    X = [R(1);sort(unique(Treal(I)));R(2)];
    x = (X(1:end-1)+X(2:end))/2;
    y = polyval(num2,x);
    idx = diff(sign(y));
    if any(idx)
        out = 0;
        return
    end
end

out = 1;

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