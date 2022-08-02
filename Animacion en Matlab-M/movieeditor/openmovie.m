function movieout = openmovie
% M = OPENMOVIE opens a browser to select an avi-movie and converts this 
%      into a MATLAB-movie M.
% See also: MOVIEEDITOR
%
% Eduard van der Zwan 2005

[FileName,PathName] = uigetfile({'*.avi','Movie'},'Open Movie');
if FileName
	movieout = aviread([PathName,FileName]);
else
    movieout = false;
end