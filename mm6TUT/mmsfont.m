function C=mmsfont(H)
%MMSFONT Set Font Characteristics using a GUI. (MM)
% MMSFONT displays a dialog box for the user to select
% font characteristics.
%
% X = MMSFONT returns the handle of the text object.
%
% MMSFONT(H) where the input argument H is the handle of
% a valid text or axes object, uses the font characteristics
% of the object as the initial values.
%
% MMSFONT select   -or- 
% MMSFONT('select') waits for the user to click on a valid 
% graphics object, and uses the font characteristics
% of the object as the initial values.
%       
% If the initial values were obtained from an object or
% object handle, the 'Done' pushbutton will apply the 
% resulting text properties to the selected object.
%
% If no initial object handle is specified, a new text object is created 
% and the handle is returned in X. If 'Cancel' is pressed or an error
% occurs, X is set to 0.
%
% Examples:
%        mmsfont
%        mmsfont(H)
%        mmsfont select
%        Hx_obj=mmsfont('select')
%

% B.R. Littlefield, University of Maine, Orono ME 04469
% 5/24/95 revised 4/16/97, 5/1/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

%======================================================================
% Create some initial values, and start error checking.
%======================================================================

ermsg1 = 'Too many input arguments.';
ermsg2 = 'Input argument must be ''select'' or a text or axes handle.';
Hx_obj = -1;    % Pick an invalid handle.

if nargin > 2, error(ermsg1); end

%======================================================================
% Here the function was called with a single argument.  Check for 
% a valid string or object handle and bail out if invalid.
% Set the initial values if H is valid.
%======================================================================

if nargin == 1 
   
   %-------------------------------------------------------------------- 
   %  If H is 'select', get the handle of the selected object.
   %-------------------------------------------------------------------- 
   
   if ischar(H)
      if strcmp(H(1),'s')
         hh=get(0,'showhiddenhandles');
         set(0,'showhiddenhandles','on');
         if(waitforbuttonpress), return; end
         Hx_obj = get(gcf,'CurrentObject');
         set(0,'showhiddenhandles',hh);
         if isempty(Hx_obj), error('No object selected.'); end
      else
         error(ermsg2); 
      end 
      
      %-------------------------------------------------------------------- 
      %  Get the properties of the selected object and use them for the 
      %  initial values.
      %-------------------------------------------------------------------- 
      
   else
      if ishandle(H)
         Hx_obj = H;
      else
         error(ermsg2);
      end
   end
   
   if ishandle(Hx_obj)
      htype=get(Hx_obj,'Type');
      if ~(strcmp(htype,'text') | strcmp(htype,'axes'))
         error('Not a valid text or axes object.');
      end
   end
end

%======================================================================
% uisetfont now works for all platforms (as of 5.0), so use it.
%======================================================================

BoxTitle = 'MMSFONT: Select a font';

if ishandle(Hx_obj)
   H = uisetfont(Hx_obj,BoxTitle); 
   if nargout == 1, C=H; end
else
   H = uisetfont(BoxTitle); 
   C = H;
end

