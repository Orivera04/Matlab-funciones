function [desout,ok]=constrainteditor(des,tp,figh,ptr,varargin)
%CONSTRAINTEDITOR Constraints editor for design objects
%
%  H=CONSTRAINTEDITOR(D,TP[,FIG,PTR]) creates a gui for editing the
%  constraints object in D.  TP indicates the type of GUI required: the
%  function can either create its own figure (TP='figure') and block until
%  the constraints have been edited or it can return a handle to a layout
%  object for embedding in other GUIs.  In this case the function also
%  requires the optional argument FIG, a valid figure handle, and PTR, a
%  pointer to the design, so the data can be kept updated.
%
%  If used in layout mode, a callback string may be attached by appending
%  the arguments 'callback',CBSTR to the input list.  This will be
%  activated whenever the constraints are altered.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.5 $  $Date: 2004/04/04 03:27:06 $

% sort out inputs
if nargin<2
    tp='figure';
end
switch lower(tp)
    case 'figure'
        [desout,ok]=i_createfig(des);
    case 'layout'
        desout=i_createlyt(figh,ptr,varargin{:});
        ok=1;

    case 'addcon'
        ud=get(figh,'userdata');
        set(ud.figure,'pointer','watch');
        des=ud.pointer.info;

        if builtin('isempty',des.constraints)
            % build constraint object
            f= factors(des);
            des.constraints= des_constraints(f);
        end

        % check for an empty constraint
        if isempty(des.constraints)
            newc=1;
        else
            intpts=interiorPoints(des.constraints);
            newc=0;
        end

        lims = gettarget(model(des));
        if nfactors(des)>1
            con = contable1(nfactors(des));
            [c, ind] = add(des.constraints, con);
        else
            [c, ind] = add(des.constraints,'linear',1, lims(1,2));
        end
        [c, sel] = constraintgui(c,'create',ind,model(des));

        if sel==0
            % cancel pressed
        else
            % ok pressed
            des.constraints=c;
            if ~newc;
                usewait=waitbars(des) & (length(intpts)>50000);
                if usewait
                    % prevent any nested waitbars
                    des=waitbars(des,0);
                    % gui feedback
                    h=xregGui.waitdlg('title','MBC Toolbox','message','Adding constraint.  Please wait...');
                    drawnow;
                end
                % evaluate new constraint
                % generate points
                Xc= indexcand(des,intpts,'unconstrained');
                if usewait
                    h.waitbar.value=.35;
                    drawnow;
                end
                % evaluate constraints (need to reset first)
                des.constraints=reset(des.constraints);
                if usewait
                    h.waitbar.value=.4;
                    drawnow;
                end
                des.constraints=eval(des.constraints,Xc);
                if usewait
                    h.waitbar.value=.9;
                    drawnow;
                end
                % interior points are a subset of the old IP's
                intpts=intpts(interiorPoints(des.constraints));
                if usewait
                    h.waitbar.value=.95;
                    drawnow;
                end
                % set the new interior points
                des.constraints=interiorPoints(des.constraints,intpts);
                if usewait
                    h.waitbar.value=1;
                    drawnow;
                end

                des.candstate=des.candstate+1;
                des.constraintsflag=des.candstate;

                if usewait
                    des=waitbars(des,1);
                    delete(h);
                end
            else
                des=EvalConstraints(des);
            end

            % update list box
            set(ud.h(1),'string',char(des.constraints),'value',sel);

            if ~isempty(des.constraints)
                set([ud.h(3),ud.h(4),ud.h(5)],'enable','on')
            end
            ud.pointer.info=des;
            i_firecb(figh);
        end
        set(ud.figure,'pointer','arrow');
        return
    case 'delcon'

        ud=get(figh,'userdata');
        set(ud.figure,'pointer','watch');
        des=ud.pointer.info;

        ind=get(ud.h(1),'value');
        des.constraints=delete(des.constraints,ind);
        % reeval constraints
        des.constraints=reset(des.constraints);
        des=EvalConstraints(des);

        set(ud.h(1),'string',char(des.constraints),'value',min(ind,length(des.constraints)));
        if isempty(des.constraints)
            set([ud.h(3),ud.h(4),ud.h(5)],'enable','off')
        end

        ud.pointer.info=des;
        i_firecb(figh);
        set(ud.figure,'pointer','arrow');
        return

    case 'editcon'
        ud=get(figh,'userdata');
        set(ud.figure,'pointer','watch');
        des=ud.pointer.info;
        ind=get(ud.h(1),'value');
        if ind
            [c sel]=constraintgui(des.constraints,'create',ind,model(des));
            if sel==0
                % cancel
            else
                des.constraints=c;
                % reeval constraints
                des.constraints=reset(des.constraints);
                des=EvalConstraints(des);

                if sel
                    % update list box
                    set(ud.h(1),'string',char(des.constraints),'value',sel);
                end
                ud.pointer.info=des;
                i_firecb(figh);
            end
        end
        set(ud.figure,'pointer','arrow');
        return
    case 'dupcon'
        ud=get(figh,'userdata');
        set(ud.figure,'pointer','watch');
        des=ud.pointer.info;
        ind=get(ud.h(1),'value');
        if ind
            des.constraints=duplicate(des.constraints,ind);
            % no need for re-evaluation since this is a copy of a current constraint
            set(ud.h(1),'string',char(des.constraints));
            ud.pointer.info=des;
            i_firecb(figh);
        end
        set(ud.figure,'pointer','arrow');
    otherwise
        return
