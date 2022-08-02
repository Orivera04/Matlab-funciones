function y=mmxgrid(arg)
%MMXGRID X-axes Grid Lines.
% MMXGRID ON adds grid lines along the X-axes of the
% current axes.
% MMXGRID OFF turns them off.
% MMXGRID by itself toggles the X-axes grid state.
%
% TF=MMXGRID returns logical True if the X-axes grid is ON.
% Otherwise it returns logical False.
%
% See also GRID, XLIM, XLABEL

if nargin~=0
   if ischar(arg)
      if length(arg)>1 & strncmpi(arg,'on',2)
         set(gca,'XGrid','on')
      elseif length(arg)>1 & strncmpi(arg,'off',3)
         set(gca,'XGrid','off')
      else
         error('Unknown Input Argument.')
      end
   else
      error('Character Input Argument Required.')
   end
elseif nargout~=0
   y=strcmp(get(gca,'XGrid'),'on');
else
   if strcmp(get(gca,'XGrid'),'on')
      set(gca,'XGrid','off')
   else
      set(gca,'XGrid','on')
   end
end
