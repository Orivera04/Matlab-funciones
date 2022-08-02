% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function val=getraw(param,text,inbox)
% returns the current value of the parameter as it is, no transformation

cont=param.entries;
nrent=length(cont);

if nargin <2 % in case we want the whole stucture
    val=cont;
    return
end

if nargin<3 % search in all subsections
    inbox='all';
end


nr=getentrynumberbytext(param,text,inbox);

if nr>0
    type=cont{nr}.type;
    if strcmp(type,'float')
        val=cont{nr}.rawvalue;
        return
    else
        val=cont{nr}.value;
        return
    end
else
    error('error, the entry does not exist');
    %     val=0;  % we must return a logical value otherwise it can generate difficult errors
end