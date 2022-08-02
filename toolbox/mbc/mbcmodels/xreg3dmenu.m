function xreg3dmenu(varargin)
%XREG3DMENU 3d graph menu for MBC PEV viewer
%
%  Function to control the uimenu behaviour of mv_PEVView

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.3 $  $Date: 2004/04/04 03:31:02 $


hfig=findobj(allchild(0),'flat','tag','mvPEVView');
ud= get(hfig,'UserData');
if nargin==0
    arg='init';
else
    arg = lower(varargin{1});
end

switch arg
    case 'init'
        % Create menus

        %% FILE MENU
        ud.Hand.File = uimenu(hfig,...
            'label','&File');
        print = uimenu(ud.Hand.File,'label','&Print',...
            'accelerator','P',...
            'tag','printmenu',...
            'callback','mv_PEVView(''print'')');
        close = uimenu(ud.Hand.File,'label','&Close',...
            'accelerator','W',...
            'callback','mv_PEVView(''close'')');


        %% SURFACE MENU
        ud.Hand.SurfPropmenu=uimenu(hfig,...
            'label','&View');
        %%
        %% Mouse mode
        %%
        h_mouse=uimenu(ud.Hand.SurfPropmenu,'label','&Mouse Mode');
        ud.Hand.MouseMode=h_mouse;

        ud.Hand.Rot3d=uimenu(h_mouse, ...
            'label','&Rotate Axes','checked','on',...
            'callback',{@i_rot3d,hfig});
        ud.Hand.Orbitlight=uimenu(h_mouse, ...
            'label','&Orbit Scenelight',...
            'callback',{@i_orbit3d,hfig});
        ud.Setup.Rot3d='ON'; % Capitalised ON means Az/Ev doesn't appear in lower right side of figure.
        ud.Setup.Orbit3d='off';
        view(ud.Hand.Axes,3); [ud.Setup.viewaz,ud.Setup.viewel]=view;
        ud.Hand.Light=[];

        %%
        %% Scene
        %%
        h_scene=uimenu(ud.Hand.SurfPropmenu,'label','&Scene');
        ud.Hand.Scene=h_scene;

        uimenu(h_scene, ...
            'Label','Lighting &Flat','tag','lighting', ...
            'callback', {@i_changeprop,'lighting',ud.Hand.Axes,'flat',hfig});
        ud.Hand.lightgouraud=uimenu(h_scene, ...
            'Label','Lighting &Gouraud','tag','lighting', ...
            'callback', {@i_changeprop,'lighting',ud.Hand.Axes,'gouraud',hfig});
        ud.Hand.lightphong=uimenu(h_scene, ...
            'Label','Lighting &Phong','tag','lighting', ...
            'callback', {@i_changeprop,'lighting',ud.Hand.Axes,'phong',hfig},...
            'checked','on');
        ud.Setup.lighting='phong';
        uimenu(h_scene, ...
            'Label','Shading Fa&ceted', 'separator', 'on','tag','shading',...
            'callback', {@i_changeprop,'shading',ud.Hand.Axes,'faceted',hfig});
        uimenu(h_scene, ...
            'Label','Shading F&lat','tag','shading',...
            'callback', {@i_changeprop,'shading',ud.Hand.Axes,'flat',hfig});
        uimenu(h_scene, ...
            'Label','Shading &Interp','tag','shading',...
            'check','on',...
            'callback', {@i_changeprop,'shading',ud.Hand.Axes,'interp',hfig});
        ud.Setup.shading='interp';
        uimenu(h_scene, ...
            'Label','Material &Metal','tag','material',...
            'separator','on',...
            'callback', {@i_changeprop,'material',ud.Hand.Axes,'metal',hfig});
        uimenu(h_scene, ...
            'Label','Material &Dull','tag','material',...
            'callback', {@i_changeprop,'material',ud.Hand.Axes,'dull',hfig});
        uimenu(h_scene, ...
            'Label','Material &Shiny','tag','material',...
            'callback', {@i_changeprop,'material',ud.Hand.Axes,'shiny',hfig});
        uimenu(h_scene, ...
            'Label','Material &Default','tag','material',...
            'check','on',...
            'callback', {@i_changeprop,'material',ud.Hand.Axes,'default',hfig});
        ud.Setup.material='default';

        uimenu(h_scene, ...
            'Label','&Clipping', 'separator', 'on',...
            'callback', {@i_clipping,hfig});
        ud.Setup.clipping='on';


        %%
        %% Axes
        %%
        h_axes=uimenu(ud.Hand.SurfPropmenu,'label','&Axes');
        uimenu(h_axes, ...
            'Label','&Visible','check','on', ...
            'callback',{@i_changeaxesvisible,hfig});
        ud.Setup.Visible='on';
        ud.Hand.Box= uimenu(h_axes, ...
            'Label','Box','check','on', ...
            'callback', {@i_changeaxesbox,hfig},...
            'separator','on');
        ud.Setup.Box='on';
        ud.Hand.Ticks= uimenu(h_axes, ...
            'Label','&Ticks','check','on','tag','ticks', ...
            'callback', {@i_changeaxesticks,hfig});
        ud.Setup.Ticks='on';
        ud.Hand.Grid= uimenu(h_axes, ...
            'Label','&Grid', 'check','on','tag','grid',...
            'callback', {@i_changeaxesgrid,hfig});
        ud.Setup.Grid='on';
        ud.Hand.AxColor= uimenu(h_axes, ...
            'Label','&Color...','separator', 'on',...
            'callback', {@i_changeaxescolor,hfig});


        %%
        %% Scenelight
        %%
        h_light = uimenu(ud.Hand.SurfPropmenu, ...
            'Label','&Scenelight','check','on', ...
            'callback', {@i_changescenelight,hfig});
        ud.Hand.LightMenu=h_light;
        ud.Setup.Scenelight='on';

        %% Set userdata
        set(hfig,'UserData',ud)


    case 'updateplot'
        set(hfig,'currentaxes',ud.Hand.Axes);
        mv_rotate3d(ud.Hand.Axes,ud.Setup.Rot3d);
        xregorbit3d(hfig,ud.Setup.Orbit3d);
        lighting(ud.Hand.Axes,ud.Setup.lighting);
        shading(ud.Hand.Axes,ud.Setup.shading);
        material(ud.Hand.Axes,ud.Setup.material);
        set(ud.Hand.Axes,...
            'box',ud.Setup.Box,'visible',ud.Setup.Visible,...
            'clipping',ud.Setup.clipping);
        grid(ud.Hand.Axes,ud.Setup.Grid);
        ticks(ud.Setup.Ticks,ud.Hand.Axes);
        view(ud.Hand.Axes,ud.Setup.viewaz,ud.Setup.viewel);
        set(ud.Hand.Light,'position',ud.Setup.lightpos);

    case '2dmenus'
        % change enable status to be appropriate for 2d
        set([ud.Hand.Scene, ud.Hand.MouseMode, ud.Hand.LightMenu],'enable','off');
    case '3dmenus'
        % change enable status to be appropriate for 3d
        set([ud.Hand.Scene, ud.Hand.MouseMode, ud.Hand.LightMenu],'enable','on');
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
function ticks(arg,ax)
switch arg
    case 'off'
        set(ax, 'xtick', [], 'ztick', [], 'ytick', [])
    case 'on'
        set(ax, 'xtickmode', 'auto', 'ztickmode','auto', 'ytickmode', 'auto')
