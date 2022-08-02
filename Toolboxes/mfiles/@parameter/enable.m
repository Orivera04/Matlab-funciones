% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function param=enable(param,text,disablevalue,inbox)
% if it has a grafical representation then disable

cont=param.entries;
nrent=length(cont);

if nargin<4 % search in all subsections
    inbox='all';
end

nr=getentrynumberbytext(param,text,inbox);
if nr>0
    param.entries{nr}.enable=disablevalue;  % save the value
    if isfield(cont{nr},'handle') && ishandle(cont{nr}.handle{1}) % and set in the gui as well
        hands=cont{nr}.handle;
        for i=1:length(hands)
            switch disablevalue
                case 1
                    set(hands{i},'enable','on');
                case 0
                    set(hands{i},'enable','off');
            end
        end
    end
else
    error('setvalue::error, the entry does not exist');
end
