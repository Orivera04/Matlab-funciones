function callback(obj,controlNum)
%CALLBACK

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:29:13 $

ud = get(obj.slider,'userdata');

if ischar(ud.callback)
    % look for special tokens in callback string
    % if find %VALUE% replace with controlNum
    % if find %OBJECT% replace with object reference

    pcs=findstr(ud.callback,'%');
    go=1;
    needval=0;
    needobj=0;
    while (go<=(length(pcs)-1))
        cmp=ud.callback(pcs(go)+1:pcs(go+1)-1);
        if strcmp(cmp,'VALUE')
            needval=1;
            ud.callback=[ud.callback(1:pcs(go)-1) 'XX_LSTVALUE_XX' ud.callback(pcs(go+1)+1:end)];
            go=go+2;
            pcs=pcs+7;
        elseif strcmp(cmp,'OBJECT')
            needobj=1;
            ud.callback=[ud.callback(1:pcs(go)-1) 'XX_LSTOBJECT_XX' ud.callback(pcs(go+1)+1:end)];
            go=go+2;
            pcs=pcs+7;
        else
            go=go+1;
        end
    end

    if needval
        assignin('base','XX_LSTVALUE_XX',controlNum);
    end
    if needobj
        callbackobj = ud.object;
        assignin('base','XX_LSTOBJECT_XX',callbackobj);
    end

    % here we execute the callback in the base wkspace
    evalin('base',ud.callback);

    % clear up base workspace
    evalin('base','clear(''XX_LSTVALUE_XX'',''XX_LSTOBJECT_XX'');');
else
    callbackobj = ud.object;
    S = struct('ListIndex', controlNum);
    xregcallback(ud.callback, callbackobj, S);
end
