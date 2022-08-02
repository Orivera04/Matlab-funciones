function solvmaze(x,y,dir)
%SOLVMAZE Recursive maze solution algorithm

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

global mazeMatrix mazeHndl doneFlag

i=sqrt(-1);

if get(gca,'UserData')~=1,
    return;
end;

set(mazeHndl,'XData',x,'YData',y);
drawnow;

% The solving method works like this:
% First try to turn right, then try straight,
% then turn to the left, then turn around and
% leave. The basic idea is "Keep your hand on the
% wall to your right."

initDir=dir*(-i);

for count=0:2,
    newDir=initDir*(i^count);
    xNew=x+real(newDir);
    yNew=y+imag(newDir);
    if mazeMatrix(xNew,yNew)==0,
    	solvmaze(xNew,yNew,newDir);
    elseif mazeMatrix(xNew,yNew)==2,
    	doneFlag=1;
    end;

    if doneFlag,
    	del=0.4;
    	patch([x-del x+del x+del x-del], ...
    	    [y-del y-del y+del y+del], ...
    	    [0 0.8 0], ...
    	    'EdgeColor','none', ...
    	    'EraseMode','none');
    	return;
    else
	set(mazeHndl,'XData',x,'YData',y);
	drawnow;
    end;

end;
