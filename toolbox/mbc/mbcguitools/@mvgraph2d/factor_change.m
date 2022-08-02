function factor_change(gr)
%FACTOR_CHANGE Callback function
%   Callback function for the graph2d object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.4.2 $  $Date: 2004/02/09 07:19:03 $

% check exclusive setting
ud = gr.DataPointer.info;
if ud.factorselection==1
    % need to make sure the other selections aren't the same
    obj=gcbo;
    dir=str2num(get(obj,'tag'));
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
        str=get(gr.xfactor,'string');
        if new<=length(str)
            set(hndl,'value',new)
        end
    end
end

pr_graphlim(gr);

% put data into line object
pr_plot(gr);

%----------------------
%  fire user callback
%----------------------
if ~isempty(ud.callback)
    if ischar(ud.callback)
        % Legacy support for tokens in the string: %XVALUE%, %OBJECT%, %YVALUE%   
        pcs=findstr(ud.callback,'%');
        go=1;
        needobj=0;
        needxval=0;
        needyval=0;
        while (go<=(length(pcs)-1))
            cmp=ud.callback(pcs(go)+1:pcs(go+1)-1);
            if strcmp(cmp,'XVALUE')
                needxval=1;
                ud.callback=[ud.callback(1:pcs(go)-1) 'XX_XVALUE_XX' ud.callback(pcs(go+1)+1:end)];
                go=go+2;
                pcs=pcs+4;
            elseif strcmp(cmp,'YVALUE')
                needyval=1;
                ud.callback=[ud.callback(1:pcs(go)-1) 'XX_YVALUE_XX' ud.callback(pcs(go+1)+1:end)];
                go=go+2;
                pcs=pcs+4;   
            elseif strcmp(cmp,'OBJECT')
                needobj=1;
                ud.callback=[ud.callback(1:pcs(go)-1) 'XX_OBJECT_XX' ud.callback(pcs(go+1)+1:end)];
                go=go+2;
                pcs=pcs+4;
            else
                go=go+1;
            end
        end
        
        if needobj
            assignin('base','XX_OBJECT_XX',gr);
        end
        if needxval
            assignin('base','XX_XVALUE_XX',get(gr.xfactor,'value'));
        end
        if needyval
            assignin('base','XX_YVALUE_XX',get(gr.yfactor,'value'));
        end
        
        evalin('base',ud.callback);
        
        % clear up base workspace
        evalin('base','clear(''XX_OBJECT_XX'',''XX_XVALUE_XX'',''XX_YVALUE_XX'');'); 
    else
        xregcallback(ud.callback, gr, struct('xvalue', get(gr.xfactor,'value'), 'yvalue',get(gr.yfactor,'value')));
    end
end
return
