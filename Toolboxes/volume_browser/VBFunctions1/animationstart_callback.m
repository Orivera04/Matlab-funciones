function animationstart_callback(h, eventdata, handles, varargin) %#ok Used in callback
% Sliceomat: Animation

global V3D_HANDLES

% Werte auslesen
xmin=str2double(get(handles.sliceomat_xmin,'string'));
xmax=str2double(get(handles.sliceomat_xmax,'string'));
ymin=str2double(get(handles.sliceomat_ymin,'string'));
ymax=str2double(get(handles.sliceomat_ymax,'string'));
zmin=str2double(get(handles.sliceomat_zmin,'string'));
zmax=str2double(get(handles.sliceomat_zmax,'string'));
anz=str2double(get(handles.sliceomat_steps,'string'));

%   Pause/Delay testen und ggf. anpassen
if str2double(get(handles.sliceomat_delay,'String')) < 0
    set(handles.sliceomat_delay,'String','0.1');
end

%	Set direction of animation
loop=0:anz;
if get(handles.sliceomat_reverse,'Value')
    loop=fliplr(loop);
end

jj=0;

makemovie=get(handles.sliceomat_movie,'Value');
if makemovie
%	Reserve room for film
   nloop=length(loop);
   film=struct('cdata',[],'colormap',[]);
   film=film(ones(1,nloop));
end

% wenn irgendeine Achse aktiviert
if get(handles.sliceomat_x,'Value') ||  get(handles.sliceomat_y,'Value') ...
                                    ||  get(handles.sliceomat_z,'Value')
   set(handles.cancel,'UserData',0)
   for ii=loop % Schleife loop von 0 bis anz bzw. reverse
      % X-Achse aktiviert
      if get(handles.sliceomat_x,'Value')              
          % xact berechnen abhängig von i und anz
          xact=(((xmax-xmin)/anz)*ii)+xmin;               
          % xact aktualisieren
          set(handles.sliceomat_xact,'string',num2str(xact));     
      end
      % Y-Achse aktiviert
      if get(handles.sliceomat_y,'Value')
          yact=(((ymax-ymin)/anz)*ii)+ymin;
          set(handles.sliceomat_yact,'string',num2str(yact));
      end
      % Z-Achse aktiviert
      if get(handles.sliceomat_z,'Value')
         zact=(((zmax-zmin)/anz)*ii)+zmin;
         set(handles.sliceomat_zact,'string',num2str(zact));
      end
      % Aufruf der Sliceomat Funktion -> Visualisierung des Slices
      sliceomat_key_callback(h, eventdata, handles, varargin);
      % Pause/Delay
      
      % Movie-Checkbox aktiviert?
      if makemovie
         jj=jj+1;
         film(jj)=getframe(V3D_HANDLES.figure_handle); % Bild speichern (capture)
      end
      
      terminate=get(handles.cancel,'UserData');
      pause(str2double(get(handles.sliceomat_delay,'String')));
      drawnow
      if terminate	% Terminate animation
         set(handles.cancel,'UserData',0)
	 break
      end
   end
end

% Movie-Checkbox aktiviert?
if get(handles.sliceomat_movie,'Value')
    % wenn filename angegeben
   filename=get(handles.sliceomat_filename,'String');
   if ischar(filename)  && ~isempty(filename)
        % filename zerteilen
      [dummy,name] = fileparts(filename); %#ok First output argument is not required
        % falls Dateiname vorhanden
      if ~isempty(name)
         fid=fopen(filename,'w');  % Check if the file can be opend for writing
         if fid < 0
            warndlg(['Selected file, "',filename, ...
                     ' ", cannot be created or exists alreadey and is used by another program.'])
         else
            fclose(fid);
                 % Moviedatei unkomprimiert und bester Qualität abspeichern
            movie2avi(film,filename,'compression','none','quality',100);
            try
               fclose(fid);
            catch
            end
         end
      end        
   end
end
