function maze(x,y)
%MAZE	Recursvie maze construction algorithm.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

global mazeMatrix mazeHndl

if get(gca,'UserData')~=1,
    return;
end;

mazeMatrix(x,y)=0;
del=0.65;
patch([x-del x+del x+del x-del], ...
    [y-del y-del y+del y+del], ...
    [1 1 1], ...
    'EdgeColor','none', ...
    'EraseMode','none');
set(mazeHndl,'XData',x,'YData',y);
drawnow;

dirList=randperm(4);
for count=1:4,
    direction=dirList(count);

    if direction==1,
	% Direction NORTH
    	xNew=x; yNew=y+1;
        xIndex=x-1:x+1;
	yIndex=y+1:y+2;
    elseif direction==2,
	% Direction EAST
    	xNew=x+1; yNew=y;
        xIndex=x+1:x+2;
	yIndex=y-1:y+1;	    
    elseif direction==3,
	% Direction SOUTH
    	xNew=x; yNew=y-1;
        xIndex=x-1:x+1;
	yIndex=y-2:y-1;
    elseif direction==4,
	% Direction WEST
    	xNew=x-1; yNew=y;
        xIndex=x-2:x-1;
	yIndex=y-1:y+1;	    
    end;

    if all(all(mazeMatrix(xIndex,yIndex))),
	maze(xNew,yNew);
	drawnow;
    end;

end;    % For count= ...

set(mazeHndl,'XData',x,'YData',y);


