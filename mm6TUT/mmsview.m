function mmsview(cmd)
%MMSVIEW Set Azimuth and Elevation using a GUI. (MM)
% MMSVIEW adds sliders and text boxes to the current figure window
% for adjusting azimuth and elevation using the mouse.
%
% The 'Revert' pushbutton reverts to the original view.
% The '2-D' pushbutton resets to a standard 2-D view.
% The '3-D' pushbutton resets to a standard 3-D view.
% The 'Done' pushbutton removes all Uicontrols.
%
% See also: VIEW, ROTATE3D.

% The 'cmd' argument executes the callbacks.
% Calls: mmgcf, mmdeal.

% B.R. Littlefield, University of Maine, Orono, ME 04469
% 4/11/95, revised 9/19/96, 5/2/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8

Hf_fig = mmgcf;
if isempty(Hf_fig), error('No figure found.'); end

%======================================================================
% If this is an initial call, create the uicontrols.
%======================================================================

if nargin == 0
   
   %--------------------------------------------------------------------
   % Get the current view for slider initial values.
   % If the view is out of range, adjust as best we can.
   % Use normalized uicontrol units rather than the default 'pixels'.
   %--------------------------------------------------------------------
   
   CVIEW = get(gca,'View');
   if abs(CVIEW(1))>180, CVIEW(1)=CVIEW(1)-(360*sign(CVIEW(1))); end
   set(Hf_fig,'DefaultUicontrolUnits','normalized');
   fbg = get(Hf_fig,'Color');
   
   %--------------------------------------------------------------------
   % Define azimuth and elevation sliders.
   % The position is in normalized units (0-1).  
   % Maximum, minimum, and initial values are set.
   %--------------------------------------------------------------------
   
   Hc_asli = uicontrol( Hf_fig,'style','slider',...
      'position',[.084 .01 .256 .045],...
      'min',-180,'max',180,'value',CVIEW(1),...
      'callback','mmsview(991)');
   
   Hc_esli = uicontrol( Hf_fig,'style','slider',...
      'position',[.95 .155 .035 .42],...
      'min',-90,'max',90,'val',CVIEW(2),...
      'callback','mmsview(992)');
   
   %--------------------------------------------------------------------
   % Place the text boxes showing the minimum and max values at the
   % ends of each slider.  These are text displays, and cannot be edited.
   %--------------------------------------------------------------------
   
   uicontrol(Hf_fig,'style','text','backgroundcolor',fbg,...
      'pos',[.02 .01 .065 .045],...
      'string',num2str(get(Hc_asli,'min')));
   
   uicontrol(Hf_fig,'style','text','backgroundcolor',fbg,...
      'pos',[.34 .01 .065 .045],...
      'string',num2str(get(Hc_asli,'max')));
   
   uicontrol(Hf_fig,'style','text','backgroundcolor',fbg,...
      'pos',[.94 .11 .05 .045],...
      'string',num2str(get(Hc_esli,'min')));
   
   uicontrol(Hf_fig,'style','text','backgroundcolor',fbg,...
      'pos',[.94 .57 .05 .045],...
      'string',num2str(get(Hc_esli,'max')));
   
   %--------------------------------------------------------------------
   % Place labels for each slider
   %--------------------------------------------------------------------
   
   uicontrol(Hf_fig,'style','text','backgroundcolor',fbg,...
      'pos',[.095 .06 .11 .045],...
      'string','Azimuth:');
   
   uicontrol(Hf_fig,'style','text','backgroundcolor',fbg,...
      'pos',[.885 .06 .11 .045],...
      'string','Elevation:');
   
   %--------------------------------------------------------------------
   % Define the current value text displays for each slider.
   %--------------------------------------------------------------------
   % These are editable text displays to display the current value
   % of the slider and at the same time allow the user to enter
   % a value using the keyboard.
   %
   % Note that on the text is centered on X Window Systems, but is
   % left-justified on MS-Windows and Macintosh machines.
   %
   % The initial value is found from the value of the sliders.
   % When text is entered into the text area and the return key is
   % pressed, the callback string is evaluated.
   %--------------------------------------------------------------------
   
   Hc_acur = uicontrol(Hf_fig,'style','edit',...
      'pos',[.225 .06 .11 .045],...
      'string',sprintf('%0.2f',get(Hc_asli,'val')),...
      'callback','mmsview(993)');
   
   Hc_ecur = uicontrol(Hf_fig,'style','edit',...
      'pos',[.885 .01 .11 .045],...
      'string',sprintf('%0.2f',get(Hc_esli,'val')),...
      'callback','mmsview(994)');
   
   %--------------------------------------------------------------------
   % Create a frame for some pushbutton uicontrols.
   %--------------------------------------------------------------------
   
   uicontrol(Hf_fig,'style','frame','position',[.435 .005 .425 .07]);
   
   %--------------------------------------------------------------------
   % Place a 'Revert' button in the button frame.
   % When clicked, the view reverts to the original view.
   %--------------------------------------------------------------------
   
   uicontrol(Hf_fig,'style','push',...
      'pos',[.44 .01 .10 .06],...
      'string','Revert',...
      'callback','mmsview(995)');
   
   %--------------------------------------------------------------------
   % Place a '2-D' button in the button frame.
   % When clicked, the view reverts to a standard 2-D view.
   %--------------------------------------------------------------------
   
   uicontrol(Hf_fig,'style','push',...
      'pos',[.545 .01 .10 .06],...
      'string','2-D',...
      'callback','mmsview(996)');
   
   %--------------------------------------------------------------------
   % Place a '3-D' button in the button frame.
   % When clicked, the view reverts to a standard 3-D view.
   %--------------------------------------------------------------------
   
   uicontrol(Hf_fig,'style','push',...
      'pos',[.65 .01 .10 .06],...
      'string','3-D',...
      'callback','mmsview(997)');
   
   %--------------------------------------------------------------------
   % Place a 'Done' button in the button frame.
   % When clicked, all of the uicontrols will be erased.
   %--------------------------------------------------------------------
   
   uicontrol(Hf_fig,'style','push',...
      'pos',[.755 .01 .10 .06],...
      'string','Done',...
      'callback',[...
         'delete(findobj(gcf,''Type'',''uicontrol'')),',...
         'set(gcf,''DefaultUicontrolUnits'',',...
         'get(0,''DefaultUicontrolUnits''))']);
   
   %--------------------------------------------------------------------
   % Store the original view and some handles for use in the callbacks.
   %--------------------------------------------------------------------
   
   set(Hf_fig,'Userdata',[Hc_asli Hc_acur Hc_esli Hc_ecur CVIEW(1) CVIEW(2)]); 
   
