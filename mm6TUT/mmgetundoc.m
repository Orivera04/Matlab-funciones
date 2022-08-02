function mmgetundoc(arg)
%MMGETUNDOC Get Undocumented Object Properties. (MM)
% MMGETUNDOC OBJECT or MMGETUNDOC(H) displays a list of
% undocumented property names for the handle graphics object
% having handle H or indentified by the string OBJECT.
%
% For example MMGETUNDOC axes  or MMGETUNDOC(gca) return
% undocumented property names for the axes object.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 1/29/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin~=1
   error('One Input Required.')
end
if ischar(arg) % MMGETUNDOC OBJECT
   arg=lower(arg);
   if strcmp(arg,'root')
      h=0;
      dfig=0;
   elseif strcmp(arg,'figure')
      h=get(0,'CurrentFigure');
      if isempty(h)
         h=figure('Visible','off');
         dfig=h;
      else
         dfig=0;
      end
   else
      hfig=get(0,'CurrentFigure');
      if isempty(hfig)
         hfig=figure('Visible','off');
         dfig=hfig;
      else
         dfig=0;
      end
      h=eval([arg '(''Visible'',''off'')'],'[]');
      if isempty(h)
         if dfig~=0
            delete(dfig)
         end
         error('Unknown Object Type Requested.')
      end
   end
elseif ishandle(arg) % MMGETUNDOC(H)
   h=arg;
   dfig=0;
else
   error('Handle Does Not Exist.')
end
wstate=warning;
warning off                      % supress warnings about obsolete properties
set(0,'HideUndocumented','off')
undocfnames=fieldnames(get(h));           % get props including undocumented
set(0,'HideUndocumented','on')
docfnames=fieldnames(get(h));             % get props excluding undocumented
undoclist=setdiff(undocfnames,docfnames); % extract undocumented
if ~isempty(undoclist)
   disp(['Undocumented ' upper(get(h,'type')) ' Object Properties:'])
   disp(undoclist)
else
   disp([upper(get(h,'type')) ' Object Has No Undocumented Properties.'])
end
if dfig~=0        % delete hidden figure holding selected object
   delete(dfig)
end
warning(wstate)