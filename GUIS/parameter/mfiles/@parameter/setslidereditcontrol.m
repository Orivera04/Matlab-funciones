% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function param=setslidereditcontrol(param,text,slidereditcombi,inbox)
% defines the tooltio for that entry

if nargin<4
    inbox='all';
end

nr=getentrynumberbytext(param,text,inbox);
if nr>0
    param.entries{nr}.slidereditcombi=slidereditcombi;
end
    
