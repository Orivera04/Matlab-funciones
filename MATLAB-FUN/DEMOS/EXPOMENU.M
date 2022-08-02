function expomenu(figNumber)
%EXPOMENU Initializes Expo menubar.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% currentMap options
% main
% matlab
% simulink
% toolbox
% extras

if nargin<1,
    currentMap=' ';
end;

%====================================
% EXPO Menu
%====================================
h=uimenu(figNumber,'Label','Expo ');
    uimenu(h,'Label','About Expo...', ...
    	'Callback','expomap(''aboutmain'');');
    h2=uimenu(h,'Label','Go to Main Map', ...
	'Callback','expomap(''showmain'');');

    uimenu(h,'Label','Expo Help...', ...
    	'Callback','expomap(''help'')', ...
    	'Separator','on');
    uimenu(h,'Label','Close All Windows', ...
    	'Callback','close all');
    uimenu(h,'Label','Quit MATLAB', ...
    	'Callback','quit');

%====================================
% MATLAB Menu
%====================================
h=uimenu(figNumber,'Label','MATLAB ');
    uimenu(h,'Label','About MATLAB...', ...
    	'Callback','expomap(''aboutmatlab'');');
    h2=uimenu(h,'Label','Go to MATLAB Map', ...
    	'Callback','expomap(''showmatlab'');');

    h2=uimenu(h,'Label','Matrices', ...
    	'Separator','on');
    [labelList,nameList]=menulist('matlab','matrices');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Numerics');
    [labelList,nameList]=menulist('matlab','numerics');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Visualization');
    [labelList,nameList]=menulist('matlab','visualization');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Language');
    [labelList,nameList]=menulist('matlab','language');
    setmenu(h2,labelList,nameList);

%====================================
% SIMULINK Menu
%====================================
h=uimenu(figNumber,'Label','SIMULINK ');
    uimenu(h,'Label','About SIMULINK...', ...
    	'Callback','expomap(''aboutsimulink'');');
    h2=uimenu(h,'Label','Go to SIMULINK Map', ...
     	'Callback','expomap(''showsimulink'');');

    h2=uimenu(h,'Label','Simple Systems', ...
    	'Separator','on');
    [labelList,nameList]=menulist('simulink','simple');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Complex Systems');
    [labelList,nameList]=menulist('simulink','complex');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Advanced Products');
    [labelList,nameList]=menulist('simulink','advanced');
    setmenu(h2,labelList,nameList);

%====================================
% TOOLBOXES Menu
%====================================
h=uimenu(figNumber,'Label','Toolboxes ');
    uimenu(h,'Label','About Toolboxes...', ...
    	'Callback','expomap(''abouttoolboxes'');');
    h2=uimenu(h,'Label','Go to Toolbox Map');
    labelList=[
	'Toolbox Map 1'
	'Toolbox Map 2'
	'Toolbox Map 3'];
    nameList=[
	'expomap(''showtoolbox1'');'
	'expomap(''showtoolbox2'');'
	'expomap(''showtoolbox3'');'];
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Signal Processing', ...
    	'Separator','on');
    [labelList,nameList]=menulist('toolbox1','signal');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','System ID');
    [labelList,nameList]=menulist('toolbox1','sysid');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Optimization');
    [labelList,nameList]=menulist('toolbox1','optim');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Neural Network');
    [labelList,nameList]=menulist('toolbox1','neural');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Control System');
    [labelList,nameList]=menulist('toolbox2','control');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Robust Control');
    [labelList,nameList]=menulist('toolbox2','robust');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Mu-Tools');
    [labelList,nameList]=menulist('toolbox2','mutools');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Spline');
    [labelList,nameList]=menulist('toolbox2','spline');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Symbolic Math');
    [labelList,nameList]=menulist('toolbox2','symbolic');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Image Processing');
    [labelList,nameList]=menulist('toolbox2','images');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Statistics');
    [labelList,nameList]=menulist('toolbox2','stats');
    setmenu(h2,labelList,nameList);

%====================================
% EXTRAS Menu
%====================================
h=uimenu(figNumber,'Label','Fun/Extras ');
    uimenu(h,'Label','About Extras...', ...
    	'Callback','expomap(''aboutextras'');');
    h2=uimenu(h,'Label','Go to Extras Map', ...
    	'Callback','expomap(''showextras'');');

    h2=uimenu(h,'Label','Gallery', ...
    	'Separator','on');
    [labelList,nameList]=menulist('extras','gallery');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Games');
    [labelList,nameList]=menulist('extras','games');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Miscellaneous');
    [labelList,nameList]=menulist('extras','misc');
    setmenu(h2,labelList,nameList);

    h2=uimenu(h,'Label','Contact Info');
    [labelList,nameList]=menulist('extras','contact');
    setmenu(h2,labelList,nameList);
