function factor_change(src,ev,gr,dir)
% GRAPH2D/FACTOR_CHANGE   Callback function
%   Callback function for the graph2d object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 07:31:57 $

% check exclusive setting
ud = get(gr.axes,'userdata');
switch ud.type
case {'single','table'}
    if ud.exclusive
        % need to make sure the other selections aren't the same
        vals=get([gr.xfactor;gr.yfactor],{'value'});
        vals=cat(1,vals{:});
        val=vals(dir);
        reps=find(vals==val);
        if length(reps)>1
            flds={'xfactor','yfactor'};
            chng=setxor(reps,dir);
            hndl=gr.(flds{chng});
            % find a new value to set it to
            used=vals;
            avail=1:4;
            new=setxor(used,avail);
            new=new(1);
            str=get(hndl,'string');
            if new<=length(str)
                set(hndl,'value',new)
            end
        end
    end
case 'multi'
    ydata = get(gr.ytext,'userdata');
    xfac = get(gr.xfactor,'value');
    yfac = get(gr.yfactor,'value');
    % Check for X-Y selection
    if size(ydata,2)==2
        % Is an error being plotted?
        %  replace data with error plot
        if (yfac>1 | xfac==1)
            if xfac==1 & dir==1
                % just selected x-y plot on x - match on y-popup
                set(gr.yfactor,'value',2);
                ud.oldy = yfac; ud.oldx = 2;
                yfac = 2;
            elseif yfac==2 & dir==2
                % just selected x-y plot on y - match on x-popup
                set(gr.xfactor,'value',1);
                ud.oldx = xfac; ud.oldy = 1;
            elseif dir==2 & xfac==1 & yfac~=2 
                % something else selected on y-popup - reset x.
                xfac = max(2,ud.oldx);
                set(gr.xfactor,'value',xfac);
            elseif dir==1 & xfac~=1 & yfac==2
                % something else selected on x-popup - reset y.
                if ud.oldy~=2
                    yfac = ud.oldy;
                else
                    yfac = 1;
                end
                set(gr.yfactor,'value',yfac);
            end
        end
        set(gr.axes,'userdata',ud);
    end
end

pr_graphlim(gr);

% put data into line object
pr_plot(gr);



%----------------------
%  fire user callback
%----------------------
xregcallback(ud.callback);
return
