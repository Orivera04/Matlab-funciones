% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function val=exist(param,text,inbox)
% returns a boolean value that indicates if that string has a valid field

cont=param.entries;
nrent=length(cont);

if nargin<3 % search in all subsections
    inbox='all';
end


nr=getentrynumberbytext(param,text,inbox);

if nr>0
    val=1;
else
    val=0;  % we must return a logical value otherwise it can generate difficult errors
end