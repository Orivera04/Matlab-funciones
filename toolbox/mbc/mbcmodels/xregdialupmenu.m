function varargout= xregdialupmenu(varargin)
%XREGDIALUPMENU 3d graph menu for MBC surface viewer
%
% Function to control the contextmenu behaviour of mv_Dialup

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.6.2 $  $Date: 2004/02/09 08:02:24 $


if nargin==0
   arg='init';
else
   arg = lower(varargin{1});
end

if nargin>1
    hAx= varargin{2};
else
    hAx= gca;
end
    
map= {'hsv','hot','cool','gray','jet','winter','spring','summer','autumn'};

switch arg
case 'init'
   % Create menus

   %% FILE MENU

   hAx= varargin{2};
   ux= get(hAx,'uicontextmenu');
   hfig= get(hAx,'parent');
   
   %%
   %% Mouse mode
   %%
   h_mouse=uimenu(ux,'label','&Mouse Mode');
   h.MouseMode=h_mouse;
   
   h.Rot3d=uimenu(h_mouse, ...
      'label','&Rotate Axes','checked','on',...
      'callback',{@i_rot3d,hAx});         
   h.Orbitlight=uimenu(h_mouse, ...
      'label','&Orbit Scenelight',...
      'callback',{@i_orbit3d,hAx});
    
   %%
   %% Scene
   %%
   h_scene=uimenu(ux,'label','&Scene');
   h.Scene=h_scene;
   
   uimenu(h_scene, ...
      'Label','Lighting &Flat','tag','lighting', ...
      'callback', {@i_changeprop,'lighting',hAx,'flat'});
   h.lightgouraud=uimenu(h_scene, ...
      'Label','Lighting &Gouraud','tag','lighting', ...
      'callback', {@i_changeprop,'lighting',hAx,'gouraud'});
   h.lightphong=uimenu(h_scene, ...
      'Label','Lighting &Phong','tag','lighting', ...
      'callback', {@i_changeprop,'lighting',hAx,'phong'},...
      'checked','on');
  h.lighting= 'phong';
   h.mesh= uimenu(h_scene, ...
      'Label','Shading &None', 'separator', 'on',...
      'callback', {@i_mesh,hAx});
  uimenu(h_scene, ...
      'Label','Shading Fa&ceted', 'separator', 'off','tag','shading',...
      'callback', {@i_changeprop,'shading',hAx,'faceted'});
   h.flat= uimenu(h_scene, ...
      'Label','Shading F&lat','tag','shading',...
      'callback', {@i_changeprop,'shading',hAx,'flat'});
   h.interp= uimenu(h_scene, ...
      'Label','Shading &Interp','tag','shading',...
      'check','on',...
      'callback', {@i_changeprop,'shading',hAx,'interp'});
   h.shading='interp';
   uimenu(h_scene, ...
      'Label','Material &Metal','tag','material',...
      'separator','on',...
      'callback', {@i_changeprop,'material',hAx,'metal'});
   uimenu(h_scene, ...
      'Label','Material &Dull','tag','material',...
      'callback', {@i_changeprop,'material',hAx,'dull'});
   uimenu(h_scene, ...
      'Label','Material &Shiny','tag','material',...
      'callback', {@i_changeprop,'material',hAx,'shiny'});
   uimenu(h_scene, ...
      'Label','Material &Default','tag','material',...
      'check','on',...
      'callback', {@i_changeprop,'material',hAx,'default'});
   h.material='default';
   
   
   uimenu(h_scene, ...
      'Label','&Clipping', 'separator', 'on',...
      'callback', {@i_clipping,hAx});

   %%
   %% Axes
   %%
   h_axes=uimenu(ux,'label','&Axes');
   h.Box= uimenu(h_axes, ...
      'Label','Box','check','on', ...
      'callback', {@i_changeaxesbox,hAx});
   h.Ticks= uimenu(h_axes, ...
      'Label','&Ticks','check','on','tag','ticks', ...
      'callback', {@i_changeaxesticks,hAx});
   h.Grid= uimenu(h_axes, ...
      'Label','&Grid', 'check','on','tag','grid',...
      'callback', {@i_changeaxesgrid,hAx});
  
  hc = uimenu(ux,'label','&Color Map');
  for i=1:length(map);
      h.ColorMap(i,1)= uimenu(hc,'label',map{i},...
          'callback',{@i_ColorMap,hAx,map{i}});
  end
  set(h.ColorMap(1),'checked','on')
  %%
  %% Scenelight
  %%
  h_light = uimenu(ux, ...
      'Label','&Scenelight','check','on', ...
      'callback', {@i_changescenelight,hAx});
  h.LightMenu=h_light;
  
  h_print = uimenu(ux, ...
      'Label','&Print to Figure', ...
      'separator','on',...
      'callback', {@i_Print,hAx});
   set(ux,'userdata',h);
      
