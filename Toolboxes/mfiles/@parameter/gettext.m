% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function name=gettext(param,i,inbox)
% return the description text of the parameter with the entry number i.
% if i is a string then return the full string of the probably abbreviated

if nargin==1
    name=param.name;
    return
end

if isnumeric(i)
    name=param.entries{i}.text;
elseif ischar(i)
    if nargin==2 % search in all subsections
        inbox='all';
    end
    nr=getentrynumberbytext(param,i,inbox);
    name=param.entries{nr}.text;
end