end


function i_changeprop(src,evt,fcn,ax,setting,hfig)
h = findobj(hfig,'tag',fcn,'check','on');
set([h;src],{'check'},{'off';'on'});

ud = get(hfig,'UserData');
feval(fcn,ud.Hand.Axes,setting);
ud.Setup.(fcn) = setting;
set(hfig,'UserData',ud);



function i_rot3d(src,evt,hfig)
ud=get(hfig,'userdata');
if toggleOnOff(src)
    ud.Setup.Rot3d='ON'; % needs capitalised ON to prevent Az/El being displayed
    set(hfig,'UserData',ud);
    if strcmp(ud.Setup.Orbit3d,'on')
        i_orbit3d(ud.Hand.Orbitlight,evt,hfig);
    end
    mv_rotate3d(ud.Hand.Axes,'ON'); % needs capitalised ON to prevent Az/El being displayed
else
    mv_rotate3d(ud.Hand.Axes,'off');
    ud.Setup.Rot3d='off';
    set(hfig,'UserData',ud);
end


function i_orbit3d(src,evt,hfig)
ud=get(hfig,'userdata');
if toggleOnOff(src)
    ud.Setup.Orbit3d='on';
    set(hfig,'UserData',ud);
    if strcmp(ud.Setup.Rot3d,'ON') % needs capitalised ON to prevent Az/El being displayed
        i_rot3d(ud.Hand.Rot3d,[],hfig);
    end
    xregorbit3d(hfig,'ON');
