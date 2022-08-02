function varargout=cgexpr2sl(e,sType,sys,predecessor,pos)
% CGEXPR2SL
% cgexpr2sl(e)
% 	Creates a simulink model form of an expression
%	e is a pointer to an expression
%  External call format - cgexpr2sl(ptr,StrategyType)
%		StrategyType - 1 = development (native simulink blocks)
%							2 = FordEEC
%							3 = Extrapolated
%							4 = Siemens

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.8.4.4 $  $Date: 2004/04/04 03:27:52 $
global vpos ALLPOS WRITEC testVal EXPORTPARFILE EXPRT
NumFormat = '%6.4g ';
if isempty(e)
    return
end

if nargin < 5
    % external call
    % cgexpr2sl(subfeaturePtr,sType,systemName,EXPRTable)
    ALLPOS = [0 0 0 0];
end
if nargin == 4
    % In this case we are constructing the model from scratch
    if e.isa('cgfeature')
        m=e.get('model');
        eq=e.get('equation');
    elseif e.isa('cgmodexpr')
        m = [];
        eq = e;
    end
    % Create the diagram
    % Normal or EXPRTable Version
    export = 0;
    if predecessor == 1
        % Top level of an EXPRTable version - Create subsystem
        add_block('built-in/SubSystem',sys,'position',[60 100 150 200],'tag','nosplit');
        export = 1;
    elseif predecessor == 2
        % Lower level of an EXPRTable version - Create subsystem
        add_block('built-in/SubSystem',sys,'position',[40 100 130 200],'orientation','left');
        export = 2;
    end

    % Get a list of model variables
    ModPtrs=[];
    if ~isempty(m)
        % Get a unique list of pointers in the model
        ModPtrs = unique(m.getdditems);
        ModPtrs = double(ModPtrs(:));
    end
    
    % Get a list of equation variables
    EqPtrs=[];
    % Get a unique list of pointers in the equation which aren't in the model
    if ~isempty(eq)
        if EXPRT
            p = [eq;eq.getptrs];
        else
            p = [eq;eq.getptrsnosf];
        end
        for i=1:length(p)
            if p(i).isa('cgvariable')
                EqPtrs=[EqPtrs;double(p(i))];
            end
        end
        EqPtrs = unique(EqPtrs);
    end
    
    % List the model and equation pointers
    V = unique([ModPtrs;EqPtrs]);
    N=cell(length(V),1);
    % Add the list of signals and normalisers
    if ~isempty(eq)
        for i=1:length(p)
            if p(i).isa('cgnormaliser')
                Flist = p(i).get('Flist');
                if length(Flist)==1 && Flist(1).isa('cglookupone') || isempty(Flist) 
                    % Flsts in the dummy normaliser are empty. Others should be full,
                    % If it is a dummy normaliser in a lookupone, then don't add it to the list for display
                else
                    input=p(i).get('x');
                    if input.isa('cgvariable')
                        ind = find(double(input)==V);
                        if isempty(ind)
                            V = [V;double(input)];
                            N{length(V)}=p(i);
                        else
                            if length(N) < ind
                                N{ind}=p(i);
                            else
                                if isempty(N{ind})
                                    N{ind}=p(i);
                                else
                                    index = find(p(i)==N{ind});
                                    if isempty(index)
                                        N{ind}=[N{ind} p(i)];
                                    end
                                end
                            end
                        end
                    end
                end
            elseif p(i).isa('cgfeature')
                if EXPRT
                    % EXPRT build - subfeatures must be nested subsystems
                else
                    % ordinary build
                    if ~ismember(double(p(i)),V)
                        V = [V;double(p(i))];
                        N{length(V)}=[];
                    end
                end
            end
        end
    end
    vpos=45;

    if isempty(V) || export == 2
        add_block('built-in/outport',[sys,'/',e.getname],...
            'position',[40 100 60 120],...
            'orientation','left');
        %next block position
        pos=[380 140 400 160];
    else
        testVal = [];
        for i=1:length(V)
            vP = assign(xregpointer,V(i));
            if ismember(V(i),ModPtrs)
                col = 'red';
            else
                if vP.isa('cgfeature')
                    col = 'green';
                else
                    col = 'black';
                end
            end
            
            
            valName = vP.getname;
            if vP.isa('cgconstant')
                if WRITEC
                    val = vP.eval;
                    width = 75;
                    if isempty(val)|isnan(val)
                        val=1;
                        width = 15;
                    else
                        val = val(1);
                    end
                else
                    val = 1;
                    width = 15;
                end
                switch sType
                case {1,3,4}
                    add_block('built-in/constant',[sys,'/',valName],...
                        'orientation','right',...
                        'position',[20 vpos 20+width vpos+15],...
                        'ForeGroundColor',col,...
                        'userdata',vP,'linkstatus','none',...
                        'value',num2str(val));
                case 2
                    add_block('FordEEC/CONSTANT',[sys,'/',valName],...
                        'orientation','right',...
                        'position',[20 vpos 20+width vpos+15],...
                        'ForeGroundColor',col,...
                        'userdata',vP,'linkstatus','none',...
                        'constant',num2str(val));
                end
            else
                add_block('built-in/Inport',[sys,'/',valName],...
                    'position',[20 vpos 35 vpos+15],...
                    'orientation','right',...
                    'ForeGroundColor',col,...
                    'userdata',vP,'linkstatus','none');
                thisVal = vP.eval;
                if isempty(thisVal)
                    thisVal = 0;
                end
                testVal = [testVal thisVal(1)];
            end
            set_param([sys,'/',valName],'copyfcn','set_param(gcb,''userdata'',[])');
            add_block('built-in/Goto',[sys,'/F',valName],...
                'orientation','right',...
                'position',[135 vpos 235 vpos+15],...
                'GotoTag',valName,...
                'Description',valName,...
                'ShowName','off',...
                'ForeGroundColor',col,...
                'TagVisibility','global');
            vpos=vpos+30;
            C=get_param([sys,'/',valName],'PortHandles');
            C=C.Outport;
            c=get_param(C,'Position');
            
            G=get_param([sys,'/F',valName],'PortHandles');
            G=G.Inport;
            g=get_param(G,'Position');
            add_line(sys,[c;g]);

            for j=1:length(N{i})
                nP = N{i}(j);
                normName = nP.getname;
                
                switch sType
                case {1,4}
                    add_block('cgeqlib/Function',[sys,'/',normName],...
                        'orientation','right',...
                        'position',[85 vpos 105 vpos+20],...
                        'userdata',nP,'linkstatus','none');
                    if WRITEC
                        x = nP.get('breakpoints');
                        y = nP.get('values');
                        x = reshape(x,1,length(x));
                        y = reshape(y,1,length(y));
                        set_param([sys,'/',normName],'inputvalues',['[ ',num2str(x),' ]'],'outputvalues',['[ ',num2str(y),' ]']);
                    end
                    add_block('built-in/Goto',[sys,'/F',normName],...
                        'orientation','right',...
                        'position',[135 vpos+2.5 235 vpos+17.5],...
                        'GotoTag',normName,...
                        'Description',normName,...
                        'ShowName','off',...
                        'TagVisibility','global');
                case 2
                    add_block('FordEEC/fox',[sys,'/',normName],...
                        'orientation','right',...
                        'position',[85 vpos 105 vpos+20],...
                        'userdata',nP,'linkstatus','none');
                    if WRITEC
                        T.X = nP.get('breakpoints');
                        T.Y = nP.get('values');
                        if EXPRT
                            eval([nP.getname,'=T;']);
                            save(EXPORTPARFILE,nP.getname,'-APPEND');
                        end
                        assignin('base',nP.getname,T);
                        set_param([sys,'/',normName],'CAL_FUNC',nP.getname);
                    end
                    add_block('built-in/Goto',[sys,'/F',normName],...
                        'orientation','right',...
                        'position',[135 vpos+2.5 235 vpos+17.5],...
                        'GotoTag',normName,...
                        'Description',normName,...
                        'ShowName','off',...
                        'TagVisibility','global');
                case 3
                    add_block('cgeqlib/Extrapolating Function',[sys,'/',normName],...
                        'orientation','right',...
                        'position',[85 vpos 105 vpos+20],...
                        'userdata',nP,'linkstatus','none');
                    if WRITEC
                        x = nP.get('breakpoints');
                        y = nP.get('values');
                        set_param([sys,'/',normName],'inputvalues',['[ ',num2str(x'),' ]'],'outputvalues',['[ ',num2str(y'),' ]']);
                    end
                    add_block('built-in/Goto',[sys,'/F',normName],...
                        'orientation','right',...
                        'position',[135 vpos+2.5 235 vpos+17.5],...
                        'GotoTag',normName,...
                        'Description',normName,...
                        'ShowName','off',...
                        'TagVisibility','global');
                case 5
                    add_block('cgeqlib/PreLook-Up',[sys,'/',normName],...
                        'orientation','right',...
                        'position',[85 vpos 105 vpos+20],...
                        'userdata',nP,'linkstatus','none');
                    if WRITEC
                        x = nP.get('breakpoints');
                        y = nP.get('values');
                        set_param([sys,'/',normName],'bpdata',['[ ',num2str(x'),' ]']);
                    end
                    add_block('built-in/Goto',[sys,'/F',normName],...
                        'orientation','right',...
                        'position',[135 vpos+2.5 235 vpos+17.5],...
                        'GotoTag',normName,...
                        'Description',normName,...
                        'ShowName','off',...
                        'TagVisibility','global');
                end
                vpos=vpos+40;
                set_param([sys,'/',normName],'copyfcn','set_param(gcb,''userdata'',[])');
                n=get_param([sys,'/',normName],'PortHandles');
                ni=n.Inport;
                no=n.Outport;
                ni=get_param(ni,'Position');
                no=get_param(no,'Position');
                g=get_param([sys,'/F',normName],'PortHandles');
                g=g.Inport;
                g=get_param(g,'Position');
                add_line(sys,[c;[c(1) ni(2)];ni]);
                add_line(sys,[no;g]);
            end
        end
        
        % Add divider and the outport
        add_block('built-in/SubSystem',[sys,'/divider'],...
            'ShowName','off',...
            'position',[255 24 260 24+vpos],...
            'backgroundcolor','black',...
            'mask','on','maskvariables','b=@1;','b','1',...
            'masktype','Graphical Divider',...
            'maskdescription','This is purely a graphical block. It has no affect on the evaluation of the diagram and can be deleted. The parameter below is for internal use only.'); 
        if ~EXPRT 
            add_block('cgeqlibprivate/label',[sys,'/label'],...
                'ShowName','off',...
                'position',[35 15 550 44]);
        end
        add_block('built-in/outport',[sys,'/',e.getname],...
            'position',[300 140 320 160],...
            'orientation','left');
        %next block position
        pos=[380 140 400 160];
    end
    % Construct the main part of the model
    portstruct = get_param([sys,'/',e.getname],'Porthandles');
    predecessor=portstruct.Inport;
    cgexpr2sl(eq,sType,sys,predecessor,pos);
    return
elseif nargin==3
    %Write single block - non recursive call
    pos=[300 80 320 100];
    predecessor=[];
end
%----------------------------------------------------------
% Add appropriate block
%----------------------------------------------------------
%Is this block already in the model
blockname=[sys,'/',e.getname];
blocks=find_system(bdroot(sys),'type','block','name',e.getname);

if ~isempty(blocks)
    if iscell(blocks)
        blocks = blocks{1};
    end
    user = get_param(blocks,'userdata');
    if ~isempty(user)
        if ~(user==e)
            % Blocks are not really the same
            oldname = e.getname;
            e.info = e.setname([oldname,'_']);
            blocks = [];
        end
    end
end

if isempty(blocks) || nargin==2
    % a new block is being added
    newblock=1;
    switch e.class
    case 'cgfeature'
        if isempty(findstr(sys,'/'))
            % Normal build 
            add_block('built-in/Inport',blockname,...
                'orientation','left','foregroundcolor','green');
            thisVal = e.eval;
            testVal = [testVal thisVal(1)];
            h=get_param(blockname,'handle');
            p=[];
        else
            % EXPRT Build
            % Create a subsystem
            % The '2' signifies that this is a child of a feature
            % and so will not require a refernce area
            cgexpr2sl(e,sType,blockname,2);
            h=get_param(blockname,'handle');
            p=[];
        end
    case 'cgdivexpr'
        err = 1;
        % This loop guarantees a simulink unique name
        while err
            try
                err = 0;
                add_block('built-in/Product',blockname,...
                    'orientation','left',...
                    'showname','off');
            catch
                blockname = [blockname,' '];err = 1;
            end
        end
        h=get_param(blockname,'handle');
        t=e.get('top');
        b=e.get('bottom');
        p=[t b];
        ops = [repmat('*',1,length(t)) repmat('/',1,length(b))];
        if isempty(ops)
            delete_block(h);
            cg_edit_equation('error',['Product block ',blockname,' has no inputs and cannot be added - fix it in the variable browser']);
            return
        end
        set_param(h,'inputs',ops);

    case 'cgsubexpr'
        err = 1;
        % This loop guarantees a simulink unique name
        while err
            try
                err = 0;
                add_block('built-in/Sum',blockname,...
                    'orientation','left',...
                    'showname','off');
            catch
                blockname = [blockname,' '];err = 1;
            end
        end
        h=get_param(blockname,'handle');
        l=e.get('left');
        r=e.get('right');
        p=[l r];
        ops = [repmat('+',1,length(l)) repmat('-',1,length(r))];
        if isempty(ops)
            delete_block(h);
            cg_edit_equation('error',['Sum block ',blockname,' has no inputs and cannot be added - fix it in the variable browser']);
            return
        end
        set_param(h,'inputs',ops);

        case 'cgminmaxexpr'
        err = 1;
        while err
            try
                err = 0;add_block('built-in/MinMax',blockname,...
                    'orientation','left');
            catch
                blockname = [blockname,' '];err = 1;
            end
        end
        
        h  =get_param(blockname,'handle');
        p = e.get('ptrlist');
        numinputs = length(p);
        if e.get('type')
            type = 'min';
        else
            type = 'max';
        end
        set_param(h,'inputs',num2str(numinputs),'function',type);
    case 'cgifexpr'
        add_block('cgeqlib/IfExpr',blockname,...
            'orientation','left');
        h=get_param(blockname,'handle');
        p=[e.get('left') e.get('right') e.get('out1') e.get('out2')];
    case 'cgmswitchexpr'
        list = e.get('list');
        err = 1;
        while err
            try
                err = 0;add_block('cgeqlib/MultiportSwitch',blockname,...
                    'orientation','left','inputs',num2str(length(list)));
            catch
                blockname = [blockname,' '];err = 1;
            end
        end
        h=get_param(blockname,'handle');
        p=[e.get('input') list];
    case 'cgrelexpr'
        add_block('cgeqlib/RelationalOperator',blockname,...
            'orientation','left','operator',e.get('relation'));
        h = get_param(blockname,'handle');
        p = [e.get('left') e.get('right')];
    case 'cgclipexpr'
        bounds = e.get('bounds');
        Upper = num2str(bounds(2));
        Lower = num2str(bounds(1));
        err = 1;
        while err
            try
                err = 0;
                switch sType
                    case {1,3,4}
                        add_block('built-in/Saturation',blockname,...
                            'orientation','left',...
                            'UpperLimit',Upper,'LowerLimit',Lower);
                    case 2
                        add_block('FordEEC/Clip',blockname,...
                            'orientation','left','max',Upper,'min',Lower);
                end
            catch
                blockname = [blockname,' '];
                err = 1;
            end
        end
        h = get_param(blockname,'handle');
        p=e.get('input');
    case 'cgvariable'
        add_block('built-in/Inport',blockname,...
            'orientation','left');
        thisVal = e.eval;
        testVal = [testVal thisVal(1)];
        h=get_param(blockname,'handle');
        p=[];
    case 'cgconstant'
        if WRITEC
            val = e.eval;
            if isempty(val)|isnan(val)
                val=1;
            else
                val = val(1);
            end
        else
            val = 1;
        end
        switch sType
        case {1,3,4}
            add_block('built-in/constant',blockname,...
                'orientation','left','value',num2str(val));
        case 2
            add_block('FordEEC/CONSTANT',blockname,...
                'orientation','left','constant',e.getname);
            if EXPRT
                eval([e.getname,'=val;']);
                save(EXPORTPARFILE,e.getname,'-APPEND');
            end
            assignin('base',e.getname,val);
            
        end
        h=get_param(blockname,'handle');
        p=[];
    case 'cgmodexpr'      
        p=e.get('ptrlist');
        for i=1:length(p)
            inputnames{i} = p(i).getname;% add_block('built-in/Inport',[blockname,'/arg',num2str(i)]);
        end
        buildmodelblock(blockname,inputnames)
        h=get_param(blockname,'handle');
        set_param(h,'linkstatus','none'); 
    case 'cgoptexpr'
        add_block('cgeqlib/OptExpr',blockname,...
            'orientation','left');
        h=get_param(blockname,'handle');
        p=[e.get('change') e.get('model') e.get('condition')];
        set_param(h,'op',e.get('operator'));
    case 'cgfuncexpr'
        list = e.get('ptrlist');
        funcStr = e.get('func');
        L = length(funcStr);
        i = 1;
        while i < L
            if strcmp(funcStr(i),'u')
                suffix = funcStr(i+1);
                j = i+1;
                while ~isempty(str2num(suffix))
                    j = j + 1;
                    if j > length(funcStr)
                        break
                    end
                    suffix = funcStr(i+1:j);
                end
                if j > length(funcStr)
                    if ~isempty(suffix)
                        funcStr = [funcStr(1:i),'(',suffix(1:end),')'];
                    end
                    break
                else
                    if ~isempty(suffix(1:end-1))
                        funcStr = [funcStr(1:i),'(',suffix(1:end-1),')',funcStr(j:end)];
                        i = j;
                        L = L+2;
                    end
                end
            end
            i = i + 1;
        end
        if length(list)>1
            add_block('built-in/SubSystem',blockname,...
                'orientation','left'); 
            add_block('built-in/Outport',[blockname,'/Out'],...
                'orientation','left','position',[20 20 40 40]);
            
            add_block('cgeqlib/Fcn',[blockname,'/',e.getname],...
                'orientation','left','position',[60 20 100 40],...
                'Expr',funcStr);
            f=get_param([blockname,'/',e.getname],'handle');
            set_param(f,'userdata',e,'linkstatus','none','copyfcn','set_param(gcb,''userdata'',[])');
            dport = 'Out/1';
            srcport = [e.getname,'/1'];
            cgautoline(blockname,srcport,dport);
            add_block('cgeqlib/Mux',[blockname,'/',e.getname,'Mux'],'orientation','left',...
                'inputs',num2str(length(list)),'position',[140 20 145 50*length(list)]);
            dport = [e.getname,'/1'];
            srcport = [e.getname,'Mux','/1'];
            cgautoline(blockname,srcport,dport,[],[2 2]);
            for index = 1:length(list)
                add_block('built-in/Inport',[blockname,'/In',num2str(index)],...
                    'orientation','left','position',[170 40*(index-1)+30 190 40*(index-1)+50]);
                dport = [e.getname,'Mux','/',num2str(index)];
                srcport = ['In',num2str(index),'/1'];
                cgautoline(blockname,srcport,dport);
            end
        else
            add_block('cgeqlib/Fcn',blockname,...
                'orientation','left','expr',funcStr);
        end
        h=get_param(blockname,'handle');
        p=list;
    case 'cglookuptwo'
        if WRITEC
            val = e.get('values');
            s = size(val);
            x = 0:s(2)-1;
            y = 0:s(1)-1;
        end
        switch sType
        case {1,4}
            add_block('cgeqlib/Table',blockname,...
                'orientation','left');
            if WRITEC && s(1)*s(2)~=0 
                T = '[';
                for i = 1:s(2)
                    T = [T,sprintf(NumFormat,val(:,i)),';'];
                end
                T(end) = ']';
                set_param(blockname,'RowIndex',['[ ',sprintf(NumFormat,x),' ]'],...
                    'ColumnIndex',['[ ',sprintf(NumFormat,y),' ]'],...
                    'OutputValues',T);
            end
            p=[e.get('x') e.get('y')];
        case 2
            add_block('FordEEC/table',blockname,...
                'orientation','left');
            
            if WRITEC
                set_param(blockname,'CAL_TABLE',e.getname);           
                T.X = x;
                T.Y = y;
                T.Z = val;
                if EXPRT
                    eval([e.getname,'=T;']);
                    save(EXPORTPARFILE,e.getname,'-APPEND');
                end
                assignin('base',e.getname,T);  
            end
            p=[e.get('x') e.get('y')];
        case 3
            add_block('cgeqlib/Extrapolating Table',blockname,...
                'orientation','left');
            if WRITEC
                set_param(blockname,'x',['[ ',sprintf(NumFormat,x),' ]']);
                set_param(blockname,'y',['[ ',sprintf(NumFormat,y),' ]']);
                T = '[';
                for i = 1:s(2)
                    T = [T,sprintf(NumFormat,val(:,i)'),';'];
                end
                T(end) = ']';
                set_param(blockname,'t',T);
            end
            p=[e.get('x') e.get('y')];
        case 5
            add_block('cgeqlib/Table using PreLook-Up',blockname,...
                'orientation','left');
            set_param(blockname,'numDimsPopupSelect','2');
            if WRITEC
                T = '[';
                for i = 1:s(2)
                    T = [T,sprintf(NumFormat,val(:,i)'),';'];
                end
                T(end) = ']';
                set_param(blockname,'table',T);
            end
            p=[e.get('x') e.get('y')];
        end
        h=get_param(blockname,'handle');
        
    case {'cgnormfunction','cgnormaliser'}
        switch sType
        case {1,4}
            add_block('cgeqlib/Function',blockname,...
                'orientation','left');
            if WRITEC
                x = e.get('breakpoints');
                y = e.get('values');
                set_param(blockname,'inputvalues',['[ ',sprintf(NumFormat,x'),' ]'],'outputvalues',['[ ',sprintf(NumFormat,y'),' ]']);
            end
        case 2
            add_block('FordEEC/fox',blockname,...
                'orientation','left');
            if WRITEC
                T.X = e.get('breakpoints');
                T.Y = e.get('values');
                if EXPRT
                    eval([e.getname,'=T;']);
                    save(EXPORTPARFILE,e.getname,'-APPEND');
                end
                assignin('base',e.getname,T);
                
                set_param(blockname,'CAL_FUNC',e.getname);
            end
        case 3
            add_block('cgeqlib/Extrapolating Function',blockname,...
                'orientation','left');
            if WRITEC
                x = e.get('breakpoints');
                y = e.get('values');
                set_param(blockname,'inputvalues',['[ ',sprintf(NumFormat,x'),' ]'],'outputvalues',['[ ',sprintf(NumFormat,y'),' ]']);
            end
        case 5
            if strcmp(e.class,'cgnormaliser')
                add_block('cgeqlib/PreLook-Up',blockname,...
                    'orientation','left');
                set_param(blockname,'numDimsPopupSelect','1');
                if WRITEC
                    x = e.get('breakpoints');
                    set_param(blockname,'bpdata',['[ ',sprintf(NumFormat,x'),' ]']);
                end
            else
                add_block('cgeqlib/Table using PreLook-Up',blockname,...
                    'orientation','left');
                set_param(blockname,'numDimsPopupSelect','1');
                if WRITEC
                    y = e.get('values');
                    set_param(blockname,'table',['[ ',num2str(y'),' ]']);
                end
            end
        end
        h=get_param(blockname,'handle');
        p=e.get('x');
    case 'cglookupone'
        % don't display the dummynormaliser
        switch sType
        case {1,4,5}
            add_block('cgeqlib/Function',blockname,...
                'orientation','left');
            if WRITEC
                x = e.get('breakpoints');
                y = e.get('values');
                set_param(blockname,'inputvalues',['[ ',sprintf(NumFormat,x'),' ]'],'outputvalues',['[ ',sprintf(NumFormat,y'),' ]']);
            end
        case 2
            add_block('FordEEC/fox',blockname,...
                'orientation','left');
            if WRITEC
                T.X = e.get('breakpoints');
                T.Y = e.get('values');
                if EXPRT
                    eval([e.getname,'=T;']);
                    save(EXPORTPARFILE,e.getname,'-APPEND');
                end
                assignin('base',e.getname,T);
                
                set_param(blockname,'CAL_FUNC',e.getname);
            end
        case 3
            add_block('cgeqlib/Extrapolating Function',blockname,...
                'orientation','left');
            if WRITEC
                x = e.get('breakpoints');
                y = e.get('values');
                set_param(blockname,'inputvalues',['[ ',sprintf(NumFormat,x'),' ]'],'outputvalues',['[ ',sprintf(NumFormat,y'),' ]']);
            end
        end
        h=get_param(blockname,'handle');
        p=e.get('x');
        
    otherwise
        error('Unknown block type');
    end
    lenp=length(p);
    set_param(h,'userdata',e,'linkstatus','none','copyfcn','set_param(gcb,''userdata'',[])');
else
    % the block exists already
    if strcmp(get_param(blocks,'orientation'),'right')
        % Add a goto block instead of a new block
        newblock = -1;
        % Block must be in the signal library section
        col = get_param(blocks,'foregroundcolor');
        if iscell(col)
            col=col{1};
        end
        uniqueName = blockname;
        blockadded = 0;
        while ~blockadded
            try
                add_block('built-in/From',uniqueName,...
                    'GotoTag',e.getname,...
                    'Description',e.getname,...
                    'ShowName','off',...
                    'orientation','left',...
                    'foregroundcolor',col,...
                    'position',[10 10 55 15]);
                blockadded = 1;
            catch
                uniqueName = [uniqueName,' '];
            end
        end
        h=get_param(uniqueName,'handle');
        set_param(h,'userdata',e,'linkstatus','none','copyfcn','set_param(gcb,''userdata'',[])');
        p=[];
        lenp=0;
    else
        % Duplicate block in the main section, don't add another one
        % If resetting position here would move the block left don't do it !
        
        newblock = 0;
        h=get_param(blockname,'handle');
        lenp=get_param(h,'ports');
        lenp=lenp(1);
        oldpos=get_param(h,'position');
        width = oldpos(3)-oldpos(1);
        height = oldpos(4)-oldpos(2);
        if oldpos(1)>pos(1)
            % move block right
            pos = [oldpos(1) pos(2) oldpos(1)+width pos(2)+height];
        else
            pos = [pos(1:2) pos(1:2)+[width height]]; 
        end
        %       col = get_param(h,'foregroundcolor');
        %       set_param(h,'foregroundcolor','blue');
        %       set(gcbo,'enable','off');
        %       pause(1)
        %       set(gcbo,'enable','on');
        %       set_param(h,'foregroundcolor',col);
    end
end
%----------------------------------------------------------
% Set position
%----------------------------------------------------------
% now p should hold a list of pointers to input blocks
% and h is the handle of the current block
curpos=get_param(h,'position');
destport=get_param(predecessor,'position');
handlestruct=get_param(h,'porthandles');
iport=handlestruct.Inport;
if newblock ~=0
    width=curpos(3)-curpos(1);
    %adjust height of block according to how many inputs it has
    if lenp==0 || lenp==1
        height=15;
    elseif lenp==2
        height=75;
    else
        height=lenp*lenp*12;
    end	
    curpos=[pos(1) pos(2) pos(1)+width pos(2)+height];
    curpos = cgsetblockpos(h,curpos,ALLPOS);
end
% Different situations require different position settings
if (newblock==-1 || isempty(iport)) && ~isempty(predecessor)
    curpos = [destport(1)+20 destport(2)-7 destport(1)+120 destport(2)+7];
end
if newblock==1 && ~isempty(predecessor)
    prevBlock = get_param(predecessor,'parent');
    numPorts = get_param(prevBlock,'Ports');
    if numPorts(1)==1
        %Current block feeds into a block with a single inport
        outPosn = get_param(handlestruct.Outport,'position');
        delta = outPosn - destport - [80 0];
        curpos = curpos-[delta delta]; %curpos = curpos - [...
    end
end
if newblock==0 
    if pos(1)<curpos(1)
        %block already existed and must be moved
        curpos(3)=curpos(3)-curpos(1)+pos(1);
        curpos(1)=pos(1);
        % Set the new position and add the block to ALLPOS
        curpos = cgsetblockpos(h,curpos,ALLPOS);
        ALLPOS = [ALLPOS;curpos];
    end
else
    % Set the new position and add the block to ALLPOS
    curpos = cgsetblockpos(h,curpos,ALLPOS);
    ALLPOS = [ALLPOS;curpos];
end
%----------------------------------------------------------
% Connect this block to predecessor
%----------------------------------------------------------
if ~isempty(predecessor)
    %connect this block to it's predecessor if required
    srcblock = get_param(predecessor,'parent');
    inum = get_param(predecessor,'portnumber');
    dport = [get_param(srcblock,'name'),'/',num2str(inum)];
    srcport = [get_param(h,'name'),'/1'];
    cgautoline(sys,srcport,dport,ALLPOS,[0 2]);
end

%----------------------------------------------------------
% Recursive call to cgexpr2sl
%----------------------------------------------------------
if newblock==1
    %recursive call to create this block's inputs
    if ~isempty(predecessor) 
        if length(iport)==lenp
            for i=1:lenp
                %work out required block positioning
                %if lenp>1
                if i==1
                    newpos=[curpos(3)+130 curpos(2)];%-lenp*8];
                else
                    newpos=[curpos(3)+130 lastpos(4)+20];
                end
                lastpos=cgexpr2sl(p(i),sType,sys,iport(i),newpos);
            end
        else
            error('Wrong number of input ports or pointers');
        end
    end
end

%----------------------------------------------------------
% Outputs
%----------------------------------------------------------
if nargout==1
    varargout={curpos};
end
