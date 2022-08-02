function maxfigsize(Hf,c)
%MAXFIGSIZE Resize Figure to Maximum Available.
% MAXFIGSIZE resizes the current figure to the maximum
% allowable on the current monitor.
% MAXFIGSIZE(Hf) resizes the figure having handle Hf to
% the maximum allowable on the current monitor.
%
% MAXFIGSIZE restore  or MAXFIGSIZE('restore') or
% MAXFIGSIZE(Ha,'restore') restores the figure to its
% previous size.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 02/19/2003

true=logical(1);
false=~true;
if nargin==0
   Hf=get(0,'CurrentFigure');
   restore=false;
elseif nargin==1
   if ischar(Hf)&strncmpi(Hf,'r',1)
      restore=true;
      Hf=get(0,'CurrentFigure');
   elseif ishandle(Hf)
      restore=false;
   else
      error('Argument Must be a Handle or "restore".')
   end
elseif nargin==2
   if ~ischar(c)&strncmpi(Hf,'r',1)
      error('Second Argument Must be "restore".')
   end
   restore=true;
end
if isempty(Hf)
   error('No Figure Available.')
elseif ~ishandle(Hf)|~strcmpi(get(Hf,'type'),'Figure')
   error('Handle Unknown or Not a Figure Handle.')
elseif numel(Hf)~=1
   error('Only One Figure Handle Allowed.')
end
if restore
   fsize=getappdata(Hf,'maxfigsize');
   if isempty(fsize)
      error('No Figure Found.')
   end
   funits=get(Hf,'Units');
   set(Hf,'units','pixels','position',fsize,'units',funits)
   rmappdata(Hf,'maxfigsize')
   
else  % maximize
   
   sunits=get(0,'Units');
   set(0,'Units','pixels');
   ssize=get(0,'ScreenSize');
   set(0,'Units',sunits)
   
   funits=get(Hf,'Units');
   set(Hf,'Units','pixels')
   fsize=get(Hf,'Position');
   set(Hf,'Units',funits)
   setappdata(Hf,'maxfigsize',fsize)
   
   % Make room for taskbar under Windoze
   ssize=ssize+ispc*[0 40 0 -40];
   
   set(Hf,'outerposition',ssize)
   
end