function  slice_callback(varargin)
%	Create/change/delete slice

global V3D_HANDLES

figure_handle=V3D_HANDLES.figure_handle;
axis_handle=V3D_HANDLES.axis_handle;

handles=varargin{3};


%	Get handle of current axes
% axis_handle=get(figure_handle,'CurrentAxes');

%	Get user dara associated with figure figure_handle
ud=get(figure_handle,'userdata');
userdata=getappdata(figure_handle,'userdata');

% alten CLim sichern
oldclim=get(axis_handle,'CLim');
 
%	Parameter choices
method_list={'nearest','linear','cubic'};
lighting_list={'none','flat','gouraud','phong'};

%	Store parameters of slice in strukture "slud"
slud.method=get(handles.slice_method,'Value');
slud.edgecolor=get(handles.slice_edgecolor,'userdata');
slud.edgecolor_value=get(handles.slice_edgecolor,'Value');
slud.facecolor=get(handles.slice_facecolor,'userdata');
slud.facecolor_value=get(handles.slice_facecolor,'Value');
slud.lighting=get(handles.slice_lighting,'Value');

%	Store alpha values in "slud"
slud.alpha_single=get(handles.slice_alpha_single,'Value');
slud.alpha=get(handles.slice_alpha,'Value');

% av (Face und Edge Alphavalue) festlegen
if slud.alpha == 1                     % single value
   av=slud.alpha_single;
else
   if slud.alpha==2 || slud.alpha==4   % flat
      av='flat';
   else                                % interp
      av='interp';
   end
end


%	If slice X is sctive
if get(handles.slice_x,'Value') 
   temp=get(handles.slice_xact,'String');
   if ~isempty(temp)
      slud.x=str2num(temp);   %#ok  Can be more than one number
      if isempty(slud.x)
         wh=warndlg(['Slice value(s) specified for "',ud.options.xinfo{1},'",  ', ...
            temp,',  is not numeric.']);
         add_handle2delete1(wh,figure_handle)
      else
         [slud.x,ier]=bounded_array(slud.x,userdata.xmin,userdata.xmax);
         if ier
            set(handles.slice_xact,'String',vector2str(slud.x))
         end
      end
   else
      slud.x=[];
   end
else	% x is not active
   slud.x=[];
end

%	If slice y is active
if get(handles.slice_y,'Value')
   temp=get(handles.slice_yact,'String');
   if ~isempty(temp)
      slud.y=str2num(temp);   %#ok  Can be more than one number
      if isempty(slud.y)
         wh=warndlg(['Slice value(s) specified for "',ud.options.yinfo{1},'",  ', ...
            temp,',  is not numeric.']);
         add_handle2delete1(wh,figure_handle)
      else
         [slud.y,ier]=bounded_array(slud.y,userdata.ymin,userdata.ymax);
         if ier
            set(handles.slice_yact,'String',vector2str(slud.y))
         end
      end
   else
      slud.y=[];
   end
else  % y is not active  
   slud.y=[];
end

%	If slice z is active
if get(handles.slice_z,'Value')
   temp=get(handles.slice_zact,'String');
   if ~isempty(temp)
      slud.z=str2num(temp);   %#ok  Can be more than one number
      if isempty(slud.z)
         wh=warndlg(['Slice value(s) specified for "',ud.options.zinfo{1},'",  ', ...
            temp,',  is not numeric.']);
         add_handle2delete1(wh,figure_handle)
      else
         [slud.z,ier]=bounded_array(slud.z,userdata.zmin,userdata.zmax);
         if ier
            set(handles.slice_zact,'String',vector2str(slud.z))
         end
      end
   else
      slud.z=[];
   end
else % z is not active
   slud.z=[];
end

%	Find all V3D-slices finden and delete them
delete(findobj(figure_handle,'Tag','V3D:SLICE'));

%	Get volume browser window to the front
figure(figure_handle)
figure(handles.figure1)
hold on

%	Create slice
V3D_SLICE = slice(ud.x,ud.y,ud.z,ud.v,slud.x,slud.y,slud.z,method_list{slud.method});

%	Set attributes    
set(V3D_SLICE,'FaceColor',slud.facecolor); 
set(V3D_SLICE,'EdgeColor',slud.edgecolor);
set(V3D_SLICE,'FaceLighting',lighting_list{slud.lighting});
set(V3D_SLICE,'EdgeLighting',lighting_list{slud.lighting});
set(V3D_SLICE,'FaceAlpha',av);
set(V3D_SLICE,'EdgeAlpha',av); 
set(V3D_SLICE,'Tag','V3D:SLICE');
set(V3D_SLICE,'userdata',slud);

% AlphaData = CData für Alphamap-Transparenz interp und flat setzen
% alpha('color') geht nicht, da dies auch andere Objekte ausser V3d:SLICE Objekte verändert :(
if slud.alpha == 2  ||  slud.alpha == 3
    temp=findobj(figure_handle,'Tag','V3D:SLICE');
    for i=1:length(temp)
        set(temp(i),'AlphaData',get(temp(i),'CData'));
    end
end

% AlphaData setzen für AlphaData-Transparenz interp und flat 
% kompliziert das slice Befehl keine AlphaDatas mit akzeptiert
% daher Umwandlung von 3d alphadaten in 2d alphadaten
% Problem sind Zwischenschritte 
if slud.alpha == 4  ||  slud.alpha == 5
    set(V3D_SLICE,'AlphaDataMapping','none'); 
    temp=findobj(figure_handle,'Tag','V3D:SLICE');
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


%	Set minimum and maximum colors
set(axis_handle,'CLim',oldclim);

