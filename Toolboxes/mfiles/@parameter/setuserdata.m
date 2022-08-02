% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$


function param=setuserdata(param,data,text,inbox)
% the whole struct can have an user entry and every part of the structure
% as well. These can be used by the user for example for the 'other...'
% radiobutton

if nargin <3
    param.userdata=data;
else
    cont=param.entries;
    nrent=length(cont);
    for i=1:nrent
        if strcmp(cont{i}.text,text)&& strcmp(cont{i}.panel,inbox)
            cont{i}.userdata=data;
            param.entries=cont;
            return
        end
    end
end



