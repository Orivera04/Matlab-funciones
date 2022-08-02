function linedragcb(gr,action,line)
%LINEDRAGCB   Callback function
%
%  Callback function for graph4d object.  Handles dragging of the
%  range indicator objects on the colourbar.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.4.2 $  $Date: 2004/02/09 07:19:45 $


persistent th
switch lower(action)
    case 'buttondown'
        obj = gr.colorbar.([line 'range']);
        set(get(gr.axes,'parent'),'pointer','top');
        
        ud.motionfcn = get(get(gr.axes,'parent'),'windowbuttonmotionfcn');
        ud.upfcn = get(get(gr.axes,'parent'),'windowbuttonupfcn');
        set(gr.colorbar.userange,'userdata',ud);
        
        set(obj,'facevertexcdata',1-get(obj,'facevertexcdata'));
        set(get(gr.axes,'parent'),'windowbuttonmotionfcn',{@i_motionfcn,gr,line},...
            'windowbuttonupfcn',{@i_btnupfcn,gr,line});
        
        % create a text object to indicate variable value
        cfactor=get(gr.cfactor,'string');
        if ~strcmp(cfactor,' ');
            cfactor=cfactor{get(gr.cfactor,'value')};
        else
            cfactor='Y';
        end
        
        th=uicontrol('parent',get(gr.axes,'parent'),...
            'style','text',...
            'visible','off',...
            'backgroundcolor',[1 1 0.6],...
            'userdata',cfactor);
        
        % easy way to pop up text box immediately
        linedragcb(gr,'motion',line);
        set(th,'visible','on');
    case 'buttonup'
        obj=gr.colorbar.([line 'range']);
        ud=get(gr.colorbar.userange,'userdata');
        
        set(obj,'facevertexcdata',1-get(obj,'facevertexcdata'));
        set(get(gr.axes,'parent'),'windowbuttonmotionfcn',ud.motionfcn);
        set(get(gr.axes,'parent'),'windowbuttonupfcn',ud.upfcn);
        
        delete(th);
        set(get(gr.axes,'parent'),'pointer','arrow');
        
        % update axes
        pr_plot(gr);
        
    case 'motion'
        % get current cursor point from figure
        cp=get(get(gr.axes,'parent'),'currentpoint');
        % translate to a data point in the colourbar axes!
        cbpos=get(gr.colorbar.axes,'position');
        ylim=get(gr.colorbar.axes,'ylim');
        switch lower(line)
            case 'min'
                % need to drag min to position of cursor. Special cases are:
                %    (1)  if min is dragged above max, it stops at max
                %    (2)  if min is dragged below axes, it stops at bottom of axes
                % Note that the midrange object needs to be moved too to keep it in the middle
                
                axcp=(ylim(2)-ylim(1))*(cp(2)-cbpos(2))/cbpos(4);
                % do checks to limit axcp if necessary
                if axcp<0.5
                    axcp=0.5;
                end
                cmax = gr.DataPointer.info.rangepositions(3);
                if axcp>cmax
                    axcp=cmax;
                end
                strnum=axcp;
                % reset position of line
                % work out delta
                delta=2*(ylim(2)-ylim(1))/(cbpos(4));
                newvert=[0 axcp+delta/4; 0.5 axcp+2*delta; 1 axcp+delta/4;....
                        0 axcp-delta/4; 0.5 axcp-2*delta; 1 axcp-delta/4];
                set(gr.colorbar.minrange,'vertices',newvert);
                gr.DataPointer.info.rangepositions(1) = axcp;
                % move midrange bar
                axcp=(cmax+axcp)/2;
                newvert=[0 axcp+delta/4; 0.5 axcp+2*delta; 1 axcp+delta/4;....
                        0 axcp-delta/4; 0.5 axcp-2*delta; 1 axcp-delta/4];
                set(gr.colorbar.midrange,'vertices',newvert);
                gr.DataPointer.info.rangepositions(2) = axcp;
            case 'mid'           
                midcp=(ylim(2)-ylim(1))*(cp(2)-cbpos(2))/cbpos(4);
                % do checks to limit axcp if necessary
                rp = gr.DataPointer.info.rangepositions;
                oldmin = rp(1);
                oldmax = rp(3);
                
                mincp=midcp-(oldmax-oldmin)/2;
                maxcp=midcp+(oldmax-oldmin)/2;
                
                if mincp<ylim(1)
                    % push maxcp back up
                    maxcp=maxcp+ylim(1)-mincp;
                    mincp=ylim(1);
                end
                if maxcp>ylim(2)
                    % push mincp back down
                    mincp=mincp-maxcp+ylim(2);
                    maxcp=ylim(2);
                end
                
                % rework midcp according to max and min
                midcp=(mincp+maxcp)/2;
                strnum=midcp;
                delta=2*(ylim(2)-ylim(1))/(cbpos(4));
                newvert=[0 mincp+delta/4; 0.5 mincp+2*delta; 1 mincp+delta/4;....
                        0 mincp-delta/4; 0.5 mincp-2*delta; 1 mincp-delta/4];
                set(gr.colorbar.minrange,'vertices',newvert);
                newvert=[0 midcp+delta/4; 0.5 midcp+2*delta; 1 midcp+delta/4;....
                        0 midcp-delta/4; 0.5 midcp-2*delta; 1 midcp-delta/4];
                set(gr.colorbar.midrange,'vertices',newvert);
                newvert=[0 maxcp+delta/4; 0.5 maxcp+2*delta; 1 maxcp+delta/4;....
                        0 maxcp-delta/4; 0.5 maxcp-2*delta; 1 maxcp-delta/4];
                set(gr.colorbar.maxrange,'vertices',newvert);
                gr.DataPointer.info.rangepositions = [mincp midcp maxcp];
            case 'max'
                axcp=(ylim(2)-ylim(1))*(cp(2)-cbpos(2))/cbpos(4);
                % do checks to limit axcp if necessary
                if axcp>ylim(2)
                    axcp=ylim(2);
                end
                cmin = gr.DataPointer.info.rangepositions(1);
                if axcp<cmin
                    axcp=cmin;
                end
                strnum=axcp;
                % reset position of line
                % work out delta
                delta=2*(ylim(2)-ylim(1))/(cbpos(4));
                newvert=[0 axcp+delta/4; 0.5 axcp+2*delta; 1 axcp+delta/4;....
                        0 axcp-delta/4; 0.5 axcp-2*delta; 1 axcp-delta/4];
                set(gr.colorbar.maxrange,'vertices',newvert);
                gr.DataPointer.info.rangepositions(3) = axcp;
                % move midrange bar
                axcp=(cmin+axcp)/2;
                newvert=[0 axcp+delta/4; 0.5 axcp+2*delta; 1 axcp+delta/4;....
                        0 axcp-delta/4; 0.5 axcp-2*delta; 1 axcp-delta/4];
                set(gr.colorbar.midrange,'vertices',newvert);
                gr.DataPointer.info.rangepositions(2) = axcp;
        end
        
        % redraw text box
        if ishandle(th)
            %position
            tpos(1)=cp(1)-55;tpos(2)=cp(2);tpos(3)=50;tpos(4)=16;
            %string
            cfactor=get(th,'userdata');
            % need to scale number to actual values.
            clim=get(gr.axes,'clim');
            strnum=clim(1)+(clim(2)-clim(1)).*strnum./(ylim(2)-ylim(1));
            tstr=[cfactor '=' sprintf('%5.3f',strnum)];
            set(th,'position',tpos,'string',tstr);
        end
end


function i_motionfcn(src,evt,gr,item)
linedragcb(gr,'motion',item);



function i_btnupfcn(src,evt,gr,item)
linedragcb(gr,'buttonup',item);


