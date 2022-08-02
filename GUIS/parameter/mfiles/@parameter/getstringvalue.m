% method of class @parameter
%
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function val=getstringvalue(param,text,panel)
% returns the current value of the parameter as a string
% this is particulary useful for integer values in the form 1:10


cont=param.entries;
nrent=length(cont);

if nargin<3 % search in all subsections
    panel='all';
end

nr=getentrynumberbytext(param,text,panel);
if nr>0
    type=cont{nr}.type;

    handleb=gethandle(param,text,panel,1);
    if ~isequal(handleb,0) && ishandle(handleb) % yes, there is a screen representation
        val=get(handleb,'string');
        return
    else
        if strcmp(type,'float')
            val=cont{nr}.stringvalue;
            return
        else
            val=cont{nr}.value;
            if ischar(val)
                return
            elseif isnumeric(val)
                val=num2str(val);
                return
            end
        end
    end
else
    error('error, the entry does not exist');
    %     val=0;  % we must return a logical value otherwise it can generate difficult errors
end