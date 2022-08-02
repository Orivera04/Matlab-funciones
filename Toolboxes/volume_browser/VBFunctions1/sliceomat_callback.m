function sliceomat_callback(varargin)
% Sliceomat erstellen/ändern/löschen

global V3D_HANDLES

figure_handle=V3D_HANDLES.figure_handle;
axis_handle=V3D_HANDLES.axis_handle;

handles=varargin{3};

% Benutzerdaten userdata der Figure V3D_FIGUREID auslesen
ud=get(figure_handle,'userdata');

% alten CLim sichern
oldclim=get(axis_handle,'CLim');
 
%	Parameter options
method_list={'nearest','linear','cubic'};
lighting_list={'none','flat','gouraud','phong'};

% Auslesen Einstellungen von Sliceomat in Struktur slud
slud.method=get(handles.sliceomat_method,'Value');
slud.edgecolor=get(handles.sliceomat_edgecolor,'userdata');
slud.edgecolor_value=get(handles.sliceomat_edgecolor,'Value');
slud.facecolor=get(handles.sliceomat_facecolor,'userdata');
slud.facecolor_value=get(handles.sliceomat_facecolor,'Value');
slud.lighting=get(handles.sliceomat_lighting,'Value');

% Alphawerte auslesen
slud.alpha_single=get(handles.sliceomat_alpha_single,'Value');
slud.alpha=get(handles.sliceomat_alpha,'Value');
% av (Face und Edge Alphavalue) festlegen
if slud.alpha==1                        % single value
    av=slud.alpha_single;
else
    if slud.alpha == 2  ||  slud.alpha == 4  % flat
        av='flat';
    else                                % interp
        av='interp';
    end
end

anyslice=false;                        %%ER
if get(handles.sliceomat_x,'Value')   % X has been activated
    % X Wert auslesen
   slud.x=str2num(get(handles.sliceomat_xact,'String')); %#ok More than one variable is possible
   anyslice=true;                     %%ER
else                                  % X has not been activated
   slud.x=[];
end

if get(handles.sliceomat_y,'Value')  % Y has been activated
    % Y Wert auslesen
   slud.y=str2num(get(handles.sliceomat_yact,'String')); %#ok More than one variable is possible
   anyslice=true;                     %%ER
else                                 % Y has not been activated
   slud.y=[];
end

if get(handles.sliceomat_z,'Value')  % Z has been activated
    % Z Wert auslesen
   slud.z=str2num(get(handles.sliceomat_zact,'String')); %#ok More than one variable is possible
   anyslice=true;                     %%ER
else                                 % Z has not been activated
   slud.z=[];
end


% alle V3D-Slices finden und löschen
delete(findobj(figure_handle,'Tag','V3D:SLICEOMAT'));
delete(findobj(figure_handle,'Tag','OrigSlice'))   %%ER

%	Bring windows to the foreground
%figure(figure_handle)
figure(handles.figure1)

%	If no slice is activated then activate x-slice to make something happen when
%       the "Animate" button is pushed
if ~anyslice  &&  ud.first_slice
   set(handles.sliceomat_x,'Value',1)
   ud.first_slice=false;
   set(figure_handle,'userdata',ud)
   slud.x=str2num(get(handles.sliceomat_xact,'String')); %#ok More than one variable is possible
%   V3D_SLICEOMAT = slice(ud.x,ud.y,ud.z,ud.v,slud.x,slud.y,slud.z,method_list{slud.method});
end


hold on

% Slice erstellen
V3D_SLICEOMAT = slice(ud.x,ud.y,ud.z,ud.v,slud.x,slud.y,slud.z,method_list{slud.method});
% Attribute setzen    
set(V3D_SLICEOMAT,'FaceColor',slud.facecolor); 
set(V3D_SLICEOMAT,'EdgeColor',slud.edgecolor);
set(V3D_SLICEOMAT,'FaceLighting',lighting_list{slud.lighting});
set(V3D_SLICEOMAT,'EdgeLighting',lighting_list{slud.lighting});
set(V3D_SLICEOMAT,'FaceAlpha',av);
set(V3D_SLICEOMAT,'EdgeAlpha',av); 
set(V3D_SLICEOMAT,'Tag','V3D:SLICEOMAT');
set(V3D_SLICEOMAT,'userdata',slud);

