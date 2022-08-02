% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$

function entry=getentrybyhandle(param,hand)


cont=param.entries;
nrent=length(cont);

% first search for the exact fit
for i=1:nrent
    if isfield(cont{i},'handle')
        for j=1:length(cont{i}.handle)
            if cont{i}.handle{j}==hand
                entry=cont{i};
                return
            end
        end
    end
end

entry=[];