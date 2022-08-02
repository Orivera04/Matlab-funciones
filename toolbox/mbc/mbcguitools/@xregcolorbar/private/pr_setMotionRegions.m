function pr_setMotionRegions(gr)
% Set mouse motion regions corresponding to limits

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:31:46 $

newpos = get(gr.cfactor,'userdata');

gr = builtin('get',gr.colorbar.axes,'userdata');
%Get the current motion managers

mnsz=minsize(gr);
if newpos(3)<mnsz(1) | newpos(4)<mnsz(2)
    % go to blackout mode
    gr.MouseMotion(4).Enable = 'off';
else
    pos = get(gr.colorbar.axes,'position');
    
    if ~get(gr.colorbar.userange,'value')
        gr.MouseMotion(4).Enable = 'off';
    else
        gr.MouseMotion(4).Enable = 'on';
        
        ylim=get(gr.colorbar.axes,'ylim');
        clen=ylim(2)-ylim(1);
        act_delta = 2;
        barval=get(gr.colorbar.minrange,'userdata');
        ypos = floor((barval-ylim(1))/clen*pos(4) + pos(2) - 2*act_delta);
        gr.MouseMotion(1).Region = [pos(1) ypos pos(3) 4*act_delta];
        
        barval=get(gr.colorbar.midrange,'userdata');
        ypos = floor((barval-ylim(1))/clen*pos(4) + pos(2) - 2*act_delta);
        gr.MouseMotion(2).Region = [pos(1) ypos pos(3) 4*act_delta];
        
        barval=get(gr.colorbar.maxrange,'userdata');
        ypos = floor((barval-ylim(1))/clen*pos(4) + pos(2) - 2*act_delta);
        gr.MouseMotion(3).Region = [pos(1) ypos pos(3) 4*act_delta];
    end
end

builtin('set',gr.colorbar.axes,'userdata',gr);
