function expomap(action)
%EXPOMAP Handles initialization and GUI interface for Expo maps.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin<1,
    action='showmain';
end;

%====================================
% Handle the SHOW events
if strcmp(action(1:4),'show'),
    [existFlag,figNumber]=figflag('Expo Map Window');
    if ~existFlag,
	expomap('initialize');
    	[existFlag,figNumber]=figflag('Expo Map Window');
    end;

    watchon;    
    colormap([0 0 0]);

    % Load map images from disk
    if strcmp(action,'showmain'),
    	load mainmap
  	mapIndex=1;
    elseif strcmp(action,'showmatlab'),
	load matmap
  	mapIndex=2;
    elseif strcmp(action,'showsimulink'),
	load simmap
  	mapIndex=3;
    elseif strcmp(action,'showtoolbox1'),
	load toolmap1
  	mapIndex=4;
    elseif strcmp(action,'showtoolbox2'),
	load toolmap2
  	mapIndex=5;
    elseif strcmp(action,'showtoolbox3'),
	load toolmap3
  	mapIndex=6;
    elseif strcmp(action,'showextras'),
	load extrmap
  	mapIndex=7;
    end;

    hndlMatrix=get(figNumber,'UserData');

    % Turn off old uicontrols, turn on new uicontrols
    oldMapIndex=get(gca,'UserData');
    if isempty(oldMapIndex), oldMapIndex=1; end

    offHndlVector=hndlMatrix(oldMapIndex,:);
    offHndlVector(find(offHndlVector==0))=[];
    onHndlVector=hndlMatrix(mapIndex,:);
    onHndlVector(find(onHndlVector==0))=[];

    set(offHndlVector,'Visible','off');
    set(onHndlVector,'Visible','on');

    set(gca,'UserData',mapIndex);
    colormap(cm);
    movie(mapImage,1);
    watchoff(figNumber);

%====================================
% Handle POPUP MENU event
elseif strcmp(action,'popupmenu'),
    popupHndl=gco;
    demoVal=get(popupHndl,'Value');
    % if demoVal=1, then take no action, because no demo has
    % been chosen (demoVal=1 -> 'Select a demo' option).
    if demoVal>1,
    	figNumber=watchon;
    	drawnow;
    	demoList=get(popupHndl,'UserData');
    	demoName=demoList(demoVal,:);
    	eval(demoName);
    	set(popupHndl,'Value',1);
    	watchoff(figNumber);
    end

%=====================================
% Handle HELP
elseif strcmp(action,'help'),
    ttlStr='MATLAB Expo Help';
    hlpStr= ...                                                        
        ['                                                '  
         ' Why Expo?                                      '  
         ' Because The MATLAB Expo is an exposition       '  
         ' of all the products sold by The MathWorks, Inc.'  
         ' Its purpose is to allow you to browse through  '  
         ' onscreen demos in whatever order and at        '  
         ' whatever rate you feel comfortable with.       '  
         '                                                '  
         ' How is it organized?                           '  
         ' The organization of the MATLAB Expo is         '  
         ' hierarchical. Four main areas are available for'  
         ' exploration from the Main Map. From these      '  
         ' subordinate maps, you can run specific demos   '  
         ' appropriate to that area.                      '  
         '                                                '  
         ' How do I navigate?                             '  
         ' Navigate by pointing and clicking your way     '  
         ' through the maps. As an alternative you can    '  
         ' navigate more quickly using the menu.          '];
    helpfun(ttlStr,hlpStr);                                            

%====================================
% Handle the ABOUT events

elseif strcmp(action,'aboutmain'),
    ttlStr='About the Expo...';
    hlpStr= ...                                               
        ['                                                 '  
         ' Welcome to the MATLAB Expo, an invitation to    '  
         ' explore the world of scientific and engineering '  
         ' software produced by The MathWorks, Inc.        '  
         '                                                 '  
         ' MATLAB, SIMULINK, and the MATLAB                '  
         ' Application Toolboxes represent the best        '  
         ' software your money can buy for state-of-the-   '  
         ' art computation, visualization, and simulation. '  
         '                                                 '  
         ' This collection of demos, built using MATLAB,   '  
         ' is designed to show you how these products      '  
         ' can make your life easier.                      '  
         '                                                 '  
         ' Just point and click your way to different areas'  
         ' that interest you. You can either use the       '  
         ' buttons on the screen or navigate with the      '  
         ' items in the menu bar. Enjoy!                   '];
    helpfun(ttlStr,hlpStr);                                   

