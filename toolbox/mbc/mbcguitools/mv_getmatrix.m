function [m,ok,str]=mv_getmatrix(varargin)
%MV_GETMATRIX
%
% X=MV_GETMATRIX displays a gui for choosing a mtrix from the base workspace
% [X,OK]=MV_GETMATRIX also returns a flag indicating whether a matrix was
%       was selected or the cancel button pressed
% X=MV_GETMATRIX(SIZE) where SIZE is a vector of numbers indicating that only
%       matrices with the given size in each dimensio should be displayed. Use
%       a NaN to indicate that any size is allowed in that dimension.
% X=MV_GETMATRIX(SIZE,TYPE) also indicates the type of variables that should be
%       shown.  TYPE is either a string or a cell array of strings.
% [X,OK,STR]=MV_GETMATRIX(SIZE,TYPE) also returns the name of the variable in 
%       the base workspace.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:33:32 $


if nargin==0
   action='create';
elseif isnumeric(varargin{1})
   action='create';
else
   action=varargin{1};
end

switch lower(action)
case 'create'
   
   scrsz=get(0,'screensize');
   figh=xregfigure('visible','off',...
      'resize','off',...
      'position',[scrsz(3)/2-80 scrsz(4)/2-160 160 250],...
      'numbertitle','off',...
      'name','Choose Matrix',...
      'menubar','none',...
      'toolbar','none',...
      'doublebuffer','on',...
      'color',get(0,'defaultuicontrolbackgroundcolor'));
   
   ud.list=uicontrol('style','listbox',...
      'parent',figh,...
      'position',[10 40 140 200],...
      'callback',[mfilename '(''dblclick'');'],...
      'backgroundcolor',[1 1 1]);
   
   % ok and cancel
   uicontrol('style','pushbutton',...
      'parent',figh,...
      'position',[13 7 65 25],...
      'string','OK',...
      'callback',[mfilename '(''ok'');']);
   uicontrol('style','pushbutton',...
      'parent',figh,...
      'position',[82 7 65 25],...
      'string','Cancel',...
      'callback',[mfilename '(''cancel'');']);
   
   if nargin==0
      dosizecheck=false;      
      dotypecheck=false;
   elseif nargin==1
      dosizecheck=true;      
      dotypecheck=false;
   elseif nargin>1
      if isempty(varargin{1})
         dosizecheck=false;
         dotypecheck=true;
      else
         dosizecheck=true;
         dotypecheck=true;
      end
      varargin{2}=lower(varargin{2});
   end
   
   % get string for listbox
   S=evalin('base','whos');
   if dosizecheck | dotypecheck
      ncompdims=length(varargin{1});
      % make NaN exclusion vector
      NaNs=isnan(varargin{1});
      % loop over variables
      inds=[];
      for n=1:length(S)
         sok=1;
         if dosizecheck
            vardims=S(n).size;
            % buffer vardims to same length as dim filter
            if length(vardims)>ncompdims
               vardims=vardims(1:ncompdims);
            end
            if length(vardims)<ncompdims
               vardims(end+1:ncompdims)=1;
            end
            
            ok=((vardims==varargin{1}) | NaNs);
            if ~all(ok);
               sok=0;
            end 
         end
         tok=1;
         if dotypecheck
            if ~any(strcmp(lower(S(n).class),varargin{2}))
               tok=0;
            end
         end
         if tok & sok
            % save index
            inds=[inds n];
         end
      end
   else
      inds=':';
   end
   
   if isempty(inds)
      str='No matrices found';
   else
      str={S(inds).name};
   end
   set(ud.list,'string',str);

   set(figh,'userdata',ud,'visible','on',...
      'closerequestfcn',[mfilename '(''cancel'');']);
   drawnow;
   set(figh,'windowstyle','modal');
   waitfor(figh,'tag','finished');
   
   ud=get(figh,'userdata');
   if isempty(ud)
      %cancel situation
      m=[];
      str='';
      if nargout>1
         ok=0;
      end
   else
      m=ud;
      str=m.matnm;
      m=m.mat;
      if nargout>1
         ok=1;
      end
   end   
   delete(figh)
   
case 'dblclick'
   figh=gcbf;
   if strcmp(get(figh,'selectiontype'),'open')
      mv_getmatrix('ok');
   end
   
case 'cancel'
   figh=gcbf;
   set(figh,'userdata',[]);
   set(figh,'tag','finished');
   
case 'ok'
   figh=gcbf;
   ud=get(figh,'userdata');
   val=get(ud.list,'value');
   str=get(ud.list,'string');
   if isstr(str)
      str={str};
   end
   if strcmp(str(1),'No matrices found')
      % this is really a cancel condition
      set(figh,'userdata',[]);
   else
      matnm=str{val};
      mat=evalin('base',matnm);
      ud.mat=mat;
      ud.matnm=matnm;
      set(figh,'userdata',ud);
   end
   set(figh,'tag','finished');
end
return
