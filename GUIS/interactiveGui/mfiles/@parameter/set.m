% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function param=set(param,text,newvalue,inbox)
%% sets the parameter value in the parameter "text" in the panel "inbox" to
%% the value "value".
% if its a float then the unit is assumed to be the one with wich the
% parameter was first defined

if nargin<4
    inbox='all';
end

cont=param.entries;
nr=getentrynumberbytext(param,text,inbox);
if nr>0
    type=cont{nr}.type;
    if strcmp(type,'float') ||  strcmp(type,'slider')
        unit=cont{nr}.orgunit;
        param=setas(param,text,newvalue,unit,inbox);  %call new with unit
        return
    elseif strcmp(type,'bool')
        if ischar(newvalue)
            switch newvalue
                case 'false'
                    newvalue=0;
                case 'true'
                    newvalue=1;
            end
        end
        param.entries{nr}.value=newvalue;    % set the value in the class structure
    else
        param.entries{nr}.value=newvalue;    % set the value in the class structure
    end
    if isfield(cont{nr},'handle') && ishandle(cont{nr}.handle{1}) % and set in the gui as well
        hand=cont{nr}.handle{1};
        if strcmp(type,'float') || strcmp(type,'string') || strcmp(type,'filename') || strcmp(type,'directoryname')
            set(hand,'String',newvalue);
        elseif strcmp(type,'int')   % ints are capped
            if isnumeric(newvalue)
                intnewvalue=round(newvalue);
                if length(intnewvalue)==1
                    set(hand,'String',intnewvalue);
                else
                    set(hand,'String',num2str(intnewvalue));
                end
                param.entries{nr}.value=intnewvalue;    % set the value in the class structure
            else
                set(hand,'String',newvalue);
            end
        else
            if strcmp(type,'pop-up menu')
                cont=param.entries{nr}.possible_values;
                for i=1:length(cont)
                    if strcmp(cont{i},newvalue)
                        set(hand,'value',i);
                    end
                end
            else
                set(hand,'value',newvalue); % could be bool
            end
        end
    end
    return
else
    error('setvalue::error, the entry does not exist');
end
