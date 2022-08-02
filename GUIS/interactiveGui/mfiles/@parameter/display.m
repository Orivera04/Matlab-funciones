% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function display(param)
% display the content of an object of the parameter class. This function is
% called when the object is listed somewhere or the mouse is over it in the
% editor

cont=param.entries;
nrent=length(cont);
disp(sprintf('%s: object of class datastruct with %d entries:',param.name,nrent));

for i=1:nrent
    panel=cont{i}.panel;
    if ~strcmp(panel,'all')
        indent='   ';
    else
        indent='';
    end
    text=cont{i}.text;
    switch cont{i}.type
        case {'string','pop-up menu','filename','directoryname'}
            val=get(param,text);
            disp(sprintf('%s(%12s) %30s = %s',indent,cont{i}.type,cont{i}.text,val));
        case {'int'}
            val=getstringvalue(param,text);
            disp(sprintf('%s(%12s) %30s = %s',indent,cont{i}.type,cont{i}.text,val));
        case {'float','slider'} 
            strval=getstringvalue(param,text);
            if isequal(strval,'auto')
                disp(sprintf('%s(%12s) %30s = %s',indent,cont{i}.type,text,strval));
            else
%                 curunit=getcurrentunit(param,text);
                curunit=cont{i}.current_unit;
                uninttype=cont{i}.unittype;
                if isa(uninttype,'unit_none')
                    disp(sprintf('%s(%12s) %30s = %s',indent,cont{i}.type,text,strval));
                else
                    disp(sprintf('%s(%12s) %30s = %s %s',indent,cont{i}.type,text,strval,curunit));
                end
            end
        case {'bool','radiobutton'}
            val=get(param,text,cont{i}.panel);
            if val==0
                val='false';
            else
                val='true';
            end
            if strcmp(text,'other...') && isequal(val,'true');
                setto=getradiobutton(param,cont{i}.panel);
                disp(sprintf('%s(%12s) %30s = %s (%s)',indent,cont{i}.type,text,val,setto));
            else
                disp(sprintf('%s(%12s) %30s = %s',indent,cont{i}.type,text,val));
            end
        case 'button'
            disp(sprintf('%s(      button) %22s           (callback:) %s',indent,cont{i}.text,cont{i}.callback));
        case 'panel'
            disp(sprintf('(       panel) %22s     with %d entries:',cont{i}.text,cont{i}.nr_elements));
        otherwise
            %             val=[];
            %     disp(sprintf('(%s) %s ',cont{i}.type,cont{i}.text,val));
    end
end
