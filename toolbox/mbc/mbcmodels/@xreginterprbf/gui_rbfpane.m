function lyt = gui_rbfpane( m, action, figh, p, varargin ) 
%GUI_RBFPANE   Create part of GUI for rbf settings of xreginterprbf object
%   LYT=GUI_RBFPANE(M,'layout',FIG,P) creates a layout object
%   with callbacks defined for updating the model pointed to by P.
%   FIG is the figure to create it in.
%   
%   LYT=GUI_RBFPANE(M,'layout',FIG,P,'callback,CBSTR) attaches a
%   callback string, CBSTR, which is fired when the model definition
%   is changed.  The string may contain the tokens %MODEL% and %POINTER%
%   which will be replaced with the current model and the pointer before
%   the callback is executed.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:48:48 $ 



switch lower(action)
case 'layout'
      cbstr='';
      if nargin>4
         for n=1:2:length(varargin)
            switch lower(varargin{n})
            case 'callback'
               cbstr=varargin{n+1};
            end
         end
      end
      lyt=i_createlyt(figh,p,cbstr);
end
return

% -------------------------------------------------------------------------|
function lyt=i_createlyt(figh,p,callback)

ud.callback=callback;
ud.pointer=p;
ud.figure=figh;
m=p.info;

udp = xregGui.RunTimePointer;
udp.LinkToObject(figh);

kernelList = { 'multiquadric','recmultiquadric','gaussian',...
        'thinplate','logisticrbf','wendland','linearrbf','cubicrbf'};
kernel = get( m, 'kernel' );

ud.popupKernel = xreguicontrol( figh,...
    'style','popupmenu',...
    'string',kernelList,...
    'value',find( strcmpi( kernel, kernelList ) ), ...
    'callback',{@i_kernel,udp},...
    'visible','off',...
    'interruptible','off',...
    'horizontalalignment','left',...
    'backgroundcolor','w');

ud.editWidth =  xreguicontrol( figh,...
    'style','edit',...
    'string', num2str( get( m, 'width' ) ), ...
    'horizontalalignment','left',...
    'backgroundcolor','w',...
    'callback',{@i_width,udp},...
    'visible','off');

val=find(strcmp(num2str(get(m,'cont')),{'0','2','4','6'}));
ud.popupContinuity = xreguicontrol( figh,...
    'style','popupmenu',...
    'string',{ '0', '2', '4', '6'},...
    'value',val,...
    'callback',{@i_continuity,udp},...
    'visible','off',...
    'interruptible','off',...
    'horizontalalignment','left',...
    'backgroundcolor','w');

ud.editLambda = xreguicontrol( figh,...
    'style','edit',...
    'string',num2str( get(m,'lambda') ),...
    'horizontalalignment','left',...
    'backgroundcolor','w',...
    'callback',{@i_lambda,udp},...
    'visible','off');

ud.lctrlKernel = xregGui.labelcontrol( ...
    'parent',figh,...
    'Control', ud.popupKernel,...
    'String','Kernel',...
    'Enable','on', ...
    'ControlSize', 120, ...
    'ControlSizeMode', 'relative',...
    'LabelSize', 120, ...
    'LabelSizeMode', 'relative');

ud.lctrlWidth = xregGui.labelcontrol( ...
    'parent',figh,...
    'Control', ud.editWidth,...
    'String','Width',...
    'Enable','on', ...
    'ControlSize', 120, ...
    'ControlSizeMode', 'relative',...
    'LabelSize', 120, ...
    'LabelSizeMode', 'relative');

ud.lctrlContinuity = xregGui.labelcontrol( ...
    'parent',figh,...
    'Control', ud.popupContinuity,...
    'string','Continuity',...
    'enable','on', ...
    'ControlSize', 120, ...
    'ControlSizeMode', 'relative',...
    'LabelSize', 120, ...
    'LabelSizeMode', 'relative');

ud.lctrlLambda = xregGui.labelcontrol( ...
    'parent',figh,...
    'Control', ud.editLambda,...
    'String','Lambda',...
    'Enable','on', ...
    'ControlSize', 120, ...
    'ControlSizeMode', 'relative',...
    'LabelSize', 120, ...
    'LabelSizeMode', 'relative');

lyt = xreggridbaglayout(figh,...
    'dimension',[5 1],...
    'rowsizes',[20 20 20 20 -1],...
    'colsizes',[-1],...
    'gapy',5,'gapx',7,...
    'border',[7 7 7 7],...
    'elements',{... ...
        ud.lctrlKernel; ...
        ud.lctrlWidth;...
        ud.lctrlContinuity; ...
        ud.lctrlLambda; ...
        [] } );

udp.info = ud;

i_enableWdith(udp,kernel);
i_enableContinuity(udp,kernel);
i_enableLambda(udp);

return

% -------------------------------------------------------------------------|
function i_kernel(h,evt,udp)

ud=udp.info;
m=ud.pointer.info;

value = get( ud.popupKernel, 'value' );
kernelList = get( ud.popupKernel, 'string' );
kernel = kernelList{ value };
set( m, 'kernel', kernel );

i_enableWdith(udp,kernel);
i_enableContinuity(udp,kernel);

ud.pointer.info = m;
i_firecb(ud.callback,ud.pointer);

return

% -------------------------------------------------------------------------|
function i_width(h,evt,udp)

ud=udp.info;
m=ud.pointer.info;

width = str2num( get( ud.editWidth, 'string' ) );
if ~isempty(width) & width > eps,
    % if a valid number is entered for the width, set the edit box and 
    % the model
    set( ud.editWidth, 'string', num2str( width ) );
    m = set( m, 'width', width );
else
    % if the width string doesn't read as a number or is too small, get the
    % last width value from the model and set the edit box
    width = get( m, 'width' );
    set( ud.editWidth, 'string', num2str( width ) );
end

ud.pointer.info = m;
i_firecb(ud.callback,ud.pointer);

return

% -------------------------------------------------------------------------|
function i_continuity(h,evt,udp) 

ud=udp.info;
m=ud.pointer.info;

value = get( ud.popupContinuity, 'value' );
list = get( ud.popupContinuity, 'string' );
continuity = list{ value };
set( m, 'cont', str2num( continuity ) );

ud.pointer.info = m;
i_firecb(ud.callback,ud.pointer);

return

% -------------------------------------------------------------------------|
function i_lambda(h,evt,udp)

ud=udp.info;
m=ud.pointer.info;

lambda = str2num( get( ud.editLambda, 'string' ) );
if ~isempty(lambda) & lambda >= 0,
    % if a valid number is entered for lambda, set the edit box and 
    % the model
    set( ud.editLambda, 'string', num2str( lambda ) );
    m = set( m, 'lambda', lambda );
else
    % if the lambda string doesn't read as a number or is too small, 
    % get the last lambda value from the model and set the edit box
    lambda = get( m, 'lambda' );
    set( ud.editLambda, 'string', num2str( lambda ) );
end

ud.pointer.info = m;
i_firecb(ud.callback,ud.pointer);

return

% -------------------------------------------------------------------------|
function i_enableWdith(udp,kernel)

if any( strcmpi( kernel, {'thinplate', 'linearrbf', 'cubicrbf'} ) ),
    set( udp.info.lctrlWidth, 'Enable', 'off' );
else
    set( udp.info.lctrlWidth, 'Enable', 'on' );
end

return

% -------------------------------------------------------------------------|
function i_enableContinuity(udp,kernel)

if strcmpi( kernel, 'wendland' ),
    set( udp.info.lctrlContinuity, 'Enable', 'on' );
else
    set( udp.info.lctrlContinuity, 'Enable', 'off' );
end

return

% -------------------------------------------------------------------------|
function i_enableLambda(udp,varargin)

% maybe latter we add spline smoothing
set( udp.info.lctrlLambda, 'Enable', 'off' ); 

return

% -------------------------------------------------------------------------|
function i_firecb(cbstr,ptr)
% parse callback string and execute it

if ~isempty(cbstr) 
   if ischar(cbstr)
      % parse for %MODEL% and %POINTER%
      
      pcs=findstr(cbstr,'%');
      go=1;
      needobj=0;
      needval=0;
      while (go<=(length(pcs)-1))
         cmp=cbstr(pcs(go)+1:pcs(go+1)-1);
         if strcmp(cmp,'POINTER')
            needval=1;
            cbstr=[cbstr(1:pcs(go)-1) 'XX_POINTER_XX' cbstr(pcs(go+1)+1:end)];
            go=go+2;
            pcs=pcs+6;
         elseif strcmp(cmp,'MODEL')
            needobj=1;
            cbstr=[cbstr(1:pcs(go)-1) 'XX_MODEL_XX' cbstr(pcs(go+1)+1:end)];
            go=go+2;
            pcs=pcs+6;
         else
            go=go+1;
         end
      end
      
      if needobj
         assignin('base','XX_MODEL_XX',ptr.info);
      end
      if needval
         assignin('base','XX_POINTER_XX',ptr);
      end
      evalin('base',cbstr);
      
      % clear up base workspace
      evalin('base','clear(''XX_MODEL_XX'',''XX_POINTER_XX'');');  
   elseif isa(cbstr,'function_handle')
      feval(cbstr,ptr.info,[]);
   else
      if length(cbstr)>1
         feval(cbstr{1},ptr.info,[],cbstr{2:end});
      else
         feval(cbstr{1},ptr.info,[]);
      end
   end
end

return

% EOF
