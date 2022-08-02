% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function param=setcallback(param,text,cback,inbox)
% every entry can have a callback function that is called when the item
% looses its focus

cont=param.entries;
nrent=length(cont);

if nargin<4
    inbox='all';
end
nr=-1;
% text can be a string or a number
if isstr(text) % if its a sting then look for the member number
    % first search for the exact fit
    for i=1:nrent
        if strcmp(cont{i}.text,text) && (strcmp(cont{i}.panel,inbox) || strcmp(inbox,'all'))
            nr=i;
            break
        end
    end
    % then search for the abbreviation
    for i=1:nrent
        if ~isempty(strfind(cont{i}.text,text)) && (strcmp(cont{i}.panel,inbox) || strcmp(inbox,'all'))
            nr=i;
            break
        end
    end
else
    nr=text; % in this case we wanted to access it by the number
end


if nr>0
    param.entries{nr}.callback=cback;
    return
else
    val='setcallback:: error, the entry does not exist';
end
