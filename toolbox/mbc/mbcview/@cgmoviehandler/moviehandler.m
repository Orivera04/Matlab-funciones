function varargout = moviehandler(obj,varargin)
%MOVIEHANDLER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:24:35 $

obj = get(obj.objstore,'userdata'); %get up-to-date version
action = varargin{1};

switch lower(action)
case 'set_datadisplay'
    obj.datadisplay = varargin{2};
    set(obj.objstore,'UserData',obj);
    if isempty(obj.datadisplay)
        arg = i_Visible(obj,'off');
    else
        arg = i_NewDisplay(obj);
    end
    varargout{1} = arg;
    set(obj.ReplayMovie,'enable','off');
case 'visible'
    i_Visible(obj,varargin{2},'callback');
case {'off','on'}
    obj.off = strcmp(action,'off');
    set(obj.objstore,'UserData',obj);
    i_Visible(obj,action);
case 'close'
    if ~isempty(obj.child)
        moviehandler(obj.child,'resume_control');
    end
case 'handle_radio'
    i_HandleRadio(obj);
case 'make_movie'
    if nargin>2 
        if ischar(varargin{2})
            set(obj.B1,'enable',varargin{2});
        end
    else
        i_MakeMovie(obj);
    end
case 'stop_movie'
    i_StopMovie(obj);
case 'replay_movie'
    i_ReplayMovie(obj);
case 'clear_replay'
    set(obj.ReplayMovie,'enable','off');
case 'input_click'
    i_InputClick(obj,varargin{2});
end

%------------------------------------------------------------------------
function i_InputClick(obj,num)
%------------------------------------------------------------------------
val = get(obj.InputList,'value');
this_val = val{num};
new_val = this_val{2};
list_fac = get(obj.InputList,'userdata');
pi = get(obj.datadisplay,'plotinfo');
da = get(obj.datadisplay , 'datastore');
op = get(da,'op_infactordata');
if num>1
    new_val = new_val - 1;
end
if new_val>0
    fact_i = list_fac(new_val);
else
    fact_i = [];
end

filter = op.filter;
%ptrlist = op.ptrlist;
if ~isempty(fact_i)
    old = filter(fact_i);
else
    old = 2;
end
old_i = find(filter>2 & mod(filter,3)==num-1);
if ~isempty(fact_i)
    filter(fact_i) = num + 2;   % set to axis
end
if ~isempty(old_i)
    filter(old_i) = old;    %swap old factor
end
op = set(op,'filter',filter);
cg_dialup('Redraw_Controls',op);
%i_NewDisplay(obj); %update display (may need to enable movies)
%plot(obj.datadisplay);

%------------------------------------------------------------------------
function i_HandleRadio(obj)
%------------------------------------------------------------------------
[i,j] = find(obj.Radio==gco);

matrix=get(obj.Radio , 'value');
matrix=reshape(matrix,3,3);
matrix=i_Cell2Mat(matrix);

old_row=find(matrix(:,j)==1);
old_row=setdiff(old_row,i);

vec=[1 2 3];

if get(obj.Radio(i,j) , 'value') == 0
   set(obj.Radio(i,j) , 'value' , 1);
   return
else
   %Set the others in the same column to be off.
   indx=setdiff(vec,i);
   set(obj.Radio(indx,j) , 'value' , 0);
   %Now, find which entry on the same row as old_row == 1, and set it to zero, and set the
   %one on the gco row to zero.
   indx=find(matrix(i,:)==1);
   indx=setdiff(indx,j);
   set(obj.Radio(old_row,indx) , 'value' , 1);
   set(obj.Radio(i,indx) , 'value' , 0);
   set(obj.ReplayMovie,'enable','off');
   set(obj.datadisplay,'movie','clear');
   axes_ind = i_Radio2Index(obj);
   i_MovieControls(obj,axes_ind); %update 'numframes' display
   set(obj.datadisplay,'axes_ind',axes_ind);
end