end


function [desout,ok]=i_createfig(des)
figh = xregdialog('name','Constraints Manager',...
    'resize','off', ...
    'tag','Constrainteditor');
xregcenterfigure(figh, [350 220]);

p = xregpointer(des);
lyt = i_createlyt(figh,p);

okbtn=uicontrol('style','pushbutton',...
    'parent',figh,...
    'string','OK',...
    'callback','set(gcbf,''visible'',''off'',''tag'',''ok'');');
cancbtn=uicontrol('style','pushbutton',...
    'parent',figh,...
    'string','Cancel',...
    'callback','set(gcbf,''visible'',''off'');',...
    'userdata',des);
helpbtn=mv_helpbutton(figh,'xreg_desConManager');
% create layouts
main=xreggridbaglayout(figh,...
    'dimension',[2 4],...
    'rowsizes',[-1 25],...
    'colsizes',[-1 65 65 65],...
    'border',[10 10 10 10],...
    'gapx',7,'gapy',10,...
    'mergeblock',{[1 1],[1 4]},...
    'elements',{lyt,[],[],okbtn,[],cancbtn,[],helpbtn});

figh.LayoutManager=main;
set(main,'packstatus','on');

figh.showDialog(okbtn);

tg=get(figh,'tag');
switch tg
    case 'ok'
        % ok pressed
        desout=p.info;
        ok=1;
        % run design indices through constraints to check them - alert user if they don't
        % meet constraints AND are not fixed.
        fs=factorsettings(desout);
        freep=freepoints(desout);
        fs=fs(freep,:);
        if ~isempty(fs) && ~isempty(desout.constraints)
            [c,in]=eval(desout.constraints,fs);
            if ~all(in)
                np=sum(double(~in));
                tp=DesignType(desout);
                if tp==1
                    % optimal design - allow replacement
                    out=questdlg(['There are currently ' sprintf('%d',np) ' non-fixed points in ',...
                        'the design that are not within the new constraints envelope.  Do you want ',...
                        'to remove these points, replace them with new ones or cancel the constraint ',...
                        'change?'],'MBC Toolbox','Remove','Replace','Cancel','Replace');
                    if strcmp(out,'Remove')
                        ind=find(~in);
                        ind=freep(ind);
                        desout=delete(desout,'indexed',ind);
                        ok=2;
                    elseif strcmp(out,'Replace')
                        ind=find(~in);
                        ind=freep(ind);
                        % save and reset type info so that the correct option shows up in addgui
                        [tp,nm]=DesignType(desout);
                        desout=delete(desout,'indexed',ind);
                        desout=DesignType(desout,tp,nm);
                        % fire up add point dialog
                        desout=gui_addpoints(desout,'create','npoints',length(ind));
                        ok=2;
                    else
                        desout=des;
                        ok=0;
                    end
                else
                    out=questdlg(['There are currently ' sprintf('%d',np) ' non-fixed points in ',...
                        'the design that are not within the new constraints envelope and will be ',...
                        'removed.  Do you want to continue with the removal or cancel ',...
                        'the constraint change?'],'MBC Toolbox','Continue','Cancel','Continue');
                    if strcmp(out,'Continue')
                        ind=find(~in);
                        ind=freep(ind);
                        desout=delete(desout,'indexed',ind);
                        ok=2;
                    else
                        desout=des;
                        ok=0;
                    end
                end
            end
        end
    otherwise
        % cancel pressed
        % return original design
        desout=des;
        ok=0;
