function View=view(nd,cgh,View)
%VIEW
%
%  View=view(nd,cgh,View)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.2.2 $  $Date: 2004/02/09 08:23:53 $


d=cgh.getViewData;
pN = cgh.CurrentNode;
pS = cgh.CurrentSubItem;

ctrlen=repmat({'off'},6,1);  % default enable setting for each control
menuen=repmat({'off'},4,1);  % default enable setting for each menu
hndls=d.Handles;
ON_SET={'on'};
OFF_SET={'off'};

if (pS~=0)
    S = pS.info;
    ctrlen(1:2)=ON_SET;
    menuen(1)=ON_SET;
    set(hndls.Name,'title',getname(S));
    set(hndls.Descr.Control,'string',getdescription(S));
    set(hndls.Alias.Control,'string',getaliasstring(S));
    
    if isconstant(S)
        set([hndls.Min.Control;hndls.Max.Control],'max',1,'min',-1,'value',0);
        constval = getnomvalue(S);
        if constval==0
            clickincr=.1;
        else
            clickincr=10^(fix(log10(abs(constval)))-1);
        end
        set(hndls.Const.Control,'min', -inf, 'max', inf, 'value',constval, 'clickincrement',clickincr);
        set(hndls.Func.Control,'string','');
        menuen(4)=ON_SET;
        menuen(2)=ON_SET;
        ctrlen(5)=ON_SET;
    else
        ctrlen(3:4)=ON_SET;
        menuen(3)=ON_SET;
        R = getrange(S);
        clickincr=10^(fix(log10(R(2)-R(1)))-1);
        set(hndls.Min.Control,'max',R(2)-eps, ...
            'min',-inf, ...
            'value',R(1), ...
            'clickincrement',clickincr);
        set(hndls.Max.Control,'min',R(1)+eps, ...
            'max',inf, ...
            'value',R(2), ...
            'clickincrement',clickincr);
        set(hndls.Const.Control, 'min', R(1)+eps, ...
            'max', R(2)-eps, ...
            'value', get(S, 'setpoint'), ...
            'clickincrement', clickincr);
        if issymvalue(S)
            ctrlen(6)=ON_SET;
            menuen(4)=ON_SET;
            set(hndls.Func.Control,'string',getequation(S));
        else
            ctrlen(5)=ON_SET;
            menuen(2)=ON_SET;
            set(hndls.Func.Control,'string','');
        end
    end
else
    % No selected item
    % set blank strings
    set(hndls.Name,'title','');
    set([hndls.Alias.Control;hndls.Descr.Control;hndls.Func.Control],'string','');
    set([hndls.Min.Control;hndls.Max.Control],'min',1,'max',1,'value',0);
    set(hndls.Const.Control,'value',0);
end

set([hndls.Alias;hndls.Descr;hndls.Min;hndls.Max;hndls.Const;hndls.Func],{'enable'},ctrlen);
set([hndls.Tools;hndls.MakeFormula;hndls.MakeConst;hndls.MakeVar],{'enable'},menuen);
set([hndls.ContextChg;hndls.ContextMakeFor;hndls.ContextMakeCon;hndls.ContextMakeVar],{'enable'},menuen);

% If the variable list is empty, add a status message to inform the user what to do
if isempty(listptrs(pN.info))
    MsgID = cgh.addStatusMsg('Use the toolbar buttons to add a variable, or import variables from a variable dictionary (File -> Import)');
    View.StatusMsgID = MsgID;
end