% AlphaData = CData für Alphamap-Transparenz interp und flat setzen
% alpha('color') geht nicht, da dies auch andere Objekte ausser V3d:SLICEOMAT Objekte verändert :(
if slud.alpha == 2 || slud.alpha == 3
    temp=findobj(figure_handle,'Tag','V3D:SLICEOMAT');
    for i=1:length(temp)
        set(temp(i),'AlphaData',get(temp(i),'CData'));
    end
end

% AlphaData setzen für AlphaData-Transparenz interp und flat 
% kompliziert das slice Befehl keine AlphaDatas mit akzeptiert
% daher umwandlung von 3d alphadaten in 2d alphadaten
% Problem sind Zwischenschritte 
if  slud.alpha == 4  ||  slud.alpha==5
    set(V3D_SLICEOMAT,'AlphaDataMapping','none'); 
    temp=findobj(figure_handle,'Tag','V3D:SLICEOMAT');
    for i=1:length(temp)
        % X,Y,Z Data auslesen
        xdata=get(temp(i),'XData');
        ydata=get(temp(i),'YData');
        zdata=get(temp(i),'ZData');
        % Test ob ein YZ-Slice
        if (xdata==xdata(1))
              % obere und untere Grenze bestimmen 
              % suche nach x-Wert der drüber und drunter liegt
              aug=find(ud.x<=xdata(1));
              aog=find(ud.x>=xdata(1));
              aug=aug(length(aug));
              aog=aog(1);

              % 2D-Slice aus Alphadaten auslesen
              avu=ud.alphav(1:length(ud.y),aug,1:length(ud.z));
              avo=ud.alphav(1:length(ud.y),aog,1:length(ud.z));
              avu=permute(avu,[1 3 2]);
              avo=permute(avo,[1 3 2]);

              % test ob obere Grenze = untere Grenze -> da division durch null
              if aug==aog
                  proz=100;
              else
                  proz=((xdata(1)-ud.x(aug))*100)/(ud.x(aog)-ud.x(aug));
              end
              
              % neue Alphadaten berechnen
              av=(avu*(100-proz)+avo*proz)/100;
              set(temp(i),'AlphaData',av);
        end
        % Test ob ein XZ-Slice
        if (ydata==ydata(1))
              % obere und untere Grenze bestimmen 
              % suche nach y-Wert der drüber und drunter liegt
              aug=find(ud.y<=ydata(1));
              aog=find(ud.y>=ydata(1));
              aug=aug(length(aug));
              aog=aog(1);

              % 2D-Slice aus Alphadaten auslesen
              avu=ud.alphav(aug,1:length(ud.x),1:length(ud.z));
              avo=ud.alphav(aog,1:length(ud.x),1:length(ud.z));
              avu=permute(avu,[2 3 1]);
              avo=permute(avo,[2 3 1]);

              % test ob obere Grenze = untere Grenze -> da division durch null
              if aug==aog
                  proz=100;
              else
                  proz=((ydata(1)-ud.y(aug))*100)/(ud.y(aog)-ud.y(aug));
              end
              
              % neue Alphadaten berechnen
              av=(avu*(100-proz)+avo*proz)/100;
              set(temp(i),'AlphaData',av);
        end
        % Test ob ein XY-Slice
        if (zdata==zdata(1))
              % obere und untere Grenze bestimmen 
              % suche nach z-Wert der drüber und drunter liegt
              aug=find(ud.z<=zdata(1));
              aog=find(ud.z>=zdata(1));
              aug=aug(length(aug));
              aog=aog(1);

              % 2D-Slice aus Alphadaten auslesen
              avu=ud.alphav(1:length(ud.y),1:length(ud.x),aug);
              avo=ud.alphav(1:length(ud.y),1:length(ud.x),aog);
              avu=permute(avu,[1 2 3]);
              avo=permute(avo,[1 2 3]);

              % test ob obere Grenze = untere Grenze -> da division durch null
              if aug==aog
                  proz=100;
              else
                  proz=((zdata(1)-ud.z(aug))*100)/(ud.z(aog)-ud.z(aug));
              end
              
              % neue Alphadaten berechnen
              av=(avu*(100-proz)+avo*proz)/100;
              set(temp(i),'AlphaData',av);
        end
    end
end

hold off


% Minimum und Maximum Color setzen
set(axis_handle,'CLim',oldclim);
