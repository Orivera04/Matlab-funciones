function varargout = boole(varargin)
% BOOLE Application M-file for boole.fig
%    FIG = BOOLE launch boole GUI.
%    BOOLE('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 04-May-2003 14:44:52

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');
    movegui(fig,'center');    
	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
    handles.F=[];
    handles.X=[];
    handles.n=0;

    handles.computedF=[];
    handles.simplifiedF=[];
    handles.stringoutputF='';
    
    guidata(fig, handles);
    set(handles.cmnProperties,'Enable','off')
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
% Stub for Callback of the uicontrol handles.popupmenu1.
set(handles.lsbVariables,'Value',1);
set(handles.lsbFunction,'Value',1);
set(handles.txtConvertNow,'String','');
set(handles.edtConvert,'String','','BackgroundColor',[0.92 0.91 0.84]);
set(handles.txtConvertNow,'String','','BackgroundColor',[0.92 0.91 0.84]);
set(handles.cmnProperties,'Enable','off','Label',['Function' char(39) 's Properties']);
set(handles.cmnShowOperant,'Enable','on');
set(handles.cmnUnsimplified,'Enable','on');
n=get(gcbo,'Value')-1;
handles.n=n;
m=2^n;
for i=1:m
    X(i,:)=dec2bin(i-1,n);
    handles.X=X;
end
if n~=0
    set(handles.lsbVariables,'String',X);
    set(handles.txtf,'Visible','on');
    set(handles.txtPosition,'Visible','on','String',1);
    set(handles.psbInverseAll,'Enable','on');
    set(handles.psbInverseSel,'Enable','on');
    set(handles.psbConvertNow,'Enable','on');
    set(handles.txtInverse,'Enable','on');
    handles.F=zeros(m,1);
else
    set(handles.lsbVariables,'String','');
    set(handles.txtf,'Visible','off');
    set(handles.txtPosition,'Visible','off');
    set(handles.psbInverseAll,'Enable','off');
    set(handles.psbInverseSel,'Enable','off');
    set(handles.psbConvertNow,'Enable','off');
    set(handles.txtInverse,'Enable','off');
    handles.F=[];
end
handles.computedF=[];
handles.simplifiedF=[];
handles.stringoutputF='';
guidata(gcbo,handles);
set(handles.lsbFunction,'String',handles.F);
for i=1:n
    set(handles.no(i),'Visible','on');
end
for i=n+1:9
    set(handles.no(i),'Visible','off');
end
% --------------------------------------------------------------------
function varargout = lsbVariables_Callback(h, eventdata, handles, varargin)
a=get(handles.figure1,'SelectionType');
lsbVariablesValue=get(gcbo,'Value');
set(handles.txtPosition,'String',bin2dec(handles.X(lsbVariablesValue,:))+1);
top=get(gcbo,'ListboxTop');
if strcmp(a,'open')
    tmp=handles.F(lsbVariablesValue);
    handles.F(lsbVariablesValue)= ~tmp;
    guidata(gcbo,handles);
    set(handles.lsbFunction,'String',handles.F);
    set(handles.lsbFunction,'Value',lsbVariablesValue,'ListboxTop',top);
    set(handles.cmnProperties,'Enable','off','Label',['Function' char(39) 's Properties']);
    set(handles.cmnShowOperant,'Enable','off');
    set(handles.cmnUnsimplified,'Enable','off');
end
set(handles.lsbFunction,'Value',lsbVariablesValue,'ListboxTop',top);

% --------------------------------------------------------------------
function varargout = lsbFunction_Callback(h, eventdata, handles, varargin)
a=get(handles.figure1,'SelectionType');
lsbFunctionValue=get(gcbo,'Value');
set(handles.txtPosition,'String',bin2dec(handles.X(lsbFunctionValue,:))+1);
top=get(gcbo,'ListboxTop');
if strcmp(a,'open')
    tmp=handles.F(lsbFunctionValue);
    handles.F(lsbFunctionValue)= ~tmp;
    guidata(gcbo,handles);
    set(gcbo,'String',handles.F,'ListboxTop',top);
    set(handles.lsbVariables,'Value',lsbFunctionValue,'ListboxTop',top);
    set(handles.cmnProperties,'Enable','off','Label',['Function' char(39) 's Properties']);
    set(handles.cmnShowOperant,'Enable','off');
    set(handles.cmnUnsimplified,'Enable','off');
end
set(handles.lsbVariables,'Value',lsbFunctionValue,'ListboxTop',top);



% --------------------------------------------------------------------
function varargout = psbInverseAll_Callback(h, eventdata, handles, varargin)
handles.F=~handles.F;
guidata(gcbo,handles);
top=get(handles.lsbFunction,'ListboxTop');
set(handles.lsbFunction,'String',handles.F,'ListboxTop',top);
set(handles.lsbVariables,'ListboxTop',top);
set(handles.cmnProperties,'Enable','off','Label',['Function' char(39) 's Properties']);
set(handles.cmnShowOperant,'Enable','off');
set(handles.cmnUnsimplified,'Enable','off');


% --------------------------------------------------------------------
function varargout = psbInverseSel_Callback(h, eventdata, handles, varargin)
a=get(handles.lsbFunction,'Value');
top=get(handles.lsbFunction,'ListboxTop');
handles.F(a)=~handles.F(a);
guidata(gcbo,handles);
set(handles.lsbFunction,'String',handles.F,'ListboxTop',top);
set(handles.lsbVariables,'ListboxTop',top);
set(handles.cmnProperties,'Enable','off','Label',['Function' char(39) 's Properties']);
set(handles.cmnShowOperant,'Enable','off');
set(handles.cmnUnsimplified,'Enable','off');



% --------------------------------------------------------------------
function varargout = edtConvert_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = psbConvertNow_Callback(h, eventdata, handles, varargin)
set(handles.txtConvertNow,'String','Conversion in progress...');
handles.computedF=[];
handles.simplifiedF=[];
handles.stringoutputF='';
guidata(gcbo,handles);
psbStep1_Callback(h, eventdata, handles)

% --------------------------------------------------------------------
function varargout = psbStep1_Callback(h, eventdata, handles, varargin)
tmp=handles.X(find(handles.F),:);
if isempty(tmp)
    handles.stringoutputF='f = 0';
    guidata(gcbo,handles);
    set(handles.edtConvert,'String',handles.stringoutputF,'BackgroundColor',[0 0 0]);
    set(handles.txtConvertNow,'String','Done.');
    return
end
set(handles.edtConvert,'String','','BackgroundColor',[0.92 0.91 0.84]);
[m o]=size(tmp);
if o==1
    if m==1
        A=product('0',1,'1',str2num(tmp(1,1)));
        handles.computedF=A;
        guidata(gcbo,handles);
        psbStep2_Callback(h, eventdata, handles)
        return
    else
        handles.stringoutputF='f = 1';
    end
    guidata(gcbo,handles);
    set(handles.edtConvert,'String',handles.stringoutputF,'BackgroundColor',[0 0 0]);
    set(handles.txtConvertNow,'String','Done.');
    return
end    
B=[];
figsize=get(handles.figure1,'Position');
h=waitbar(0,'Computing products in non-zero states...');
set(h,'Position',[figsize(1)+(figsize(3)-135)/2 figsize(2)+(figsize(4)-30)/2 270 60])
for i=1:m
    A=product('0',1,'1',str2num(tmp(i,1)));
    for j=2:o
        waitbar(i/(2*m)+j/(2*o))
        [p q]=size(A);
        B=[];
        for k=1:p
            B=[B ; product(num2str(j),str2num(tmp(i,j)),A{k,1},str2num(A{k,2}))];
        end
        clear A;
        A=B;
    end
    C=handles.computedF;
    handles.computedF=[C ; B];
    guidata(gcbo,handles);
    clear A,C;
end
close(h) 
psbStep2_Callback(h, eventdata, handles)

% --------------------------------------------------------------------
function varargout = psbStep2_Callback(h, eventdata, handles, varargin)
C=handles.computedF;
[p q]=size(handles.computedF);
D{1}=C{1};
d=2;
figsize=get(handles.figure1,'Position');
h=waitbar(1/p,'Simplifying function...');
set(h,'Position',[figsize(1)+(figsize(3)-135)/2 figsize(2)+(figsize(4)-30)/2 270 60])
for i=2:p
    waitbar(i/p)
    flag='1';
    for j=1:length(D)
        if strcmp(D{j},C{i}) & strcmp(flag,'1')
            D{j}=[];
            flag='0';
        end
    end
    if strcmp(flag,'1')
        D{d}=C{i};
        d=d+1;
    end
end
D=D';
e=1;
for i=1:length(D)
    if ~isempty(D{i})
        E{e}=D{i};
        e=e+1;
    end
end
close(h) 
handles.simplifiedF=E';
guidata(gcbo,handles);
psbStep3_Callback(h, eventdata, handles)

% --------------------------------------------------------------------
function varargout = psbStep3_Callback(h, eventdata, handles, varargin)
handles.stringoutputF='';
if strcmp(get(handles.cmnUnsimplified,'Checked'),'off')
    D=handles.simplifiedF;
else
    D=handles.computedF;
end
outputstring='f = ';
figsize=get(handles.figure1,'Position');
h=waitbar(0,['Shaping function' char(39) 's output string...']);
set(h,'Position',[figsize(1)+(figsize(3)-135)/2 figsize(2)+(figsize(4)-30)/2 270 60])
[lngtD nothing]=size(D);
for i=lngtD:-1:1
    for j=length(D{i}):-1:1
        waitbar(1-(i/lngtD))
        if strcmp(D{i}(j),'0')
            outputstring=[outputstring '1'];
        else
            if strcmp(get(handles.cmnShowOperant,'Checked'),'off')
                outputstring=[outputstring 'x' D{i}(j)];
            else
                if j>1
                    outputstring=[outputstring 'x' D{i}(j) '*'];
                else
                    outputstring=[outputstring 'x' D{i}(j)];
                end
            end
        end
    end
    if i>1
        outputstring=[outputstring ' + '];
    end
end
close(h)
handles.stringoutputF=outputstring;
guidata(gcbo,handles);
a=handles.stringoutputF;
set(handles.edtConvert,'String',a,'BackgroundColor',[0 0 0])
set(handles.txtConvertNow,'String','Done.');
set(handles.cmnProperties,'Enable','on','Label',['Function' char(39) 's Properties']);
set(handles.cmnShowOperant,'Enable','on');
set(handles.cmnUnsimplified,'Enable','on');


% Context Menus  --------------------------------------------------------------------
% -----------------------------------------------------------------------------------
function varargout = cmnArial_Callback(h, eventdata, handles, varargin)
set(handles.edtConvert,'FontName','Arial');
set(handles.cmnArial,'Checked','on')
set(handles.cmnArialNarrow,'Checked','off')
set(handles.cmnCourier,'Checked','off')
set(handles.cmnMSSansSerif,'Checked','off')

function varargout = cmnArialNarrow_Callback(h, eventdata, handles, varargin)
set(handles.edtConvert,'FontName','Arial Narrow');
set(handles.cmnArial,'Checked','off')
set(handles.cmnArialNarrow,'Checked','on')
set(handles.cmnCourier,'Checked','off')
set(handles.cmnMSSansSerif,'Checked','off')

function varargout = cmnCourier_Callback(h, eventdata, handles, varargin)
set(handles.edtConvert,'FontName','Courier');
set(handles.cmnArial,'Checked','off')
set(handles.cmnArialNarrow,'Checked','off')
set(handles.cmnCourier,'Checked','on')
set(handles.cmnMSSansSerif,'Checked','off')

function varargout = cmnMSSansSerif_Callback(h, eventdata, handles, varargin)
set(handles.edtConvert,'FontName','MS Sans Serif');
set(handles.cmnArial,'Checked','off')
set(handles.cmnArialNarrow,'Checked','off')
set(handles.cmnCourier,'Checked','off')
set(handles.cmnMSSansSerif,'Checked','on')


function varargout = cmn9_Callback(h, eventdata, handles, varargin)
set(handles.edtConvert,'FontSize',9);
set(handles.cmn9,'Checked','on')
set(handles.cmn10,'Checked','off')
set(handles.cmn12,'Checked','off')
set(handles.cmn14,'Checked','off')
set(handles.cmnOther,'Checked','off')

function varargout = cmn10_Callback(h, eventdata, handles, varargin)
set(handles.edtConvert,'FontSize',10);
set(handles.cmn9,'Checked','off')
set(handles.cmn10,'Checked','on')
set(handles.cmn12,'Checked','off')
set(handles.cmn14,'Checked','off')
set(handles.cmnOther,'Checked','off')

function varargout = cmn12_Callback(h, eventdata, handles, varargin)
set(handles.edtConvert,'FontSize',12);
set(handles.cmn9,'Checked','off')
set(handles.cmn10,'Checked','off')
set(handles.cmn12,'Checked','on')
set(handles.cmn14,'Checked','off')
set(handles.cmnOther,'Checked','off')

function varargout = cmn14_Callback(h, eventdata, handles, varargin)
set(handles.edtConvert,'FontSize',14);
set(handles.cmn9,'Checked','off')
set(handles.cmn10,'Checked','off')
set(handles.cmn12,'Checked','off')
set(handles.cmn14,'Checked','on')
set(handles.cmnOther,'Checked','off')

function varargout = cmnOther_Callback(h, eventdata, handles, varargin)
prompt  = {'Enter font size:'};
title   = 'Other';
lines= 1;
answer  = inputdlg(prompt,title,lines);
if isempty(answer)
    return
else
    set(handles.edtConvert,'FontSize',eval(answer{1}));
    set(handles.cmn9,'Checked','off')
    set(handles.cmn10,'Checked','off')
    set(handles.cmn12,'Checked','off')
    set(handles.cmn14,'Checked','off')
    set(handles.cmnOther,'Checked','on')
end

function varargout = cmnShowOperant_Callback(h, eventdata, handles, varargin)
if strcmp(get(handles.cmnShowOperant,'Checked'),'off')
    set(handles.cmnShowOperant,'Checked','on')
else
    set(handles.cmnShowOperant,'Checked','off')
end
if isempty(handles.computedF)
    return
end
set(handles.cmnProperties,'Label',['Function' char(39) 's Properties']);
psbStep3_Callback(h, eventdata, handles)

function varargout = cmnUnsimplified_Callback(h, eventdata, handles, varargin)
if strcmp(get(handles.cmnUnsimplified,'Checked'),'off')
    set(handles.cmnUnsimplified,'Checked','on')
else
    set(handles.cmnUnsimplified,'Checked','off')
end
if isempty(handles.computedF)
    return
end
set(handles.cmnProperties,'Label',['Function' char(39) 's Properties']);
psbStep3_Callback(h, eventdata, handles)

function varargout = cmnProperties_Callback(h, eventdata, handles, varargin)
lbl=get(gcbo,'Label');
if strcmp(lbl,'Function')
    set(gcbo,'Label',['Function' char(39) 's Properties']);
    psbStep3_Callback(h, eventdata, handles)
else
    set(gcbo,'Label','Function');
    psbProperties_Callback(h, eventdata, handles)
end

function varargout = cmnedtConvertEnable_Callback(h, eventdata, handles, varargin)
strg=get(handles.cmnedtConvertEnable,'Checked');
if strcmp(strg,'off')
    set(handles.cmnedtConvertEnable,'Checked','on');
    set(handles.edtConvert,'Enable','on');
else
    set(handles.cmnedtConvertEnable,'Checked','off');
    set(handles.edtConvert,'Enable','inactive');
end
% End Context Menus  ----------------------------------------------------------------
% -----------------------------------------------------------------------------------


% --------------------------------------------------------------------
function varargout = psbProperties_Callback(h, eventdata, handles, varargin)
X=handles.X;
F=handles.F;
if isempty(F)
    return
end
n=handles.n;
m=2^n;
lincombs{1,1}=0;
N{1,1}=bitxor(zeros(m,1),F);
weightN(1,1)=length(find(N{1,1}));

figsize=get(handles.figure1,'Position');
h=waitbar(0,['Determining function' char(39) 's properties...']);
set(h,'Position',[figsize(1)+(figsize(3)-135)/2 figsize(2)+(figsize(4)-30)/2 270 60])

for i=2:m
    waitbar(i/m)
    lincombs{i,1}=findstr(X(i,:),'1');
    lcandresult=str2num(X(:,lincombs{i,1}(1)));
    szlncmbs=size(lincombs{i,1});
    for j=2:szlncmbs(2)
        lcandresult=bitxor(lcandresult , str2num(X(:,lincombs{i,1}(j))));
    end
    N{i,1}=bitxor(lcandresult,F);
    weightN(i,1)=length(find(N{i,1}));
end
close(h)
message1='> Function is ';
if weightN(1,1)~=length(find(~N{1,1}))
    message1=[message1 'not '];
end
message1=[message1 'balanced.'];
message2=['> Function' char(39) 's nonlinearity:'];
message3=['  N(F) = ' num2str(min(weightN(2:length(weightN),1)))];
terms=handles.simplifiedF;
lenterms=length(terms);
for i=1:lenterms
    order(i,1)=length(terms{i,1});
end
message4=['> Order of nonlinearity:'];
message5=['  O(N) = ' num2str(max(order))];

outputstring{1,1}='';

outputstring{2,1}='';
outputstring{3,1}='';
outputstring{4,1}=message1;
outputstring{5,1}='';
outputstring{6,1}=message2;
outputstring{7,1}=message3;
outputstring{8,1}='';
outputstring{9,1}=message4;
outputstring{10,1}=message5;
set(handles.edtConvert,'String',outputstring,'BackgroundColor',[0 0 0])
set(handles.txtConvertNow,'String','Properties:');






































% --------------------------------------------------------------------
function A=product(x,i,y,j)
if strcmp(x,'0')
    if i==1
        if j==1
            A(1,1)={y};
            A(1,2)={'1'};
        elseif j==0
            A(1,1)={'0'};
            A(1,2)={'1'};
            A(2,1)={y};
            A(2,2)={'1'};
        else
            disp('In a product operation, the index of second term must be 0 or 1')
        end
    else
        disp('The index of the zero element must be 1')
    end
    return
end
if strcmp(y,'0')
    if j==1
        if i==1
            A(1,1)={x};
            A(1,2)={'1'};
        elseif i==0
            A(1,1)={'0'};
            A(1,2)={'1'};
            A(2,1)={x};
            A(2,2)={'1'};
        else
            disp('In a product operation, the index of second term must be 0 or 1')
        end
    else
        disp('The index of the zero element must be 1')
    end
    return
end
if i&j
    A(1,1)={[x y]};
    A(1,2)={'1'};
elseif ~(i|j)
    A(1,1)={'0'};
    A(1,2)={'1'};
    A(2,1)={x};
    A(2,2)={'1'};
    A(3,1)={y};
    A(3,2)={'1'};
    A(4,1)={[x y]};
    A(4,2)={'1'};
else %if xor(i,j)
    if i==1
        A(1,1)={x};
        A(1,2)={'1'};
        A(2,1)={[x y]};
        A(2,2)={'1'};
    elseif j==1
        A(1,1)={y};
        A(1,2)={'1'};
        A(2,1)={[x y]};
        A(2,2)={'1'};
    else
        disp('In a product operation, the non-zero index of a term must be 1')
    end
end





% --------------------------------------------------------------------
function varargout = psbExit_Callback(h, eventdata, handles, varargin)
delete(handles.figure1)

