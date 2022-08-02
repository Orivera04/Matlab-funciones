% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function param=add(param,type,text,argument4,argument5,argument6,argument7,argument8,argument9)
% add a new parameter to the structure
% and set its inital state variables

cont=param.entries;
newentrynr=length(cont)+1;

% each entry must be one of the following types:
% float (% floats can have an UNIT)
% int
% string
% bool (checkbox)
% button
% radiobutton (radiobutton)
% filename (a button and a string box)
% directoryname (a button and a string box)
% pop-up menu (a couple of strings)
% slider (a float plus a slider)
%
% it can also be a panel that is a subpanel that contains different uicontrols for example radiobuttons


if strcmp(type,'panel')
    param.panelinfo.panelcount=0;  % reset the counter because the next n entries are in this panel
    param.panelinfo.is_in_panel=1;    % flag for the next ones
    param.panelinfo.count_panels_up_to=argument4;  % so many are coming
    param.panelinfo.current_panel=text;
end

% every entry is part of a panel. Either of type 'all' or of the given
% subpanels
if ~isfield(param.panelinfo,'panelcount') || ~param.panelinfo.is_in_panel
    cont{newentrynr}.panel='all';
else
    cont{newentrynr}.panel=param.panelinfo.current_panel;
    param.panelinfo.panelcount=param.panelinfo.panelcount+1;
    if param.panelinfo.panelcount>param.panelinfo.count_panels_up_to
        param.panelinfo.is_in_panel=0;
    end
end


cont{newentrynr}.type=type;
cont{newentrynr}.enable=1;  % enable it by default

% each entry has a text that characterises it uniqly:
cont{newentrynr}.text=text;

% each entry can have an callback function that is called after it looses
% its focus or is pressed:
cont{newentrynr}.callback='';


% set the tooltip as the name (currently for debugging)
cont{newentrynr}.tooltiptext=cont{newentrynr}.text;

