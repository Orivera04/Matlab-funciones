% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function param=getdefaultbutton(param)
% returns the parameter that was set as the default button

ents=param.entries;

for i=1:length(ents)
    if strcmp(ents{i}.type,'button')
       if  ents{i}.isdefaultbutton==1
           param=ents{i};
           return
       end
    end
end

param=[];