%------------------------------------------------------------------------
function out = i_Radio2Index(obj)
%------------------------------------------------------------------------
matrix=get(obj.Radio , 'value');
matrix=reshape(matrix,3,3);
matrix=i_Cell2Mat(matrix);
i1=find(matrix(:,1)==1);
i2=find(matrix(:,2)==1);
i3=find(matrix(:,3)==1);
i = [i1 i2 i3];
%if length(i)~=3
%    i = 1:3;
%end
if nargout>0
    out = i;
end

%-------------------------------------------------------------------
function m=i_Cell2Mat(c)
%-------------------------------------------------------------------
elements = prod(size(c));

if elements == 1
   m = c{1};
   return
end

if elements == 0
   m = [];
   return
end

[rows,cols] = size(c);

if (cols == 1)
   m = cell(1,rows);
   for i=1:rows
      m{i} = [c{i}]';
   end
   m = [m{:}]';
   
else
   m = cell(1,rows);
   for i=1:rows
      m{i} = [c{i,[1:cols]}]';
   end
   m = [m{1,[1:rows]}]';
end

%-------------------------------------------------------------------
function i_MakeMovie(obj)
%-------------------------------------------------------------------
set(obj.Figure , 'pointer' , 'watch');
par = obj.Figure;   
closeReq = get(par , 'closerequestfcn');
set(par , 'closerequestfcn' , '');
closebutton = findobj(par,'tag','close');
if ~isempty(closebutton)
    set(closebutton , 'callback' , '');
end
cb = get(obj.B1,'callback');
cb1 = cb; cb1(end-11:end-8) = 'stop';
set(obj.B1,'string','Stop','callback',cb1);
%make movie
set(obj.datadisplay,'movie','clear_stop');
plot(obj.datadisplay,'movie');
set(obj.B1,'string','Make Movie','callback',cb);

set(par , 'closerequestfcn' , closeReq);
if ~isempty(closebutton)
    set(closebutton, 'callback', closeReq);
end
    if ishandle(obj.Figure)
        set(obj.Figure , 'pointer' , 'arrow');
    end
if ishandle(obj.ReplayMovie)  %May have closed the window while making a movie
    set(obj.ReplayMovie , 'enable' , 'on');
end

%-------------------------------------------------------------------
function i_StopMovie(obj)
%-------------------------------------------------------------------
% sets a flag in datadisplay plotinfo;
%  this is detected in plot routine, then control
%  returns to makemovie when plot exits.
set(obj.datadisplay,'movie','stop');

%-------------------------------------------------------------------
function i_ReplayMovie(obj)
%-------------------------------------------------------------------
playmovie(obj.datadisplay);

%------------------------------------------------------------------------
function arg = i_NewDisplay(obj);
%------------------------------------------------------------------------
da = get(obj.datadisplay , 'datastore');
names = get(da , 'vectornames');
Vecs = get(da,'vectors');

op = get(da,'op_infactordata');
if ~isempty(op)
    % dataset present - show selector
    show_selector = 1;
    filter = get(op,'filter');
    axes_fac = find(filter>=3);
    if any(filter>=9)
        list_fac = find(filter>=0);
    else
        list_fac = find(filter>=2);
    end
    dim = length(find((filter>=3 & filter<=5) | (filter>=9 & filter<=11)));
    names = op.factors;
    List = names(list_fac);
    range = op.range;
    frames = [];
    for i = 1:length(list_fac)
        frames(i) = length(range{list_fac(i)});
    end
    if length(list_fac)>1
        if dim<3
            arg = 'onlist_nomovie';
        else
            arg = 'onlist';
        end
    else
        arg = 'off';
    end
    arg2 = filter;
else
    show_selector = 0;
    dim = get(da,'dimension',0);
    axes_ind = 1:dim;
    i_SetAxes(obj,axes_ind);
    set(obj.datadisplay,'axes_ind',axes_ind,'noreplot',1);
    List = [];
    frames = [];
    list_fac = [];
    if (dim==3)
        arg = 'on';
    else
        arg = 'off';
    end
    arg2 = axes_ind;
