% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$

function hand=gethandle(param,text,panel,handnr)
% set handle of one line. A line can have more then one handle, therefore
% nr can be bigger then one

if nargin<4
    handnr=1;
end

if nargin<3
    panel='all';
end

nr=getentrynumberbytext(param,text,panel);

if nr>0
    if ~isfield(param.entries{nr},'handle')
        hand=0;
%         disp('error: handle does not exist');
        return
    end
    if length(param.entries{nr}.handle)>=handnr
        hand=param.entries{nr}.handle{handnr};
        if length(hand)>1
            hand=hand(handnr);
        end
    else
        hand=[];
    end
else
    hand=0;
    disp('error: handle does not exist');
end
