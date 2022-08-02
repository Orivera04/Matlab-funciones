function varargout = boole2(varargin)
% BOOLE2 Application M-file for boole2.fig
%    FIG = BOOLE2 launch boole2 GUI.
%    BOOLE2('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 02-May-2003 01:16:42

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');
    movegui(fig,'center');    
	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
    handles.n=0;

    handles.Terms=[];
    handles.StringTerms=[];

    handles.F=[];
    handles.X=[];
    
    guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
	catch
		disp(lasterr);
	end

end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.



% --------------------------------------------------------------------
function varargout = popVarNumber_Callback(h, eventdata, handles, varargin)
set(handles.edtTerm,'String','');
set(handles.rdbX,'Value',0);
set(handles.lsbTerms,'String','','Value',1);
set(handles.lsbVariables,'String','','Value',1,'BackgroundColor',[0.92 0.91 0.84]);
set(handles.lsbFunction,'String','','Value',1,'BackgroundColor',[0.92 0.91 0.84]);
set(handles.ckb1,'Value',0);
set(handles.psbConvertNow,'Enable','off')
set(handles.no,'Visible','off');
set(handles.txtf,'Visible','off');
set(handles.txtPosition,'String','');
set(handles.txtConvertNow,'String','');
set(handles.edtConvert,'String','');
set(handles.psbClearSelected,'Enable','off')
set(handles.psbSimplify,'Enable','off')
set(handles.txtClearTerms,'Enable','off')
n=get(gcbo,'Value')-1;
if n~=0
    set(handles.psbAdd,'Enable','on');
    set(handles.ckb1,'Enable','on');
else
    set(handles.psbAdd,'Enable','off');
    set(handles.ckb1,'Enable','off');
end
handles.n=n;
handles.Terms=[];
handles.StringTerms='';
guidata(gcbo,handles);
for i=1:n
    set(handles.rdbX(i),'Enable','on');
end
for i=n+1:9
    set(handles.rdbX(i),'Enable','off');
end
figure(handles.fgrBoole2)



% --------------------------------------------------------------------
function varargout = keypressed_Callback(h, eventdata, handles, varargin)
n=handles.n;
if ~n
    return
end
key=get(handles.fgrBoole2,'CurrentCharacter');
if any(ismember('123456789',key))
    num=str2num(key);
    if strcmp(get(handles.rdbX(num),'Enable'),'on')
        set(handles.rdbX(num),'Value',~get(handles.rdbX(num),'Value'));
        %ex-rdbX_Callback
        setstr='';
        for i=1:n
            a(i)=get(handles.rdbX(i),'Value');
            if a(i)
                setstr=[setstr 'x' num2str(i)];
            end
        end
        set(handles.edtTerm,'String',setstr);
        %end ex-rdbX_Callback
    end
end
if any(ismember('xX??',key)) 
    setstrig=get(handles.edtTerm,'String');
    len=length(setstrig);
    if len==0 | (~strcmp('x',setstrig(len)) & len<2*n)
        set(handles.edtTerm,'String',[setstrig 'x']);
    end
end
if strcmp(key,'+')
    psbAdd_Callback(h, eventdata, handles)
end

% --------------------------------------------------------------------
function varargout = psbAdd_Callback(h, eventdata, handles, varargin)
n=handles.n;
[m o]=size(handles.Terms);
[p q]=size(handles.StringTerms);
B=[];
strB=[];
for i=1:n
    a(i)=get(handles.rdbX(i),'Value');
    if a(i)
        B=[B i];
        strB=[strB 'x' num2str(i)];
    end
end
if a==zeros(1,n)
    figure(handles.fgrBoole2)
    return
end
handles.Terms{m+1,1}=B;
handles.StringTerms{p+1,1}=strB;
guidata(gcbo,handles)
set(handles.lsbTerms,'String',handles.StringTerms);

psbUpdate_Callback(h, eventdata, handles)

set(handles.edtTerm,'String','');
set(handles.rdbX,'Value',0);
set(handles.lsbTerms,'Value',length(handles.StringTerms));
figure(handles.fgrBoole2)

% --------------------------------------------------------------------
function varargout = psbUpdate_Callback(h, eventdata, handles, varargin)
% Uses:     StringTerms,ckb1
% Affects:  psbConvertNow,edtConvert
tmpstr='f = ';
if length(handles.StringTerms)>=1
    set(handles.psbConvertNow,'Enable','on')
    set(handles.psbClearSelected,'Enable','on')
    set(handles.psbSimplify,'Enable','on')
    set(handles.txtClearTerms,'Enable','on')
    tmpstr=[tmpstr  handles.StringTerms{1}];
else
    set(handles.psbConvertNow,'Enable','off')
    set(handles.psbClearSelected,'Enable','off')
    set(handles.psbSimplify,'Enable','off')
    set(handles.txtClearTerms,'Enable','off')
end
for i=2:length(handles.StringTerms)
    tmpstr=[tmpstr ' + ' handles.StringTerms{i}];
end
ena=get(handles.ckb1,'Value');
if ena
    set(handles.psbConvertNow,'Enable','on')
    if length(handles.StringTerms)>=1
        tmpstr=[tmpstr ' + 1' ];
    else
        tmpstr='f = 1';
    end
end
set(handles.edtConvert,'String',tmpstr);
set(handles.lsbTerms,'String',handles.StringTerms);

% --------------------------------------------------------------------
function varargout = lsbTerms_Callback(h, eventdata, handles, varargin)
% Uses:     gcbo,Terms,StringTerms,psbUpdate
% Affects:  gcbo,Terms,StringTerms

a=get(handles.fgrBoole2,'SelectionType');
lsbTermsValue=get(gcbo,'Value');
if strcmp(a,'open') & ~isempty(handles.Terms)
    tmp=handles.Terms;
    strtmp=handles.StringTerms;
    tmp(lsbTermsValue)=[];
    strtmp(lsbTermsValue)=[];
    handles.Terms=[];
    handles.StringTerms=[];
    if lsbTermsValue>1 | length(tmp)>=1
        handles.Terms=tmp;
        handles.StringTerms=strtmp;
    end
    guidata(gcbo,handles);
    set(gcbo,'String',handles.StringTerms);
    if lsbTermsValue==1
        if isempty(handles.Terms)
            set(gcbo,'Value',0);
        else
            set(gcbo,'Value',1);
        end
    else
        set(gcbo,'Value',lsbTermsValue-1);
    end
    psbUpdate_Callback(h, eventdata, handles)
    guidata(gcbo,handles)
end
figure(handles.fgrBoole2)



% --------------------------------------------------------------------
function varargout = psbClearSelected_Callback(h, eventdata, handles, varargin)
lsbTermsValue=get(handles.lsbTerms,'Value');
if ~isempty(handles.Terms)
    tmp=handles.Terms;
    strtmp=handles.StringTerms;
    tmp(lsbTermsValue)=[];
    strtmp(lsbTermsValue)=[];
    handles.Terms=[];
    handles.StringTerms=[];
    if lsbTermsValue>1 | length(tmp)>=1
        handles.Terms=tmp;
        handles.StringTerms=strtmp;
    end
    guidata(gcbo,handles);
    set(handles.lsbTerms,'String',handles.StringTerms);
    if lsbTermsValue==1
        if isempty(handles.Terms)
            set(handles.lsbTerms,'Value',0);
        else
            set(handles.lsbTerms,'Value',1);
        end
    else
        set(handles.lsbTerms,'Value',lsbTermsValue-1);
    end
    psbUpdate_Callback(h, eventdata, handles)
    guidata(gcbo,handles)
end
figure(handles.fgrBoole2)




% --------------------------------------------------------------------
function varargout = ckb1_Callback(h, eventdata, handles, varargin)
% Uses:     psbUpdate
psbUpdate_Callback(h, eventdata, handles)
figure(handles.fgrBoole2)


% --------------------------------------------------------------------
function varargout = psbConvertNow_Callback(h, eventdata, handles, varargin)
% Uses:     n,psbSimplify,ckb1
% Affects:  X,F,no,txtConvertNow
n=handles.n;
m=2^n;
for i=1:m
    X(i,:)=dec2bin(i-1,n);
    handles.X=X;
end
if n~=0
    set(handles.lsbVariables,'String',X,'BackgroundColor',[0 0 0]);
    set(handles.txtf,'Visible','on');
    set(handles.txtPosition,'Visible','on','String',1);
    set(handles.lsbFunction,'BackgroundColor',[0 0 0]);
else
    set(handles.lsbVariables,'String','','BackgroundColor',[0.92 0.91 0.84]);
    set(handles.lsbFunction,'BackgroundColor',[0.92 0.91 0.84]);
    set(handles.txtf,'Visible','off');
    set(handles.txtPosition,'Visible','off');
end
for i=1:n
    set(handles.no(i),'Visible','on');
end
for i=n+1:9
    set(handles.no(i),'Visible','off');
end
set(handles.txtConvertNow,'String','Conversion in progress...');
handles.F=[];
guidata(gcbo,handles);
figsize=get(handles.fgrBoole2,'Position');
h=waitbar(0,'Applying function...');
set(h,'Position',[figsize(1)+(figsize(3)-135)/2 figsize(2)+(figsize(4)-30)/2 270 60])
lenhalX=length(handles.X);
lenhalTerms=length(handles.Terms);
if ~lenhalTerms
    TempInnerTerms=zeros(lenhalX,1);
end
t=clock;
for i=1:lenhalX
    waitbar(i/lenhalX)
    for j=1:lenhalTerms
        TempInnerTerms(j,1)=prod(str2num(handles.X(i,handles.Terms{j,1})'));
    end
    F(i,1)=mod(sum(TempInnerTerms),2);
end
et=etime(clock,t);
if get(handles.ckb1,'Value')
    F=~F;
end
handles.F=F;
set(handles.lsbFunction,'String',F,'BackgroundColor',[0 0 0]);
close(h)
set(handles.txtConvertNow,'String',['Done  (' num2str(floor(et/60)) ' min ' num2str(mod(et,60)) ' sec).']);
figure(handles.fgrBoole2)


% --------------------------------------------------------------------
function varargout = psbSimplify_Callback(h, eventdata, handles, varargin)
% Uses:     Terms,StringTerms,psbUpdate
% Affects:  Terms,StringTerms
B=handles.StringTerms;
C=handles.Terms;
[p q]=size(C);
if ~p
    return
end
for i=1:p
    if ~isempty(C{i,1})
        for j=i+1:p
            if length(C{i,1})==length(C{j,1}) & C{i,1}==C{j,1}
                C{j,1}=[];
                B{j,i}=[];
            end
        end
    end
end
D{1,1}=C{1,1};
d=2;
e=2;
E{1,1}=B{1,1};
for i=2:length(C)
    if ~isempty(C{i,1})
        D{d,1}=C{i,1};
        d=d+1;
        E{e,1}=B{i,1};
        e=e+1;
    end
end
handles.Terms=D;
handles.StringTerms=E;
guidata(gcbo,handles);
set(handles.lsbTerms,'String',handles.StringTerms,'Value',length(handles.StringTerms));
psbUpdate_Callback(h, eventdata, handles);
figure(handles.fgrBoole2)



% --------------------------------------------------------------------
function varargout = lsbVariables_Callback(h, eventdata, handles, varargin)
lsbVariablesValue=get(gcbo,'Value');
set(handles.txtPosition,'String',bin2dec(handles.X(lsbVariablesValue,:))+1);
top=get(gcbo,'ListboxTop');
set(handles.lsbFunction,'Value',lsbVariablesValue,'ListboxTop',top);

% --------------------------------------------------------------------
function varargout = lsbFunction_Callback(h, eventdata, handles, varargin)
lsbFunctionValue=get(gcbo,'Value');
set(handles.txtPosition,'String',bin2dec(handles.X(lsbFunctionValue,:))+1);
top=get(gcbo,'ListboxTop');
set(handles.lsbVariables,'Value',lsbFunctionValue,'ListboxTop',top);

% Context Menus  --------------------------------------------------------------------
% -----------------------------------------------------------------------------------
function varargout = cmnEdtConvertEnable_Callback(h, eventdata, handles, varargin)
strg=get(handles.cmnEdtConvertEnable,'Checked');
if strcmp(strg,'off')
    set(handles.cmnEdtConvertEnable,'Checked','on');
    set(handles.edtConvert,'Enable','on','BackgroundColor',[0 0 0],'ForegroundColor',[1 1 1]);
else
    set(handles.cmnEdtConvertEnable,'Checked','off');
    set(handles.edtConvert,'Enable','inactive','BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0]);
end

% -----------------------------------------------------------------------------------
function varargout = edtConvert_Callback(h, eventdata, handles, varargin)
a=get(gcbo,'String');
b=a(findstr(a,'=')+1:length(a));
b=strrep(b,' ','');
figsize=get(handles.fgrBoole2,'Position');
h=waitbar(0,'Compiling string...');
set(h,'Position',[figsize(1)+(figsize(3)-135)/2 figsize(2)+(figsize(4)-30)/2 270 60])
if isempty(b)
    close(h)
    return
elseif strcmp(b,'1')|strcmp(b,'+1')
    set(handles.ckb1,'Value',1);
    close(h)
    return
else
    syn_positions=findstr(b,'+');
    plithos_orwn=length(syn_positions)+1;
    stringoros=[];
    arxi=1;
    for i=1:plithos_orwn-1
        stringoros{i,1}=b(arxi:syn_positions(i)-1);
        arxi=syn_positions(i)+1;
    end
    if strcmp(b(syn_positions(length(syn_positions))+1:length(b)),'1')
        set(handles.ckb1,'Value',1);
    else
        stringoros{plithos_orwn,1}=b(syn_positions(length(syn_positions))+1:length(b));
    end
    lnoros=length(stringoros);
    for i=1:lnoros
        waitbar(i/lnoros)
        for j=1:length(stringoros{i,1})
            if ~ismember('xX+*123456789',stringoros{i,1}(j))
                set(handles.edtTerm,'String',[stringoros{i,1} ' ?'])
                return
            end
        end
        if ~isempty(findstr(stringoros{i,1},'x'))
            stringoros{i,1}=strrep(stringoros{i,1},'x','');
            stringoros{i,1}=strrep(stringoros{i,1},'*','');
        elseif ~isempty(findstr(stringoros{i,1},'1'))
            set(handles.ckb1,'Value',~get(handles.ckb1,'Value'));
        else
            set(handles.edtTerm,'String',[stringoros{i,1} ' ?'])
            return
        end
    end
    close(h)
    h=waitbar(0,'Adding terms to list...');
    set(h,'Position',[figsize(1)+(figsize(3)-135)/2 figsize(2)+(figsize(4)-30)/2 270 60])
    numoros=[];
    stringtermsoros=[];
    for i=1:lnoros
        waitbar(i/lnoros)
        strB='';
        for j=1:length(stringoros{i,1})
            numoros{i,1}(j)=str2num(stringoros{i,1}(j));
            strB=[strB 'x' stringoros{i,1}(j)];
        end
        stringtermsoros{i,1}=strB;
    end
    close(h)
    handles.Terms=numoros;
    handles.StringTerms=stringtermsoros;
    guidata(gcbo,handles);

    set(handles.lsbTerms,'String',handles.StringTerms,'Value',length(handles.StringTerms));
    
    if length(handles.StringTerms)>=1
        set(handles.psbConvertNow,'Enable','on')
        set(handles.psbClearSelected,'Enable','on')
        set(handles.psbSimplify,'Enable','on')
        set(handles.txtClearTerms,'Enable','on')
    else
        set(handles.psbConvertNow,'Enable','off')
        set(handles.psbClearSelected,'Enable','off')
        set(handles.psbSimplify,'Enable','off')
        set(handles.txtClearTerms,'Enable','off')
    end
end
set(handles.cmnEdtConvertEnable,'Checked','on');
cmnEdtConvertEnable_Callback(h, eventdata, handles);



% --------------------------------------------------------------------
function varargout = rdbX_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = psbExit_Callback(h, eventdata, handles, varargin)
delete(handles.fgrBoole2)



