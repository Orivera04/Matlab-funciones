function close(h)
%CLOSE	Close specified window.
%	CLOSE(H) closes the window with handle H.
%	CLOSE, by itself, closes the current figure window.
%
%	CLOSE closes the window unconditionally and without confirmation.
%
%	CLOSE('name') closes the named window.
%
%	CLOSE ALL closes all the open windows.
%
%	See also DELETE.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	J.N. Little 1-7-92

if nargin == 0
    h = get(0,'Children');
    if ~isempty(h)
        h = gcf;
    else
        return
    end
end
if isstr(h)
   % It is a name, convert to handle
     hlist = get(0,'children')'; % Make sure hlist is a row
     id = 0;
     for i=hlist
       if strcmp(h,get(i,'name'))
         delete(i)
         id = 1;
       end
     end
     if id == 0
       if strcmp(lower(h),'all')
         % Close all
         delete(get(0,'children'))
       else
         error('Specified window does not exist.');
       end
    end
else
    delete(h)
end
