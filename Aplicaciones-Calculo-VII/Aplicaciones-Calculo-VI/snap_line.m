function snap_line(line_obj,var)

%Version 1.0
%Created by Lior Cohen, March 24, 2005.
%
%Snaps the 2D line object LINE_OBJ to one of the following constraints -
%a. Other set of lines.
%b. Defined grid.
%c. Mouse cursor (no constraint).
%
% snap_line(line_obj);
% snap_line(line_obj,'on');
% snap_line(line_obj,'off');
% snap_line(line_obj,setup);
%
% setup - 
% enable [on,{off}]
% snap_to [{none}, grid, line]
% grid {[1,1]}
% line {[]}
%
%Example - 
%
% fig=figure('position',[100,100,500,600]);
% subplot(3,1,1);
% h1=plot(10*rand(10,2),'.-');
% hold on;
% h2=plot(2,2,'r*','markersize',10);
% s=struct('snap_to','line','enable','on','line',h1);
% snap_line(h2,s);
% grid on;
% title('Snap red marker to lines example');
% 
% subplot(3,1,2);
% h3=plot(10*rand(10,1),'o-');
% s=struct('snap_to','grid','enable','on','grid',[2,2]);
% snap_line(h3,s);
% grid on;
% title('Snap line to [2,2] grid example');
% %
% subplot(3,1,3);
% h4=plot(10*rand(10,1),'*-');
% s=struct('snap_to','none');
% snap_line(h4,s);
% grid on;
% title('Snap line to mouse position example');

def_setup=struct('enable','on','snap_to','none','grid',[1,1],'line',[]);

if     ~ishandle(line_obj)   error('line_obj must be an line object handle'); end
if      ~strcmp(get(line_obj,'type'),'line') error('line_obj must be an line object handle'); end
if      length(line_obj)>1, error('line_obj length must be 1');    end
%
if nargin==1
    handles=def_setup;
    handles.line_obj=line_obj;
    guidata(line_obj,handles);   
    set(line_obj,'ButtonDownFcn',{@DownFcn,handles});
elseif nargin==2 & isstr(var) & ismember(lower(var),{'on','off'})
    handles=def_setup;
    handles.enable=var;
    handles.line_obj=line_obj;
    guidata(line_obj,handles);   
    switch handles.enable
        case 'on'
            set(line_obj,'ButtonDownFcn',{@DownFcn,handles});
        case 'off'
            set(line_obj,'ButtonDownFcn','');
    end
    
elseif nargin==2 & isstruct(var)
    if ~all(ismember(fieldnames(var),{'snap_to','enable','grid','line'}))
        error('wrong structure field names');
    end
    handles=struct_union(var,def_setup);
    handles.line_obj=line_obj;
    handles.ax=get(line_obj,'parent');
    
    guidata(line_obj,handles);   
    switch handles.enable
        case 'on'
            set(line_obj,'ButtonDownFcn',{@DownFcn,handles});
        case 'off'
            set(line_obj,'ButtonDownFcn','');
    end
end


switch lower(handles.snap_to)
    case 'line'
        if isempty(handles.line) | ~ishandle(handles.line)
            error('line field must contain line handles');
        end
        if ~strcmp(get(handles.line,'type'),'line')
            error('line field must contain line handles');
        end
    case 'grid'
        if ~(length(handles.grid==2) & isnumeric(handles.grid))
            error('grid field must contain 2 element numeric vector');
        end
end
%--------------------------------------------------------------------------
function DownFcn(line_obj,eventdata,handles,varargin)

handles.line_obj=line_obj;
handles.oldMotionFcn=get(gcbf,'WindowButtonMotionFcn');
handles.oldUpFcn=get(gcbf,'WindowButtonUpFcn');
handles.DBuffer=get(gcbf,'DoubleBuffer');
%
set(gcbf,'DoubleBuffer','On');
p=get(handles.ax,'currentpoint');
p=p([1,3]);
x=get(line_obj,'xdata'); dx=x(:)-p(1);
y=get(line_obj,'ydata'); dy=y(:)-p(2);
r=dx.^2+dy.^2;
[tmp,ix]=min(r);
handles.ix=ix;
%
guidata(line_obj,handles);
%
set(gcbf,'WindowButtonMotionFcn',{@MotionFcn,handles});
set(gcbf,'WindowButtonUpFcn',{@UpFcn,handles});

%--------------------------------------------------------------------------
function MotionFcn(h,eventdata,handles,varargin)

ix=handles.ix;
p=get(handles.ax,'currentpoint');
p=p([1,3]);
switch lower(handles.snap_to)
    case 'none'
        %nothing
    case 'grid'
        p=round(p./handles.grid).*handles.grid;
    case 'line'
        x=get(handles.line,'xdata'); if iscell(x), x=[x{:}]; end, dx=x-p(1);
        y=get(handles.line,'ydata'); if iscell(y), y=[y{:}]; end, dy=y-p(2);
        r=dx.^2+dy.^2;
        [tmp,i]=min(r);
        p=[x(i),y(i)];
    end
    %
    xdata=get(handles.line_obj,'xdata');
    ydata=get(handles.line_obj,'ydata');
    xdata(ix)=p(1);
    ydata(ix)=p(2);
    set(handles.line_obj,'xdata',xdata,'ydata',ydata);
    
    %--------------------------------------------------------------------------
    function UpFcn(h,eventdata,handles,varargin)
    set(gcbf,'WindowButtonMotionFcn',handles.oldMotionFcn);
    set(gcbf,'WindowButtonUpFcn',handles.oldUpFcn);
    set(gcbf,'DoubleBuffer',handles.DBuffer);
    
    %--------------------------------------------------------------------------
    function s=struct_union(s1,s2)
    %s=struct_union(s1,s2)
    %s1 is override s2;
    
    f1=fieldnames(s1);  c1=struct2cell(s1);
    f2=fieldnames(s2);  c2=struct2cell(s2);
    %
    [f,i2,i1]=union(f2,f1);
    f1=f1(i1);  c1=c1(i1);
    f2=f2(i2);  c2=c2(i2);
    %
    f=[f1;f2];  c=[c1;c2];
    [f,i]=sort(f);
    c=c(i);
    s=cell2struct(c,f);