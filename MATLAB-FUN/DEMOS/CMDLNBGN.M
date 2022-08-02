%CMDLNBGN Sets up command line demos for the Expo.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Here's the idea: we only want to have ONE unassigned, unnamed command line
% demo figure running around in order to avoid window proliferation. So since
% every other Expo demo figure has a name, before we run any of the old demos
% we'll first check to see if an unnamed figure is lying around.

if figureNeededFlag,
    oldFigNumber=watchon;

    [existFlag,figNumber]=figflag([],1);

    if ~existFlag,
    	pos=get(0,'DefaultFigurePosition');
	% Adjust the window down and to the left so that it doesn't
	% completely obscure the Expo Map window.
    	pos=pos+[-50 -50 0 0];
    	figNumber=figure('Position',pos);
    else
    	figNumber=figNumber(1);
    end

    figure(figNumber);

    clear figNumber

end

clc