elseif strcmp(action,'aboutmatlab'),
    ttlStr='About MATLAB...';
    hlpStr= ...                                              
        ['                                                '  
         ' MATLAB is an interactive program to help       '  
         ' you with numeric computation and data          '  
         ' visualization. Fundamentally, MATLAB is        '  
         ' built upon a foundation of sophisticated matrix'  
         ' software for analyzing linear systems of       '  
         ' equations.                                     '  
         '                                                '  
         ' The tools springing from these numerical       '  
         ' foundations have proven to be extraordinarily  '  
         ' versatile and capable in their ability to solve'  
         ' problems in applied math, physics, chemistry,  '  
         ' engineering, finance - almost any application  '  
         ' area that deals with complex numerical         '  
         ' calculations.                                  '  
         '                                                '  
         ' Run some demos available from the MATLAB       '  
         ' screen to see examples of MATLAB at work.      '];
    helpfun(ttlStr,hlpStr);                                  

elseif strcmp(action,'aboutsimulink'),
    ttlStr='About SIMULINK...';
    hlpStr= ...                                             
        ['                                               '  
         ' SIMULINK is a tool for modeling, analyzing,   '  
         ' and simulating an extraordinarily wide variety'  
         ' of physical and mathematical systems,         '  
         ' including those with nonlinear elements and   '  
         ' those which make use of continuous and        '  
         ' discrete time.                                '  
         '                                               '  
         ' As an extension of MATLAB, SIMULINK adds      '  
         ' many features specific to dynamic systems     '  
         ' while retaining all of MATLAB''s general       '  
         ' purpose functionality.                        '  
         '                                               '  
         ' Using SIMULINK, you model a system            '  
         ' graphically, sidestepping much of the nuisance'  
         ' associated with conventional programming.     '  
         '                                               '  
         ' Explore the demos available from the          '  
         ' SIMULINK screen to see more.                  '];
    helpfun(ttlStr,hlpStr);                                 

elseif strcmp(action,'abouttoolboxes'),
    ttlStr='About Toolboxes...';
    hlpStr= ...                                             
        ['                                               '  
         ' Toolboxes are specialized collections of      '  
         ' M-files (MATLAB language programs) built      '  
         ' specifically for solving particular classes of'  
         ' problems.                                     '  
         '                                               '  
         ' Our Toolboxes are more than just collections  '  
         ' of useful functions, though. They represent   '  
         ' the efforts of some of the world''s top        '  
         ' researchers in fields such as controls, signal'  
         ' processing, system identification, and others.'  
         '                                               '  
         ' Browse through the Toolbox screens to see     '  
         ' which toolboxes might be appropriate for the  '  
         ' work you do.                                  '];
    helpfun(ttlStr,hlpStr);                                 

elseif strcmp(action,'aboutextras'),
    ttlStr='About Extras...';
    hlpStr= ...                                           
        ['                                             '  
         ' The Fun/Extras screen is a place to put     '  
         ' interesting information and demos that don''t'  
         ' necessarily fit elsewhere. This includes    '  
         ' games, some miscellaneous demos, and        '  
         ' contact information for reaching The        '  
         ' MathWorks, Inc.                             '  
         '                                             '  
         ' This is a good place to browse around and   '  
         ' see the sorts of things that can be done    '  
         ' with MATLAB.                                '];
    helpfun(ttlStr,hlpStr);                               

%=====================================
% Handle INITIALIZATION
elseif strcmp(action,'initialize'),

    % Make sure the window is big enough
    figurePos=get(0,'DefaultFigurePosition');
    figurePos(3:4)=[560 420];

    figNumber=figure( ...
        'Name','Expo Map Window', ...
        'NumberTitle','off', ...
	'Visible','off', ...
	'Resize','off', ...
	'MenuBar','none', ...
	'Colormap',[], ...
	'Position',figurePos, ...
	'Pointer','watch');

    set(gca,'Position',[0 0 1 1]);
    axis off;
 
    % Initialize menu
    expomenu(figNumber);

    % Initialize map buttons
    % hndlMatrix is a matrix of handles to all uicontrols on the figure
    hndlMatrix=expobtns(figNumber);

    set(figNumber,'UserData',hndlMatrix);

    % The next line prevents people from accidentally plotting into
    % the small image axes.
    set(figNumber,'NextPlot','new');

    % Initialization is now complete.

end;  % if strcmp(action ...