end
% free pointer information
freeptr(p);
delete(figh);


function lyt=i_createlyt(figh,p,varargin)
if ~isa(figh,'xregcontainer')
    mnm=mfilename;
    [pth,mnm]=fileparts(mnm);
    ud.pointer=p;
    ud.figure=figh;
    ud.callback='';
    % objects for displaying constraints and buttons for editing
    ud.h(1)=uicontrol('parent',figh,...
        'style','listbox',...
        'backgroundcolor','w',...
        'userdata',xregdesign);
    objh=sprintf('%20.15f',ud.h(1));
    ud.h(2)=uicontrol('parent',figh,...
        'style','pushbutton',...
        'position',[0 0 65 25],...
        'string','Add...');
    ud.h(3)=uicontrol('parent',figh,...
        'style','pushbutton',...
        'position',[0 0 65 25],...
        'string','Delete');
    ud.h(4)=uicontrol('parent',figh,...
        'style','pushbutton',...
        'position',[0 0 65 25],...
        'string','Edit...');
    ud.h(5)=uicontrol('parent',figh,...
        'style','pushbutton',...
        'position',[0 0 65 25],...
        'string','Duplicate');
    udh=sprintf('%20.15f',ud.h(4));

    set(ud.h(2),'callback',[mnm '(get(' objh ',''userdata''),''addcon'',' udh ');']);
    set(ud.h(3),'callback',[mnm '(get(' objh ',''userdata''),''delcon'',' udh ');']);
    set(ud.h(4),'callback',[mnm '(get(' objh ',''userdata''),''editcon'',' udh ');']);
    set(ud.h(5),'callback',[mnm '(get(' objh ',''userdata''),''dupcon'',' udh ');']);

    if nargin>2
        for n=1:2:length(varargin)
            switch lower(varargin{n})
                case 'callback'
                    ud.callback=varargin{n+1};
            end
        end
    end

    % put together the layout
    % flowlayout for buttons
    lyt=xreggridbaglayout(figh,...
        'packstatus','off',...
        'dimension',[5 2],...
        'gapy',10,...
        'gapx',5,...
        'mergeblock',{[1 5],[1 1]},...
        'rowsizes',[25 25 25 25 -1],...
        'colsizes',[-1 65],...
        'elements',{ud.h(1),[],[],[],[],ud.h(2),ud.h(3),ud.h(4), ud.h(5),[]});
else
    lyt=figh;
    el=get(lyt,'elements');
    el=el{8};
    ud=get(el,'userdata');
    ud.pointer=p;
    if nargin>2
        for n=1:2:length(varargin)
            switch lower(varargin{n})
                case 'callback'
                    ud.callback=varargin{n+1};
            end
        end
    end
end
ud=i_setvalues(ud);
set(ud.h(4),'userdata',ud);


function ud=i_setvalues(ud)
p=ud.pointer;
set(ud.h(1),'string',char(p.constraints));
if isempty(constraints(p.info))
    set([ud.h(3),ud.h(4),ud.h(5)],'enable','off');
end


function i_firecb(udhval)
ud=get(udhval,'userdata');
if ~isempty(ud.callback)
    evalin('base',ud.callback);
end