else
   
   %======================================================================
   % This is the callback section.
   %======================================================================
   
   %--------------------------------------------------------------------
   % Retrieve the original view and object handles.
   %--------------------------------------------------------------------
   
   [Hc_asli Hc_acur Hc_esli Hc_ecur CVIEW(1) CVIEW(2)] = ...
      mmdeal(get(Hf_fig,'Userdata')); 
   
   %--------------------------------------------------------------------
   % The callbacks for the azimuth and elevation sliders:
   %--------------------------------------------------------------------
   %   1) get the value of the slider and display it in the text window
   %   2) set the 'View' property to the current values of the azimuth 
   %        and elevation sliders.
   %--------------------------------------------------------------------
   
   if cmd == 991
      set(Hc_acur,'string',sprintf('%0.2f',get(Hc_asli,'val')));
      set(gca,'View',[get(Hc_asli,'val'),get(Hc_esli,'val')]);
      
   elseif cmd == 992
      set(Hc_ecur,'string',sprintf('%0.2f',get(Hc_esli,'val')));
      set(gca,'View',[get(Hc_asli,'val'),get(Hc_esli,'val')]);
      
      %--------------------------------------------------------------------
      % The 'slider current value' text display callbacks:
      %--------------------------------------------------------------------
      % When text is entered into the text area and the return key is
      % pressed, the entered value is compared to the limits.
      %
      % If the limits have been exceeded, the display is reset to the 
      % value of the slider and an error message is displayed.
      %
      % If the value is within the limits, the slider is set to the 
      % new value, and the view is updated.
      %--------------------------------------------------------------------
      
   elseif cmd == 993
      if str2num(get(Hc_acur,'string')) < get(Hc_asli,'min')...
            | str2num(get(Hc_acur,'string')) > get(Hc_asli,'max')
         set(Hc_acur,'string',sprintf('%0.2f',get(Hc_asli,'val')));
         disp('ERROR - Value out of range');
      else
         set(Hc_asli,'val',str2num(get(Hc_acur,'string')));
         set(gca,'View',[get(Hc_asli,'val'),get(Hc_esli,'val')]);
      end
      
   elseif cmd == 994
      if str2num(get(Hc_ecur,'string')) < get(Hc_esli,'min')...
            | str2num(get(Hc_ecur,'string')) > get(Hc_esli,'max')
         set(Hc_ecur,'string',sprintf('%0.2f',get(Hc_esli,'val')));
         disp('ERROR - Value out of range');
      else
         set(Hc_esli,'val',str2num(get(Hc_ecur,'string')));
         set(gca,'View',[get(Hc_asli,'val'),get(Hc_esli,'val')]);
      end
      
      %--------------------------------------------------------------------
      % Revert to the original view.
      %--------------------------------------------------------------------
      
   elseif cmd == 995
      set(Hc_asli,'val',CVIEW(1));
      set(Hc_esli,'val',CVIEW(2));
      set(Hc_acur,'string',sprintf('%0.2f',get(Hc_asli,'val')));
      set(Hc_ecur,'string',sprintf('%0.2f',get(Hc_esli,'val')));
      set(gca,'View',[get(Hc_asli,'val'),get(Hc_esli,'val')]);
      
      %--------------------------------------------------------------------
      % Change to a 2-D view.
      %--------------------------------------------------------------------
      
   elseif cmd == 996
      set(Hc_asli,'val',0);
      set(Hc_esli,'val',90);
      set(Hc_acur,'string',sprintf('%0.2f',get(Hc_asli,'val')));
      set(Hc_ecur,'string',sprintf('%0.2f',get(Hc_esli,'val')));
      set(gca,'View',[get(Hc_asli,'val'),get(Hc_esli,'val')]);
      
      %--------------------------------------------------------------------
      % Change to a 3-D view.
      %--------------------------------------------------------------------
      
   elseif cmd == 997
      set(Hc_asli,'val',-37.5);
      set(Hc_esli,'val',30);
      set(Hc_acur,'string',sprintf('%0.2f',get(Hc_asli,'val')));
      set(Hc_ecur,'string',sprintf('%0.2f',get(Hc_esli,'val')));
      set(gca,'View',[get(Hc_asli,'val'),get(Hc_esli,'val')]);
      
      %--------------------------------------------------------------------
      % Must be bad arguments.
      %--------------------------------------------------------------------
      
   else
      disp('MMSVIEW: Illegal argument.')
   end
end