end
obj.display = struct('disptype',arg,'names',{names},'Vecs',{Vecs},...
    'List',{List},'frames',[frames],'list_fac',[list_fac]);
set(obj.objstore,'UserData',obj);
arg = i_MovieControls(obj,arg2);

%------------------------------------------------------------------------
function arg = i_MovieControls(obj,arg2);
%------------------------------------------------------------------------

arg = i_Visible(obj,obj.display.disptype);
switch lower(obj.display.disptype)
case {'visible' ; 'on'; 'on2d'}
    names = obj.display.names;
    Vecs = obj.display.Vecs;
    axes_ind = arg2;
    for i = 1:3
        add = '';
        if i==axes_ind(3)
            numframes = length(Vecs{i});
            add = [' (' num2str(numframes) ' frames)' add];
        end
        set(obj.Names(i) , 'string' , [names{i} add]);
    end
case {'onlist','onlist_nomovie'}
    List = obj.display.List;
    frames = obj.display.frames;
    list_fac = obj.display.list_fac;
    controls = []; val = [];
    axes = {'X','Y','T'};
    filter = arg2;
    for i = 1:min(length(List),3);
        cb = ['moviehandler(get(' sprintf('%20.15f',obj.objstore) ',''userdata'') , ''input_click'',' num2str(i),')' ];
        if i==1
            List1 = List;
        else
            List1 = {'-- none --',List{:}};
        end
        % find the factor matching this axis
        f = find(filter>2 & mod(filter,3)==i-1);
        add = [];
        if isempty(f)
            % no factor for this ('none')
            val{i} = {[],1};
        else
            f2 = find(list_fac==f);
            if i==3 & ~isempty(f2)
                add = [' (' num2str(frames(f2)) ' frames)'];
            end
            if isempty(f2)
                %shouldn't get to here
                f2 = 1;
            elseif i>1
                f2 = f2 + 1;
            end
            val{i} = {[],f2};
        end
        controls{i} = multiinput(obj.Figure,{'textinput','popupnotext'},{[axes{i} add],''},{'',List1},{'',cb});
    end
    set(obj.InputList,'controls',controls,'value',val,'userdata',list_fac);
end

%------------------------------------------------------------------------
function arg = i_Visible(obj,arg,plotdim,plotstyle);
%------------------------------------------------------------------------
switch lower(arg)
case {'visible' ; 'on'}
    if ~isempty(obj.frame)
        set(obj.frame,'colsizes',[-1 90],'gapx',10);
    end
    set(obj.B1,'enable','on');
    set(obj.MovieVec , 'visible' , 'on');
    set(obj.titletext, 'string', 'Movies');
    set(obj.InputList, 'visible','off');
case {'onlist','onlist_nomovie'}
    set(obj.MovieVec , 'visible' , 'off');
    if strcmp(lower(arg),'onlist_nomovie')
        set(obj.Buttons , 'visible' , 'off');
        if ~isempty(obj.frame)
            set(obj.frame,'colsizes',[-1 0],'gapx',0);
        end
    else
        if ~isempty(obj.frame)
            set(obj.frame,'colsizes',[-1 90],'gapx',10);
        end
        set(obj.Buttons , 'visible' , 'on');
    end
    set(obj.InputList,'visible','on');
    set(obj.titletext, 'string', 'Inputs');
    if nargin>3
        if (plotdim==3) & (plotstyle~=3)
            set(obj.B1,'enable','on');
        else
            set(obj.B1,'enable','off');
        end
    end
    arg = 'on';
case {'invisible' ; 'off'}
    set(obj.MovieVec , 'visible' , 'off');
    set(obj.InputList, 'visible','off','controls',{});
end

%-------------------------------------------------------------------
function i_SetAxes(obj,order)
%-------------------------------------------------------------------
set(obj.Radio, 'value',0);
for i = 1:min([3,length(order)])
     set(obj.Radio(order(i),i),'value',1);
end

