% method of class @parameter
%
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function val=get(param,text,panel)
% returns the current value of the parameter

cont=param.entries;
nrent=length(cont);

if nargin <2 % in case we want the whole stucture
    val=cont;
    return
end

if nargin<3 % search in all subsections
    panel='all';
end


nr=getentrynumberbytext(param,text,panel);

if nr>0
    type=cont{nr}.type;

    handleb=gethandle(param,text,panel,1);
    if ~isequal(handleb,0) && ishandle(handleb) % yes, there is a screen representation
        if strcmp(get(handleb,'type'),'uipanel') && strcmp(type,'panel')
            val=getradiobutton(param,text);
        else
            strval=get(handleb,'string');
            if strcmp(type,'pop-up menu')
                nrsel=get(handleb,'value');
                val=strval{nrsel};
            elseif strcmp(type,'radiobutton')
                val=get(handleb,'value');
            elseif strcmp(type,'bool')
                val=get(handleb,'value');
            elseif strcmp(type,'int')
                if strcmp(strval,'auto');
                    val=strval;
                else
                    val=str2num(strval);
                end
            elseif strcmp(type,'float')
                unit=cont{nr}.orgunit;
                val=getas(param,text,unit,panel);  %call new with unit
            else
                val=strval;
            end
            return
        end
    else  % no screen representation
        if strcmp(type,'float')
            unit=cont{nr}.orgunit;
            val=getas(param,text,unit,panel);  %call new with unit
            return
        elseif strcmp(type,'int')
            valf=cont{nr}.value;
            if ischar(valf)
                if strcmp(valf,'auto');
                    val=valf;
                else
                    val=str2num(valf);
                end
            else
                val=valf;
            end
        elseif strcmp(type,'panel')
            val=getradiobutton(param,text);
        else
            val=cont{nr}.value;
            return
        end
    end
else
    error('error, the entry does not exist');
    %     val=0;  % we must return a logical value otherwise it can generate difficult errors
end