else
    xregorbit3d(hfig,'off');
    ud.Setup.Orbit3d='off';
    set(hfig,'UserData',ud);
end


function i_clipping(src,evt,hfig)
ud=get(hfig,'userdata');
if toggleOnOff(src)
    set(findobj(ud.Hand.Axes), 'clipping', 'on');
    ud.Setup.clipping= 'on';
else
    set(findobj(ud.Hand.Axes), 'clipping', 'off');
    ud.Setup.clipping= 'on';
end
set(hfig,'UserData',ud);



function i_changeaxescolor(src,evt,hfig)
ud=get(hfig,'userdata');
set(ud.Hand.Axes, 'color', uisetcolor(get(ud.Hand.Axes,'color')));


function i_changeaxesvisible(src,evt,hfig)
ud=get(hfig,'userdata');
toggleOnOff(src);
set(ud.Hand.Axes,'visible',get(src,'checked'));
ud.Setup.Visible=get(src, 'checked');
if strcmp(ud.Setup.Visible,'on')
    set([ud.Hand.Box, ud.Hand.Ticks, ud.Hand.Grid, ud.Hand.AxColor],'enable','on');
else
    set([ud.Hand.Box, ud.Hand.Ticks, ud.Hand.Grid, ud.Hand.AxColor],'enable','off');
end
set(hfig,'UserData',ud);


function i_changeaxesbox(src,evt,hfig)
ud=get(hfig,'userdata');
toggleOnOff(src);
ud.Setup.Box=get(src, 'checked');
set(ud.Hand.Axes,'box',get(src, 'checked'));
set(hfig,'UserData',ud);


function i_changeaxesgrid(src,evt,hfig)
ud=get(hfig,'userdata');
toggleOnOff(src);
grid(ud.Hand.Axes,get(src, 'checked'));
ud.Setup.Grid=get(src, 'checked');
set(hfig,'UserData',ud);


function i_changeaxesticks(src,evt,hfig)
ud=get(hfig,'userdata');
toggleOnOff(src);
ticks(get(src, 'checked'),ud.Hand.Axes)
ud.Setup.Ticks=get(src, 'checked');

if strcmp(ud.Setup.Ticks,'on')
    set(ud.Hand.Grid,'enable','on');
else
    set(ud.Hand.Grid,'enable','off');
end
set(hfig,'UserData',ud);


function i_changescenelight(src,evt,hfig)
ud=get(hfig,'userdata');
if ishandle(ud.Hand.Light)
    if toggleOnOff(src)
        set(ud.Hand.Light,'visible','on');
        ud.Setup.Scenelight='on';
        set(ud.Hand.Orbitlight,'enable','on');
        set(hfig,'UserData',ud);
    else
        set(ud.Hand.Orbitlight,'enable','off');
        set(ud.Hand.Light,'visible','off');
        ud.Setup.Scenelight='off';
        set(hfig,'UserData',ud);
        if strcmp(ud.Setup.Orbit3d,'on');
            % stop orbit mouse motion
            i_orbit3d(ud.Hand.Orbitlight,[],hfig);
        end
    end
end