case 'updateplot'
    h= get( get(hAx,'uicontextmenu'),'userdata');
    hfig= get(hAx,'parent');
    
    hs= findobj(hAx,'type','surface');
    
    if ~isempty(hs)
        lighting(hAx,h.lighting);
        shading(hAx,h.shading);
        material(hAx,h.material);
        if checkstatus(h.Rot3d)
            mv_rotate3d(hAx,'ON');
        else
            mv_rotate3d(hAx,'off');
        end
        
        if checkstatus(h.mesh)
            set( hs(1) , 'facecolor' ,'none','edgecolor','interp');
            i_changeprop(h.interp,[],'shading',hAx,'flat')

        end
        
        set(h.Rot3d,'enable','on');
        set(h.Orbitlight,'enable','on');
    else
        % 2D plot
        mv_rotate3d(hAx,'off');
        set(h.Rot3d,'enable','off');
        set(h.Orbitlight,'enable','off');
        shading(hAx,'faceted');
    end
    hL= findobj(hAx,'type','light');
    if ~isempty(hL) && any(strcmp(get(hL,'visible'),'on'))
        set(h.Orbitlight,'enable','on');
        set(h.LightMenu,'checked','on','enable','on')
        if checkstatus(h.Orbitlight)
            xregorbit3d(hfig,'ON');
        else
            xregorbit3d(hfig,'off');
        end
    else
        set(h.Orbitlight,'enable','off');
        set(h.LightMenu,'checked','off','enable','off')
    end
    
    set(hAx,...
        'box',bool2OnOff( checkstatus( h.Box) )  );
    grid(hAx,bool2OnOff( checkstatus( h.Grid)));
case 'colormap'
    h= get( get(hAx,'uicontextmenu'),'userdata');
    hfig= get(hAx,'parent');  
    
    ind= strcmp(get(h.ColorMap,{'checked'}),'on');
    
    varargout{1}= map{ind};
    
case '2dmenus'
    h= get( get(hAx,'uicontextmenu'),'userdata');
    hfig= get(hAx,'parent');
    
   % change enable status to be appropriate for 2d
   set([h.Scene, h.MouseMode, h.LightMenu],'enable','off');
case '3dmenus'
    
    h= get( get(hAx,'uicontextmenu'),'userdata');
    hfig= get(hAx,'parent');
   % change enable status to be appropriate for 3d
   set([h.Scene, h.MouseMode, h.LightMenu],'enable','on');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret=toggleOnOff(h)
newval = strcmp(get(h, 'checked'), 'off');
set(h, 'checked', bool2OnOff(newval));
if nargout>0
   ret = newval;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret=bool2OnOff(val)
if val
   ret = 'on';
else
   ret = 'off';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret=checkstatus(h)

ret = strcmp(get(h, 'checked'), 'on');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ticks(arg,ax)
switch arg
case 'off' 
   set(ax, 'xtick', [], 'ztick', [], 'ytick', [])
case 'on'
   set(ax, 'xtickmode', 'auto', 'ztickmode','auto', 'ytickmode', 'auto')
end


function i_changeprop(src,evt,fcn,hAx,setting)

hfig= get(hAx,'parent');
h=findobj(hfig,'tag',fcn,'check','on');
set([h;src],{'check'},{'off';'on'});

h= get( get(hAx,'uicontextmenu'), 'userdata' );
h.(fcn)= setting;
set( get(hAx,'uicontextmenu'), 'userdata',h );
feval(fcn,hAx,setting);

return



function i_rot3d(src,evt,hAx)

