% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function param=disablefield(param,paramtext,enablesthese,inbox)
% the boolean parameter paramtext switches on or off the fields in
% enablethese
% this is the reverse of enablefield

cont=param.entries;
nrent=length(cont);

if nargin<4 % search in all subsections
    inbox='all';
end

nr=getentrynumberbytext(param,paramtext,inbox);
inbox=param.entries{nr}.panel;

if nr>0
    cval=1-param.entries{nr}.value; % disable instead of enable
    nre=size(enablesthese,1);
    if nre==1
        param.entries{nr}.disables{1}=enablesthese;
        param.entries{nr}.disables_inbox{1}=inbox;
        param=enable(param,enablesthese,cval,inbox);
    else
        for i=1:nre
            param.entries{nr}.disables{i}=enablesthese{i};
            param.entries{nr}.disables_inbox{i}=inbox;
            param=enable(param,enablesthese{i},cval,inbox);
        end
    end
else
    error('setvalue::error, the entry does not exist');
end

