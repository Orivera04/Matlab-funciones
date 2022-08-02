% method of class @parameter
%
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function str=getradiobutton(param,panel)


cont=param.entries;
nrent=length(cont);


for i=1:nrent
    type=cont{i}.type;
    if strcmp(type,'radiobutton')
        if strcmp(cont{i}.panel,panel)
            handleb=gethandle(param,cont{i}.text,cont{i}.panel,1);
            if ~isequal(handleb,0) && ishandle(handleb) % yes, there is a screen representation
                val=get(handleb,'value');
                if val==1
                    text=cont{i}.text;
                    panel=cont{i}.panel;
                    if strcmp(text,'other...')
                        handle2=gethandle(param,text,panel,2);
                        str=get(handle2,'string');
                    else
                        str=text;
                    end
                    return
                end
            else
                if cont{i}.value==1
                    str=cont{i}.text;
                    if strcmp(str,'other...')
                        str=cont{i}.userdata;
                    end
                    return
                end
            end
        end
    end
end



% if still here then non identical fit
% search for fragment

for i=1:nrent
    type=cont{i}.type;
    if strcmp(type,'radiobutton')
        if ~isempty(strfind(cont{i}.panel,panel))
            handleb=gethandle(param,cont{i}.text,cont{i}.panel,1);
            if ishandle(handleb) % yes, there is a screen representation
                val=get(handleb,'value');
                if val==1
                    text=cont{i}.text;
                    panel=cont{i}.panel;
                    if strcmp(text,'other...')
                        handle2=gethandle(param,text,panel,2);
                        str=get(handle2,'string');
                    else
                        str=text;
                    end
                    return
                end
            else
                if cont{i}.value==1
                    str=cont{i}.text;
                    if strcmp(str,'other...')
                        str=cont{i}.userdata;
                    end
                    return
                end
            end
        end
    end
end

str='error, the entry does not exist';