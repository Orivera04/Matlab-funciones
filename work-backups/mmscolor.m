function C=mmscolor(H)
%MMSCOLOR Set RGB Specification using a GUI. (MM)
% MMSCOLOR displays a dialog box for the user to select
% a color interactively and displays the result.
%
% X = MMSCOLOR returns the selected color in X.
%
% MMSCOLOR([r g b]) uses the RGB triple as the initial
% RGB value for modification.
%
% MMSCOLOR C  -or-
% MMSCOLOR('C') where C is a color spec (y,m,c,r,g,b,w,k), uses 
% the specified color as the initial value.
%
% MMSCOLOR(H) where the input argument H is the handle of
% a valid graphics object that supports color, uses the color
% property of the object as the initial RGB value.
%
% MMSCOLOR select   -or- 
% MMSCOLOR('select') waits for the user to click on a valid 
% graphics object that supports color, and uses the color
% property of the object as the initial RGB value.
%       
% If the initial RGB value was obtained from an object or
% object handle, the 'Ok' or 'Done' pushbutton will apply the 
% resulting color property to the selected object.
%
% If no initial color is specified, black will be used.
%
% Examples:
%        mmscolor
%        mycolor=mmscolor
%        mmscolor([.25 .62 .54])
%        mmscolor(H)
%        mmscolor g
%        mmscolor red
%        mmscolor select
%        mycolor=mmscolor('select')
%

% Calls: mmsetc, mmrgb, mminor

% B.R. Littlefield, University of Maine, Orono, ME 04469
% 3/2/95 revised 4/25/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8

%======================================================================
% define some strings, and start error checking.
%======================================================================

ermsg1 = 'Too many input arguments.';
ermsg2 = 'Invalid input argument(s).';

if nargin > 2, error(ermsg1); end

%======================================================================
%  This section handles the 'no argument' case and sets the defaults.
%======================================================================

initrgb = [0 0 0];
Hx_obj = -1;

%======================================================================
% Here the function was called with a single argument.  Check for 
% a valid RGB triple or an object handle and bail out if invalid.
% Set the initial color value if H is valid.
%======================================================================

if nargin == 1 
   
   if ischar(H)
      
      %-------------------------------------------------------------------- 
      %  If H is 'select', get the color property of the selected object
      %  for the initial color. Otherwise, assume H is a colorspec.
      %-------------------------------------------------------------------- 
      
      Hx_obj = -1;
      if strcmp(H(1),'s')
         hh=get(0,'showhiddenhandles');
         set(0,'showhiddenhandles','on');
         waitforbuttonpress;
         Hx_obj = get(gcf,'CurrentObject');
         set(0,'showhiddenhandles',hh);
         if isempty(Hx_obj), error('No object selected.'); end
         typ=get(Hx_obj,'Type');
         if strcmp(typ(1:2),'ui')
            initrgb = get(Hx_obj,'ForegroundColor');
         else
            initrgb = get(Hx_obj,'Color');
         end
         if ischar(initrgb), initrgb = get(gcf,'color'); end
      else
         initrgb=mmrgb(H(1));
      end
      if isempty(initrgb)
         error(ermsg2); 
      end 
      
   else
      
      %-------------------------------------------------------------------- 
      %  Otherwise H should be an RGB triple or an object handle.
      %-------------------------------------------------------------------- 
      
      [n m]=size(H);
      if n ~= 1, error(ermsg2); end  
      
      %-------------------------------------------------------------------- 
      %  If H is a valid RGB row vector, use it for the initial color.
      %-------------------------------------------------------------------- 
      
      if m == 3 & max(H) <= 1 & min(H) >= 0  
         initrgb = H;
         
         %-------------------------------------------------------------------- 
         %  If H is a single number, it should be an object handle.
         %  If the handle is invalid or the object has no 'color' property, 
         %  get() will exit with an error message.
         %-------------------------------------------------------------------- 
         
      elseif m == 1   
         Hx_obj = H;
         typ=get(Hx_obj,'Type');
         if strcmp(typ(1:2),'ui')
            initrgb = get(Hx_obj,'ForegroundColor');
         else
            initrgb = get(Hx_obj,'Color');
         end
         if ischar(initrgb), initrgb = get(gcf,'color'); end
         
         %-------------------------------------------------------------------- 
         %  Otherwise, H is invalid, so bail out.
         %-------------------------------------------------------------------- 
         
      else
         error(ermsg2);
      end
   end
end

%======================================================================
% uisetcolor now works for all platforms (as of v5.1), so use it.
%======================================================================

BoxTitle = 'MMSCOLOR: Select a color';

if ishandle(Hx_obj)
   H = uisetcolor(Hx_obj,BoxTitle);  % select color and apply to object
   if nargout > 0, C=H; end
else
   C = uisetcolor(initrgb,BoxTitle); % make the color selection
end