h= get( get(hAx,'uicontextmenu'), 'userdata' );
if toggleOnOff(src)
   if checkstatus(h.Orbitlight)
      i_orbit3d(h.Orbitlight,evt,hAx);
   end
   mv_rotate3d(hAx,'ON'); % needs capitalised ON to prevent Az/El being displayed
else
   mv_rotate3d(hAx,'off');
end


function i_orbit3d(src,evt,hAx)

hfig= get(hAx,'parent');
h= get( get(hAx,'uicontextmenu'), 'userdata' );

if toggleOnOff(src)
   if checkstatus(h.Rot3d) % needs capitalised ON to prevent Az/El being displayed
      i_rot3d(h.Rot3d,[],hAx);
   end  
   xregorbit3d(hfig,'ON');
else
   xregorbit3d(hfig,'off');
end


function i_clipping(src,evt,hAx)
if toggleOnOff(src)
   set(findobj(hAx), 'clipping', 'on');
else
   set(findobj(hAx), 'clipping', 'off');
end




function i_changeaxescolor(src,evt,hAx)

set(hAx, 'color', uisetcolor(get(hAx,'color')));


function i_changeaxesvisible(src,evt,hAx)

hfig= get(hAx,'parent');
h= get( get(hAx,'uicontextmenu'), 'userdata' );

toggleOnOff(src);
set(hAx,'visible',get(src,'checked'));
if checkstatus(src)
   set([h.Box, h.Ticks, h.Grid, h.AxColor],'enable','on');
else
   set([h.Box, h.Ticks, h.Grid, h.AxColor],'enable','off');
end



function i_changeaxesbox(src,evt,hAx)

toggleOnOff(src);
set(hAx,'box',get(src, 'checked'));



function i_changeaxesgrid(src,evt,hAx)

toggleOnOff(src);
grid(hAx,get(src, 'checked'));



function i_changeaxesticks(src,evt,hAx)

hfig= get(hAx,'parent');
h= get( get(hAx,'uicontextmenu'), 'userdata' );

toggleOnOff(src);
ticks(get(src, 'checked'),hAx)

if checkstatus(src)
   set(h.Grid,'enable','on');
else
   set(h.Grid,'enable','off');
end


function i_changescenelight(src,evt,hAx)

hfig= get(hAx,'parent');
h= get( get(hAx,'uicontextmenu'), 'userdata' );

hL= findobj(hAx,'type','light');
if ~isempty(hL)
   if toggleOnOff(src)
      set(hL,'visible','on');
      set(h.Orbitlight,'enable','on');
   else
      set(h.Orbitlight,'enable','off');
      set(hL,'visible','off');
      if checkstatus(h.Orbitlight);
         % stop orbit mouse motion
         i_orbit3d(h.Orbitlight,[],hAx);
      end
   end
end


function i_ColorMap(src,evt,hAx,map);

hfig= get(hAx,'parent');
h= get( get(hAx,'uicontextmenu'), 'userdata' );

oldmap= get(hfig,'colormap');
set( get(get(src,'parent'),'children') , 'checked','off');
set( src, 'checked', 'on' )

if isequal(oldmap(end,:),mbcbdrycolor) 
    map= feval(map,size(oldmap,1)-1);
    % add boundary color to end of map
    map= [map ; mbcbdrycolor ];
else
    map= feval(map,size(oldmap,1));
end
set( hfig, 'colormap', map );


function i_mesh(src,evt,hAx);

hfig= get(hAx,'parent');
h= get( get(hAx,'uicontextmenu'), 'userdata' );
if toggleOnOff(src)
    hs= findobj(hAx,'type','surface');
    set( hs(1) , 'facecolor' ,'none','edgecolor','interp');
    
    i_changeprop(h.flat,[],'shading',hAx,'flat')
    
else
    hs= findobj(hAx,'type','surface');
    set( hs(1) , 'FaceColor','interp','EdgeColor','none');
    i_changeprop(h.interp,[],'shading',hAx,'interp')
end


function i_Print(src,evt,hAx);

hFig = figure('colormap',get(get(hAx,'parent'),'colormap'));
ha = copyobj(hAx,hFig);
set(ha,'units','norm', ...
    'Position',get(0,'DefaultAxesPosition'), ...
    'UIContextMenu', []);
