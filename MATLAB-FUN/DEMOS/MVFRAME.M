function frameData=mvframe(figNumber,totalFrames)
%MVFRAME This is a function that is used with the function XPMOVIE.
%	MVSTORE(figNumber,movieData) stores the movie in the variable 
%	movieData in the UserData of the figure figNumber for later 
%	use.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% On PCs with less than 16 colors movies will break.
if get(0,'ScreenDepth')<=4,
    computerType=computer;
    if strcmp(computerType(1:2),'PC'),
	frameData=zeros(size(moviein(1)));
	return
    end
end

if figNumber==0,
    frameData=getframe;

else
    frameData=getframe;

    hndlList=get(figNumber,'UserData');
    movieAxHndl=hndlList(8);
    statusAxHndl=hndlList(9);
    status=get(statusAxHndl,'UserData');

    axes(statusAxHndl);
    status=status+1;
    xpatch=[0 status status 0]/totalFrames;
    ypatch=[0 0 1 1];
    patch(xpatch,ypatch,'r','EdgeColor','w','EraseMode','none');
    view(2);
    set(statusAxHndl,'UserData',status);
        
    axes(movieAxHndl);
end
