function slice_view_2d(varargin)
% Create 2-D plots
%
% Adaptation of function "slice_view_2d" by Robert Barsch; the original
% version is available at The Matlab Central File Exchange, File ID 2255.
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=2255&objectType=file
%
% Modified by E. Rietsch: October 21, 2006

global V3D_HANDLES

handles=varargin{3};

figure_handle=V3D_HANDLES.figure_handle;

%	Benutzerdaten userdata der Figure figure_handle auslesen
ud=get(figure_handle,'userdata');
options=getappdata(figure_handle,'options');

%	Options and defaults
method_list={'nearest','linear','cubic'};
lighting_list={'none','flat','gouraud','phong'};

%	Read settings of slice in structure "slud"
slud.method=get(handles.slice_method,'Value');
slud.edgecolor=get(handles.slice_edgecolor,'userdata');
slud.edgecolor_value=get(handles.slice_edgecolor,'Value');
slud.facecolor=get(handles.slice_facecolor,'userdata');
slud.facecolor_value=get(handles.slice_facecolor,'Value');
slud.lighting=get(handles.slice_lighting,'Value');

%	Alphawerte auslesen
slud.alpha_single=get(handles.slice_alpha_single,'Value');
slud.alpha=get(handles.slice_alpha,'Value');
%	av (Face und Edge Alphavalue) festlegen
if slud.alpha==1                        % single value
   av=slud.alpha_single;
else
   if  slud.alpha == 2  ||  slud.alpha == 4  % flat
      av='flat';
   else                                % interp
      av='interp';
   end
end



% val=[];
index=find(cell2num(get(handles.slice_view,'Value')));
coordinates=get(handles.slice_view,'UserData');
coordinate=coordinates{index};

switch coordinate

case 'x'
%	Read x-values
   val=str2num(get(handles.slice_xact,'String')); %#ok  More than one value possible
   if isempty(val)
      msgbox({['No "',options.xinfo{3},'" slice has been defined. Therefore no plot can be made.  '] , ...
               'Select a slice first.'},'Volume Browser - Slice')
      return
   end
   valname=options.xinfo{3};
   azimuth=90;
   elevation=0;

case 'y'
%	Read y-values
   val=str2num(get(handles.slice_yact,'String'));  %#ok  More than one value possible
   if isempty(val)
       msgbox({['No "',options.yinfo{3},'" slice has been defined. Therefore no plot can be made.  '] , ...
                'Select a slice first.'},'Volume Browser - Slice')
      return
   end
   valname=options.yinfo{3};
   azimuth=0;
   elevation=0;

case 'z'
%	Read z-values
   val=str2num(get(handles.slice_zact,'String')); %#ok  More than one value possible
   if isempty(val)
      msgbox({['No "',options.zinfo{3},'" slice has been defined. Therefore no plot can be made.    '] , ...
               'Select a slice first.'},'Volume Browser - Slice')
      return
   end
   valname=options.zinfo{3};
   azimuth=0;
   elevation=90;

end

figure_handle1=figure;
add_handle2delete1(figure_handle1,figure_handle)
label_and_time_stamp(options.plot_time,options.plot_label)

lval=length(val);    
if lval > 0
   if lval == 1
      pos=get(gca,'Position');
      set(gca,'Position',[pos(1:3),0.78])
      yloc=1;

   elseif lval == 2
      plotanzx=2;  % Number of subplots in the x-direction
      plotanzy=1;  % Number of subplots in the y-direction
%      pos=get(gca,'Position')
%      set(gca,'Position',[pos(1:3),0.70])
      yloc=0.97;

   elseif lval > 2  
      plotanzx=ceil(sqrt(lval));    % Number of subplots in the x-direction
      plotanzy=ceil(lval/plotanzx); % Number of subplots in the y-direction
%      pos=get(gca,'Position')
%      set(gca,'Position',[pos(1:3),0.70])
      yloc=0.97;
   end

%	Create plot/subplots
 

   for ii=1:lval
      if lval > 1
         subplot(plotanzy,plotanzx,ii);
      end
      titlestring=[valname,' = ',num2str(val(ii))]; 
      title(titlestring,'Color','red','FontWeight','demi');

%	Kamera setzen
      oldcamva=camva;
      myview(azimuth,elevation)
      camva(oldcamva);
      
      if options.equal_axes
         axis equal  %	Achsen proportional
      else
         axis normal 
      end

%	Axis lables
      xlabel(info2label(options.xinfo));
      ylabel(info2label(options.yinfo));
      zlabel(info2label(options.zinfo));
      % Eigenschaften der Achsen setzen
      set(gca,'Layer','top','Box','on');          % Achsen über Grafik zeichnen

      set(gca,'ZDir',options.zdir) % Set direction of z-axis

%	Achsenlimits setzen
      set(gca,'xlim',[min(ud.x) max(ud.x)]);
      set(gca,'ylim',[min(ud.y) max(ud.y)]);
      set(gca,'zlim',[min(ud.z) max(ud.z)]);
      hold on

%	Create requested slice
      switch coordinate
      case 'x'
	 V3D_SLICE = slice(ud.x,ud.y,ud.z,ud.v,val(ii),[],[],method_list{slud.method});
      case 'y'
	 V3D_SLICE = slice(ud.x,ud.y,ud.z,ud.v,[],val(ii),[],method_list{slud.method});
      case 'z'
	 V3D_SLICE = slice(ud.x,ud.y,ud.z,ud.v,[],[],val(ii),method_list{slud.method});
      end

%	Set plot attributes   
      set(V3D_SLICE,'FaceColor',slud.facecolor, ...
                    'EdgeColor',slud.edgecolor, ...
                    'FaceLighting',lighting_list{slud.lighting}, ...
                    'EdgeLighting',lighting_list{slud.lighting}, ...
                    'FaceAlpha',av, ...
                    'EdgeAlpha',av, ... 
                    'Tag','V3D:SLICE'); 

      % AlphaData = CData für Alphamap-Transparenz interp und flat setzen
      % alpha('color') geht nicht, da dies auch andere Objekte ausser V3d:SLICE Objekte verändert :(
      if slud.alpha == 2  ||  slud.alpha == 3 
         temp=findobj(gcf,'Tag','V3D:SLICE');
         for jj=1:length(temp)
             set(temp(jj),'AlphaData',get(temp(jj),'CData'));
         end
      end
      
      hold off
   end
end

 %	Plot figure suptitle (if requested)
fig_title=options.plot_title;
if ~isempty(fig_title)
   if ischar(fig_title)  ||  iscell(fig_title)
      mysuptitle(fig_title,{'yloc',yloc})
   else
      warndlg('The specified super title is not a string.')
   end
end
