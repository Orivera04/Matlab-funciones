function v3d_show(x,y,z,v,options)
% Standard view after loading of data

% Adaptation of function "v3d_show" by Robert Barsch; the original
% version is available at The Matlab Central File Exchange, File ID 2255.
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=2255&objectType=file
%
% Modified by E. Rietsch: October 15, 2006

global V3D_HANDLES

figure_handle=V3D_HANDLES.figure_handle;

set(figure_handle,'Tag','V3D:FIGURE');
figure(figure_handle)

%	Delete all objects of current axes
set(figure_handle,'HandleVisibility','on')
axis_handle=cla;
set(axis_handle,'parent',figure_handle,'Tag','V3D:AXES');
setappdata(figure_handle,'AxisHandle',axis_handle)

%	Proportional axes
if options.equal_axes
   axis equal;
end

% 3D-View
myview(3);

%	Axis labels
xlabel(info2label(options.xinfo));
ylabel(info2label(options.yinfo));
zlabel(info2label(options.zinfo));

   %	Set direction of the z-axis
set(axis_handle,'ZDir',options.zdir,'Layer','top','Box','on')

% Limits setzen
set(axis_handle,'xlim',[min(x) max(x)],'ylim',[min(y) max(y)],'zlim',[min(z) max(z)]);  

% Userdaten des V3D-Fensters setzen
% x,y,z,v 
ud.x=x; % x Vektor
ud.y=y; 
ud.z=z;
ud.v=v; % v Data matrix
%ud.options=options;

userdata.xmin=min(x);
userdata.xmax=max(x);
userdata.ymin=min(y);
userdata.ymax=max(y);
userdata.zmin=min(z);
userdata.zmax=max(z);
setappdata(figure_handle,'userdata',userdata)
setappdata(figure_handle,'options',options)

% Colormap setzen
ud.cmap.name='jet'; % Colormap jet
ud.cmap.reverse=0; % Color direction not reverse
ud.cmap.brighten=0; % normal brightness
ud.cmap.log=0; % nicht logarithmic

% Alphadaten
ud.alphadata=1; % Alpha data available
ud.alphav=ones(length(y),length(x),length(z)); % Alphadaten everywhere = 1.0 (completely visible)

% Userdaten setzen
set(figure_handle,'userdata',ud);

% Auslesen von Minimum und Maximum der Daten
cmin=min(v(:));
cmax=max(v(:));

% Testen ob Maximum ungleich Minimum ansonsten Fehler
if (cmax == cmin) 
    error('Global minimum of volume ist equal to global maximum!')
 end

%	Parameters
method_list={'linear','nearest','cubic'};
lighting_list={'none','flat','gouraud','phong'};

% Userdata des Objektes setzen -> benötigt fürs auslesen in Slicemenü
objud.facecolor_value=11; % interp
objud.edgecolor_value=11; % interp
objud.facecolor='interp';
objud.edgecolor='interp';
objud.lighting=1; % none
objud.method=1; % linear
objud.alpha=3; % interp alphamap             
objud.alpha_single=1; % 100% Sichtbarkeit 

% av (Face und Edge Alphavalue) festlegen
if objud.alpha==1                        % single value
   av=objud.alpha_single;
else
   if objud.alpha==2  ||  objud.alpha==4  % flat
      av='flat';
   else                                  % interp
      av='interp';
   end
end


% Slices at the first element of x,y,z, respectively
objud.x=min(x);
objud.y=min(y);
objud.z=min(z);

hold on
% Slice erstellen
V3D_SLICE = slice(ud.x,ud.y,ud.z,ud.v,objud.x,objud.y,objud.z,method_list{objud.method});
% Attribute setzen    
set(V3D_SLICE,'FaceColor',objud.facecolor); 
set(V3D_SLICE,'EdgeColor',objud.edgecolor);
set(V3D_SLICE,'FaceLighting',lighting_list{objud.lighting});
set(V3D_SLICE,'EdgeLighting',lighting_list{objud.lighting});
set(V3D_SLICE,'FaceAlpha',av);
set(V3D_SLICE,'EdgeAlpha',av); 
set(V3D_SLICE,'Tag','V3D:SLICE');
set(V3D_SLICE,'userdata',objud);
set(V3D_SLICE,'Tag','OrigSlice');
alpha('color');
alphamap('increase',1);


% Colorbar setzen
V3D_COLORBAR=colorbar('peer',axis_handle);
set(V3D_COLORBAR,'Tag','V3D:COLORBAR');

% Minimum und Maximum Color setzen
set(axis_handle,'CLim',[cmin cmax]);
hold off

% Handles zu Menü raussuchen
tbmodul=findobj(gcf,'type','uimenu','Label','&Modul');
tbansicht=findobj(gcf,'type','uimenu','Label','&Ansicht');
tbtrans=findobj(gcf,'type','uimenu','Label','&Transparenz');
tbinsert=findobj(gcf,'type','uimenu','Label','&Einfügen');
tbcamera=findobj(gcf,'type','uimenu','Label','&Kamera Toolbar');

% inaktive Menüs wieder aktivieren, da ja Daten nun vorhanden
set(tbmodul,'enable','on');
set(tbansicht,'enable','on');
set(tbtrans,'enable','on');
set(tbinsert,'enable','on');
set(tbcamera,'enable','on');

%	Plot figure title (if requested)
fig_title=options.plot_title;
if ~isempty(fig_title)
   if ischar(fig_title)  ||  iscell(fig_title)
      title(fig_title,'Color','red','FontWeight','demi')
   else
      warndlg('The specified title is not a string.')
   end
end
  
%	Add time and label to plot
% label_and_time_stamp(options.plot_time,options.plot_label,axis_handle)

V3D_HANDLES.axis_handle=axis_handle;

% set(figure_handle,'HandleVisibility','off')
