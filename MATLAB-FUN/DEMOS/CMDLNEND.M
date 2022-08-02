%CMDLNEND Cleans up after Expo command line demos.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

[existFlag,oldFigNumber]=figflag('Command Line Demos',1);
watchoff(oldFigNumber);