switch type
    case {'int'}
        %                      1     2       3                4    5      6
        %                 object  type     name              val minval maxval
        % eg   params=add(params,'int','min bins above thres',2,  0,     inf);

        if nargin>=4
            cont{newentrynr}.value=argument4;
        else
            cont{newentrynr}.value=0;
        end
        if nargin<5
            cont{newentrynr}.minvalue=intmin;
        else
            cont{newentrynr}.minvalue=argument5;
        end
        if nargin<6
            cont{newentrynr}.maxvalue=intmax;
        else
            cont{newentrynr}.maxvalue=argument6;
        end

    case {'float'}
        %                      1     2       3             4        5    6       7       8
        %                  object  type     name         unittype  val userunit minval maxval
        % eg    params=add(params,'float','window start',unit_time,0,   'ms',      0 ,lenstim);
            if ~isobject(argument4) % without a unit its a unit_none and argument4 is the value
                if isnumeric(argument4)
                    cont{newentrynr}.stringvalue=num2str(argument4);
                    cont{newentrynr}.rawvalue=argument4;
                else
                    cont{newentrynr}.stringvalue=argument4;
                    cont{newentrynr}.rawvalue=str2num(argument4);
                end
                cont{newentrynr}.unittype=unit_none;
                cont{newentrynr}.orgunit=unit_none;
                cont{newentrynr}.current_unit=unit_none;
            else
                cont{newentrynr}.unittype=argument4;   % the general unit (eg unit_time)
                if ischar(argument5)
                    cont{newentrynr}.stringvalue=argument5;
                else
                    cont{newentrynr}.stringvalue=num2str(argument5);
                end
                if ~isa(argument4,'unit_none')
                    cont{newentrynr}.orgunit=argument6;   % the definition unit (later used in calls with set)
                    cont{newentrynr}.current_unit=argument6;   % the definition unit (later used in calls with set)
                    if ischar(argument5) && ~strcmp(argument5,'auto')
                        cont{newentrynr}.rawvalue=fromunits(argument4,str2num(argument5),argument6);
                    elseif ~strcmp(argument5,'auto')
                        cont{newentrynr}.rawvalue=fromunits(argument4,argument5,argument6);
                    else
                        cont{newentrynr}.rawvalue='auto';
                    end
                else
                    if exist('argument6','var') && isnumeric(argument6)
                        temp=argument7;
                        argument7=argument6;
                        argument8=temp;
                    end
                    cont{newentrynr}.orgunit='';   % the definition unit (later used in calls with set)
                    cont{newentrynr}.current_unit='';
                    cont{newentrynr}.rawvalue=argument5;
                end
            end % without unit
            if nargin<7
                cont{newentrynr}.minvalue=-inf;
            else
                cont{newentrynr}.minvalue=argument7;
            end
            if nargin<8
                cont{newentrynr}.maxvalue=+inf;
            else
                cont{newentrynr}.maxvalue=argument8;
            end

    
    case {'slider'}
        %                      1     2       3             4        5    6       7       8      9
        %                  object  type     name         unittype  val userunit minval maxval logornot
        % eg    params=add(params,'slider','slidval',unit_time,     0,   'ms',    0 ,   inf,   islog);
            if ~isobject(argument4) % without a unit its a unit_none and argument4 is the value
                if isnumeric(argument4)
                    cont{newentrynr}.stringvalue=num2str(argument4);
                    cont{newentrynr}.rawvalue=argument4;
                else
                    cont{newentrynr}.stringvalue=argument4;
                    cont{newentrynr}.rawvalue=str2num(argument4);
                end
                cont{newentrynr}.unittype=unit_none;
                cont{newentrynr}.orgunit=unit_none;
                cont{newentrynr}.current_unit=unit_none;
                if nargin<7 % is log or not
                    tmp=1;
                else
                    tmp=argument7;
                end
                argument7=argument5; % minvalue
                argument8=argument6; % maxvalue must be there!
                argument9=tmp;
            else
                cont{newentrynr}.unittype=argument4;   % the general unit (eg unit_time)
                if ischar(argument5)
                    cont{newentrynr}.stringvalue=argument5;
                else
                    cont{newentrynr}.stringvalue=num2str(argument5);
                end
                if ~isa(argument4,'unit_none')
                    cont{newentrynr}.orgunit=argument6;   % the definition unit (later used in calls with set)
                    cont{newentrynr}.current_unit=argument6;   % the definition unit (later used in calls with set)
                    if ischar(argument5) && ~strcmp(argument5,'auto')
                        cont{newentrynr}.rawvalue=fromunits(argument4,str2num(argument5),argument6);
                    elseif ~strcmp(argument5,'auto')
                        cont{newentrynr}.rawvalue=fromunits(argument4,argument5,argument6);
                    else
                        cont{newentrynr}.rawvalue='auto';
                    end
                else
                    if exist('argument6','var') && isnumeric(argument6)
                        temp=argument7;
                        argument7=argument6;
                        argument8=temp;
                    end
                    cont{newentrynr}.orgunit='';   % the definition unit (later used in calls with set)
                    cont{newentrynr}.current_unit='';   % the definition unit (later used in calls with set)
                    cont{newentrynr}.rawvalue=argument5;
                end
            end % without unit
            if ~exist('argument7','var')
                cont{newentrynr}.minvalue=-inf;
            else
                cont{newentrynr}.minvalue=argument7;
            end
            if ~exist('argument8','var')
                cont{newentrynr}.maxvalue=+inf;
            else
                cont{newentrynr}.maxvalue=argument8;
            end
            if ~exist('argument9','var')
                cont{newentrynr}.islog=0;
            else
                cont{newentrynr}.islog=argument9;
            end
            if isa(cont{newentrynr}.orgunit,'unit_none')
                cont{newentrynr}.editscaler=1;
            else
                cont{newentrynr}.editscaler=tounits(argument4,1,argument6);
                cont{newentrynr}.minvalue=fromunits(argument4,cont{newentrynr}.minvalue,argument6);
                cont{newentrynr}.maxvalue=fromunits(argument4,cont{newentrynr}.maxvalue,argument6);
            end
            cont{newentrynr}.nreditdigits=4;

        %                   1       2      3                4     5
        %                object   type   name             val    other value
        %     params=add(params,'bool','swap dimensions','true','othervalue');
    case {'bool','radiobutton'}
        if nargin<4
            argument4='';
        end
        if ischar(argument4)
            if strcmp(argument4,'true')
                cont{newentrynr}.value=1;
            else
                cont{newentrynr}.value=0;
            end
        else
            cont{newentrynr}.value=argument4;
        end
        cont{newentrynr}.tooltiptext=[cont{newentrynr}.panel ': ' cont{newentrynr}.text];
        cont{newentrynr}.enables={}; % these are the ones that are switched on by me
        cont{newentrynr}.enables_inbox={};
        cont{newentrynr}.disables={};  % and these are switched off
        cont{newentrynr}.disables_inbox={};
        if nargin==5
            cont{newentrynr}.userdata=argument5;
        end


        %                  1        2      3          4                        5
        %                object   type     name      callback                default
        %     params=add(params,'button','analyse','ret=fkt(d,params,''plot'');',1);
    case 'button'
        cont{newentrynr}.value=0;
        if strcmp(text,'OK')
            cont{newentrynr}.callback='close';
            if nargin==4 && isnumeric(argument4)
                cont{newentrynr}.isdefaultbutton=argument4;
            else
                cont{newentrynr}.isdefaultbutton=0;
            end
        else
            cont{newentrynr}.callback=argument4;
        end
        cont{newentrynr}.tooltiptext=['button: ' cont{newentrynr}.text];
        if nargin==5 && isnumeric(argument5)
            cont{newentrynr}.isdefaultbutton=argument5;
        else
            if ~strcmp(text,'OK')
                cont{newentrynr}.isdefaultbutton=0;
            end
        end

    case 'pop-up menu'
        cont{newentrynr}.value=argument4{1};
        cont{newentrynr}.numeric_value=1;
        cont{newentrynr}.possible_values=argument4;
        cont{newentrynr}.tooltiptext=['pop-up menu: ' cont{newentrynr}.text];

        %                  1        2      3          4         5
        %                object   type     name       strvalue  length of window
        %   dstruct=add(dstruct,'string','comment',WHATcomment,30);
    case 'string'
        cont{newentrynr}.value=argument4;
        if nargin>=5
            cont{newentrynr}.width=argument5;
        else
            cont{newentrynr}.width=-1;
        end
        cont{newentrynr}.tooltiptext=['string: ' cont{newentrynr}.text];

        %                  1        2      3          4
        %                object   type    name       nr rows
        %    dstruct=add(dstruct,'panel','unit type',10);
    case 'panel'
        cont{newentrynr}.panel=text;
        cont{newentrynr}.tooltiptext=['panel: ' cont{newentrynr}.text];
        cont{newentrynr}.nr_elements=argument4;
    case 'filename'
        if nargin<4
            cont{newentrynr}.value='';
        else
            cont{newentrynr}.value=argument4;
        end
        cont{newentrynr}.tooltiptext=['file name: ' cont{newentrynr}.text];
    case 'directoryname'
        if nargin<4
            cont{newentrynr}.value='';
        else
            cont{newentrynr}.value=argument4;
        end
        cont{newentrynr}.tooltiptext=['directry name: ' cont{newentrynr}.text];
    otherwise
        error(sprintf('dont know type ''%s''',type))
end



% save them
param.entries=cont;