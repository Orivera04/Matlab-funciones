function hndlMatrix=expobtns(figNumber)
%EXPOBTNS Initializes all uicontrol buttons on the Expo map screen.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

    % Initialize info for all buttons
    % Startup constants
    % Constants in pixel units
    pxBtnHt=25;
    pxBtnWid=160;
    pxGap=4;
    btnColor=[192 192 192]/255;
    btnTextColor=[0 0 0];

    %=====================================
    % Initialize the WELCOME Region
    xRef=172-pxBtnWid/2;
    yRef=125+fix((3*pxBtnHt-2*pxGap)/2);

    buttonCallbackStr='expomap(''aboutmain'');';
    mainHndl(1)=uicontrol(figNumber, ...
	'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
	'ForegroundColor',btnTextColor, ...
        'String','About the Expo...', ...
	'Visible','off', ...
	'Callback',buttonCallbackStr);

    mainHndl(2)=uicontrol(figNumber, ...
	'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt-(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
	'ForegroundColor',btnTextColor, ...
        'String','Expo Help...', ...
	'Visible','off', ...
        'Callback','expomap(''help'');');

    mainHndl(3)=uicontrol(figNumber, ...
	'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
	'ForegroundColor',btnTextColor, ...
        'String','Close All Windows', ...
	'Visible','off', ...
        'Callback','close all;');

    %=====================================
    % Initialize the MATLAB Region
    pxBtnWid=100;
    pxBtnHt=25;
    xRef=438;
    yRef=382;
    visitBtnCallbackStr='expomap(''showmatlab'');';
    infoBtnCallbackStr='expomap(''aboutmatlab'');';
    mainHndl(4)=uicontrol(figNumber, ...
	'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[ xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
	'ForegroundColor',btnTextColor, ...
        'String','Visit', ...
	'Visible','off', ...
        'Callback',visitBtnCallbackStr);
    mainHndl(5)=uicontrol(figNumber, ...
	'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt-(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
	'ForegroundColor',btnTextColor, ...
        'String','Info...', ...
	'Visible','off', ...
        'Callback',infoBtnCallbackStr);

    %=====================================
    % Initialize the SIMULINK Region
    yRef=281;
    visitBtnCallbackStr='expomap(''showsimulink'');';
    infoBtnCallbackStr='expomap(''aboutsimulink'');';

    mainHndl(6)=uicontrol(figNumber, ...
	'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[ xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
	'ForegroundColor',btnTextColor, ...
        'String','Visit', ...
	'Visible','off', ...
        'Callback',visitBtnCallbackStr);
    mainHndl(7)=uicontrol(figNumber, ...
	'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt-(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
	'ForegroundColor',btnTextColor, ...
        'String','Info...', ...
	'Visible','off', ...
        'Callback',infoBtnCallbackStr);

    %=====================================
    % Initialize the TOOLBOX Region
    yRef=182;
    visitBtnCallbackStr='expomap(''showtoolbox1'');';
    infoBtnCallbackStr='expomap(''abouttoolboxes'');';

    mainHndl(8)=uicontrol(figNumber, ...
	'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[ xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
	'ForegroundColor',btnTextColor, ...
        'String','Visit', ...
	'Visible','off', ...
        'Callback',visitBtnCallbackStr);
    mainHndl(9)=uicontrol(figNumber, ...
	'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt-(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
	'ForegroundColor',btnTextColor, ...
        'String','Info...', ...
	'Visible','off', ...
        'Callback',infoBtnCallbackStr);

    %=====================================
    % Initialize the FUN/EXTRAS Region
    yRef=84;
    visitBtnCallbackStr='expomap(''showextras'');';
    infoBtnCallbackStr='expomap(''aboutextras'');';

    mainHndl(10)=uicontrol(figNumber, ...
	'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[ xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
	'ForegroundColor',btnTextColor, ...
        'String','Visit', ...
	'Visible','off', ...
        'Callback',visitBtnCallbackStr);
    mainHndl(11)=uicontrol(figNumber, ...
	'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt-(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
	'ForegroundColor',btnTextColor, ...
        'String','Info...', ...
	'Visible','off', ...
        'Callback',infoBtnCallbackStr);

    %====================================
    % Initialize MATLAB

    % Startup constants
    % Constants in pixel units
    pxBtnHt=25;
    pxBtnWid=140;
    pxGap=2;
    
    %====================================
    % Initialize the WELCOME Region
    pxBtnHt=25;
    pxBtnWid=150;
    xRef=150-pxBtnWid/2;
    yRef=80;
    buttonCallbackStr='expomap(''aboutmatlab'');';
    % Generic button information below
    matHndl(1)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','About MATLAB...', ...
	'Visible','off', ...
        'Callback',buttonCallbackStr);
    matHndl(2)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','Return to Main Map', ...
	'Visible','off', ...
        'Callback','expomap(''showmain'');');

    %====================================
    % Initialize the MATRICES Region
    pxBtnHt=25;
    pxBtnWid=140;
    xRef=410;
    yRef=382;

    hlpStr= ...                                           
        ['                                             '  
         ' MATLAB works with scalars, vectors, and     '  
         ' matrices. A scalar is really just a 1-by-1  '  
         ' matrix, and a vector is nothing more than a '  
         ' long, thin matrix given as either a row or a'  
         ' column. In this sense, everything that      '  
         ' MATLAB operates on is a matrix.             '  
         '                                             '  
         ' Since matrices are the basis for all of     '  
         ' MATLAB, this section contains some demos    '  
         ' that describe simple matrix operations and  '  
         ' some of the basic commands available to     '  
         ' you. These functions are the foundation upon'  
         ' which many of the more complex functions    '  
         ' are built.                                  '];

    popupCallbackStr='expomap(''popupmenu'');';
    infoCallbackStr='helpfun(''Matrices'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('matlab','matrices');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below

    matHndl(3)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    matHndl(4)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the NUMERICS Region
    yRef=282;

    hlpStr= ...                                            
        ['                                              '  
         ' Originally developed in FORTRAN for use on   '  
         ' mainframe computers, MATLAB was one of       '  
         ' the first programs to provide convenient     '  
         ' access to the groundbreaking LINPACK and     '  
         ' EISPACK matrix software developed by a       '  
         ' team centered at Argonne National            '  
         ' Laboratory.                                  '  
         '                                              '  
         ' Over the years, MATLAB has been              '  
         ' completely reimplemented in C, tested        '  
         ' relentlessly, and constantly improved so that'  
         ' it remains the expert''s choice for           '  
         ' state-of-the-art numeric computation.        '  
         '                                              '  
         ' This section contains some examples of       '  
         ' numeric calculation in MATLAB.               '];

    infoCallbackStr='helpfun(''Numerics'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('matlab','numerics');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below

    matHndl(5)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    matHndl(6)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the VISUALIZATION Region
    yRef=180;

    hlpStr= ...                                            
        ['                                              '  
         ' MATLAB''s graphics and visualization          '  
         ' capabilities have seen a quantum leap in     '  
         ' functionality recently - the entire framework'  
         ' that underlies MATLAB graphics has been      '  
         ' reworked to provide you with unprecedented   '  
         ' simplicity, elegance, and power when working '  
         ' with data graphically.                       '  
         '                                              '  
         ' This section will give you an idea of the    '  
         ' remarkable graphics you can create with      '  
         ' MATLAB as you strive for a visual            '  
         ' understanding of your data.                  '];

    infoCallbackStr='helpfun(''Visualization'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('matlab','visualization');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below

    matHndl(7)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    matHndl(8)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the LANGUAGE Region
    yRef=80;

    hlpStr= ...                                              
        ['                                                '  
         ' MATLAB is both an environment and a            '  
         ' programming language, and one of its great     '  
         ' strengths is the fact that the MATLAB          '  
         ' language allows you to build your own reusable '  
         ' tools. In fact, the MATLAB Expo consists       '  
         ' entirely of M-files, or MATLAB language        '  
         ' programs.                                      '  
         '                                                '  
         ' This section contains demos of the MATLAB      '  
         ' language in action. There are several          '  
         ' demos of the MATLAB commands that make         '  
         ' up Handle Graphics, the framework underlying   '  
         ' MATLAB graphics. Handle Graphics is an         '  
         ' object-oriented approach to visualization that '  
         ' allows you to display your data and then       '  
         ' "reach in" and manipulate any part of the image'  
         ' you have created.                              '];

    infoCallbackStr='helpfun(''Language'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('matlab','language');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below

    matHndl(9)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    matHndl(10)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize SIMULINK

    % Startup constants
    % Constants in pixel units
    pxBtnHt=25;
    pxBtnWid=140;
    pxGap=2;

    %====================================
    % Initialize the WELCOME Region
    pxBtnHt=25;
    pxBtnWid=150;
    xRef=150-pxBtnWid/2;
    yRef=80;
    nameStr='About SIMULINK...';
    buttonCallbackStr='expomap(''aboutsimulink'');';
    % Generic button information below
    simHndl(1)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',nameStr, ...
	'Visible','off', ...
        'Callback',buttonCallbackStr);
    simHndl(2)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','Return to Main Map', ...
	'Visible','off', ...
        'Callback','expomap(''showmain'');');

    %====================================
    % Initialize the SIMPLE Region
    pxBtnHt=25;
    pxBtnWid=140;
    xRef=410;
    yRef=306;

    hlpStr= ...                                            
        ['                                              '  
         ' The Simple Systems region introduces the     '  
         ' concept of SIMULINK as an addition to        '  
         ' MATLAB. In this section you will find a      '  
         ' demo that builds a simple model from scratch,'  
         ' as well as some simple linear and nonlinear  '  
         ' systems to play with.                        '  
         '                                              '  
         ' If you have never seen SIMULINK before,      '  
         ' start here.                                  '];

    infoCallbackStr='helpfun(''Simple Systems'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('simulink','simple');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);
    % I have to use the script "popupcb" here to make sure the simulation
    % variables load properly. Otherwise they get lost in the 
    % function workspace. Aside from the workspace issue, this script
    % does EXACTLY the same thing as expomap('popupmenu').
    popupCallbackStr='popupcb';
    % Generic button information below

    simHndl(3)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    simHndl(4)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the COMPLEX Region
    yRef=197;

    hlpStr= ...                                            
        ['                                              '  
         ' SIMULINK has the power to simulate some      '  
         ' extraordinarily complex systems, providing   '  
         ' you with the results you need.               '  
         '                                              '  
         ' While the SIMULINK models you will see in    '  
         ' this section are nowhere near the limits of  '  
         ' what can be done, they do hint at the sort of'  
         ' sophistication you can expect.               '  
         '                                              '  
         ' The demos in this section call up only the   '  
         ' SIMULINK model itself. It will be up to you  '  
         ' to experiment with them, using the SIMULINK  '  
         ' menu to start and stop the simulation and to '  
         ' dismiss the window when you''re done.         '];

    infoCallbackStr='helpfun(''Complex Systems'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('simulink','complex');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below

    simHndl(5)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    simHndl(6)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the ADVANCED PRODUCTS Region
    yRef=90;

    hlpStr= ...                                            
        ['                                              '  
         ' This region contains descriptions of two     '  
         ' SIMULINK-related products that you can       '  
         ' use to enhance your simulation capabilities. '  
         '                                              '  
         ' The SIMULINK Accelerator is used to          '  
         ' increase the speed of your simulations, while'  
         ' the SIMULINK C-Code Generator will           '  
         ' automatically generate the code corresponding'  
         ' to your system.                              '  
         '                                              '  
         ' Read about these products to see how you     '  
         ' can maximize your simulation potential.      '];

    infoCallbackStr='helpfun(''Enhancements'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('simulink','advanced');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below

    simHndl(7)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    simHndl(8)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize Toolbox 1

    % Startup constants
    % Constants in pixel units
    pxBtnHt=25;
    pxBtnWid=140;
    pxGap=4;

    %====================================
    % Initialize the WELCOME Region
    pxBtnWid=150;
    xRef=560/2-(2*pxBtnWid-pxGap)/2;
    yRef=40;
    buttonCallbackStr='expomap(''abouttoolboxes'')';
    % Generic button information below
    tb1Hndl(1)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','About Toolboxes...', ...
	'Visible','off', ...
        'Callback',buttonCallbackStr);
    tb1Hndl(2)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef+(pxBtnWid+pxGap) yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','Return to Main Map', ...
	'Visible','off', ...
        'Callback','expomap(''showmain'');');

    %====================================
    % Initialize the ARROW Region
    pxBtnWid=40;
    pxBtnHt=40;
    xRef=30;
    yRef=60;
    buttonCallbackStr='expomap(''showtoolbox2'');';
    % Generic button information below
    tb1Hndl(3)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','<-', ...
	'Visible','off', ...
	'Enable','off');
    xRef=560-30-pxBtnWid;
    tb1Hndl(4)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','->', ...
	'Visible','off', ...
        'Callback',buttonCallbackStr);

    %====================================
    % Initialize the SIGNAL PROCESSING Region
    pxBtnHt=25;
    pxBtnWid=150;
    pxGap=2;
    xRef=114;
    yRef=282;
    hlpStr= ...                                              
        ['                                                '  
         ' The Signal Processing Toolbox contains tools   '  
         ' to help you do digital signal processing (DSP).'  
         ' DSP is the process by which real-world         '  
         ' phenomena such as sound and light are          '  
         ' analyzed, manipulated, and created using a     '  
         ' digital computer.                              '  
         '                                                '  
         ' Thus signal processing permits computers to    '  
         ' interact with the world, and ultimately governs'  
         ' the exchange of information from one kind of   '  
         ' signal to another.                             '  
         '                                                '  
         ' The MATLAB environment is ideal for doing      '
         ' DSP because digital signals are MATLAB''s       '
         ' most natural data type.                        '];
    infoCallbackStr='helpfun(''Signal Processing'',get(gco,''UserData''));';
    popupCallbackStr='expomap(''popupmenu'');';
    [labelList,nameList]=menulist('toolbox1','signal');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below
    tb1Hndl(5)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    tb1Hndl(6)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the SYSTEM IDENTIFICATION Region
    xRef=377;
    hlpStr= ...                                               
        ['                                                 '  
         ' System identification is a way to find a        '  
         ' mathematical model for a physical system        '  
         ' (like an electric motor, or even a financial    '  
         ' market) based only on a record of the inputs    '  
         ' and outputs of that system.                     '  
         '                                                 '  
         ' By using the sophisticated system identification'  
         ' routines available in the System Identification '  
         ' Toolbox, you can move swiftly from data to      '  
         ' mathematical model, avoiding the nuisance of    '  
         ' slowly building a potentially inaccurate model  '  
         ' by hand.                                        '];
    infoCallbackStr='helpfun(''System Identification'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('toolbox1','sysid');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below
    tb1Hndl(7)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    tb1Hndl(8)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the OPTIMIZATION Region
    xRef=114;
    yRef=164;
    hlpStr= ...                                              
        ['                                                '  
         ' The Optimization Toolbox contains many         '  
         ' commands for the optimization of general linear'  
         ' and nonlinear functions. Optimization is a very'  
         ' broad topic; its purpose is to find the best   '  
         ' possible solution to a given problem (which may'   
         ' also include a number of limiting constraints).'  
         '                                                '  
         ' Graphically, an optimization problem can be    '  
         ' visualized as trying to find the lowest (or    '  
         ' highest) point in a complex, highly contoured  '  
         ' landscape. An optimization algorithm can thus  '  
         ' be likened to an explorer wandering through    '  
         ' valleys and across plains in search of the     '  
         ' topological extremes.                          '];
    infoCallbackStr='helpfun(''Optimization'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('toolbox1','optim');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below
    tb1Hndl(9)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    tb1Hndl(10)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the NEURAL NETWORK Region
    xRef=377;
    hlpStr= ...                                               
        ['                                                 '  
         ' The Neural Network Toolbox is a collection      '  
         ' of MATLAB functions for designing and           '  
         ' simulating neural networks.                     '  
         '                                                 '  
         ' Neural networks, originally inspired by their   '  
         ' biological namesakes, are composed of many      '  
         ' simple intercommunicating elements, or          '  
         ' neurons, working in parallel to solve a problem.'  
         '                                                 '  
         ' What makes them exciting is the fact that       '  
         ' once a network has been set up, it can learn    '  
         ' in a self-organizing way that seems to mimic    '  
         ' simple biological nervous systems. Because      '  
         ' neural networks can be trained to respond in    '  
         ' parallel to the inputs presented to them, they  '  
         ' often are much faster than more conventional    '
         ' methods.                                        '];
    infoCallbackStr='helpfun(''Neural Networks'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('toolbox1','neural');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below
    tb1Hndl(11)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    tb1Hndl(12)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize Toolbox 2 

    % Startup constants
    % Constants in pixel units
    pxBtnHt=25;
    pxBtnWid=140;
    pxGap=4;

    %====================================
    % Initialize the WELCOME Region
    pxBtnWid=150;
    xRef=560/2-(2*pxBtnWid-pxGap)/2;
    yRef=40;
    buttonCallbackStr='expomap(''abouttoolboxes'')';
    % Generic button information below
    tb2Hndl(1)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','About Toolboxes...', ...
	'Visible','off', ...
        'Callback',buttonCallbackStr);
    tb2Hndl(2)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef+(pxBtnWid+pxGap) yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','Return to Main Map', ...
	'Visible','off', ...
        'Callback','expomap(''showmain'');');

    %====================================
    % Initialize the ARROW Region
    pxBtnWid=40;
    pxBtnHt=40;
    xRef=30;
    yRef=60;
    buttonCallbackStr1='expomap(''showtoolbox1'');';
    buttonCallbackStr2='expomap(''showtoolbox3'');';
    % Generic button information below
    tb2Hndl(3)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','<-', ...
	'Visible','off', ...
        'Callback',buttonCallbackStr1);
    xRef=560-30-pxBtnWid;
    tb2Hndl(4)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','->', ...
	'Visible','off', ...
        'Callback',buttonCallbackStr2);

    %====================================
    % Initialize the CONTROLS Region
    pxBtnHt=25;
    pxBtnWid=150;
    pxGap=2;
    xRef=114;
    yRef=282;
    hlpStr= ...                                             
        ['                                               '  
         ' The Control System Toolbox is a collection    '  
         ' of functions for the modeling, analysis, and  '  
         ' design of automatic control systems.          '  
         ' Automatic control appears in an enormous      '  
         ' number of areas, and its span grows with each '  
         ' year as sensors and computers get cheaper.    '  
         '                                               '  
         ' MATLAB by itself includes a rich collection of'  
         ' functions that are immediately useful to the  '  
         ' control engineer, and when you add the        '  
         ' Control System Toolbox, you end up with an    '  
         ' extremely powerful platform that puts the best'  
         ' tools in classical and modern design at your  '  
         ' fingertips.                                   '];
    infoCallbackStr='helpfun(''Control Systems'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('toolbox2','control');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below
    tb2Hndl(5)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    tb2Hndl(6)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the ROBUST CONTROL Region
    xRef=377;
    hlpStr= ...                                               
        ['                                                 '  
         ' The Robust Control Toolbox provides a           '  
         ' specialized set of tools for the analysis and   '  
         ' synthesis of control systems that are "robust"  '  
         ' with respect to uncertainties that can arise in '  
         ' the real world.                                 '  
         '                                                 '  
         ' Control system design using linear techniques   '  
         ' is based on models that approximate the         '  
         ' dynamic behavior of a physical system. But      '  
         ' deviations between the model and the real       '  
         ' world often exist. In addition, system dynamics '  
         ' change over time. Such scenarios require a      '  
         ' controller capable of satisfactory performance  '  
         ' despite uncertainties. In these situations, the '  
         ' Robust Control Toolbox can be extremely         '  
         ' useful.                                         '];
    infoCallbackStr='helpfun(''Robust Control'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('toolbox2','robust');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below
    tb2Hndl(7)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    tb2Hndl(8)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the MU SYNTHESIS Region
    xRef=114;
    yRef=164;
    hlpStr= ...                                               
        ['                                                 '  
         ' The Mu-Analysis and Synthesis Toolbox is        '  
         ' a specialized collection of M-files developed   '  
         ' for the analysis and synthesis of robust        '  
         ' control systems.                                '  
         '                                                 '  
         ' The overall objective of the functions contained'  
         ' in the Toolbox is to design a robust control    '  
         ' system in the presence of uncertainties. This   '  
         ' Toolbox provides users with recent              '  
         ' developments in control theory, namely          '  
         ' H-infinity optimal control and Mu-analysis      '  
         ' and synthesis techniques, in the MATLAB         '  
         ' environment.                                    '];
    infoCallbackStr='helpfun(''Mu-Synthesis'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('toolbox2','mutools');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below
    tb2Hndl(9)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    tb2Hndl(10)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the SPLINE Region
    xRef=377;
    hlpStr= ...                                                
        ['                                                  '  
         ' The Spline Toolbox provides a set of M-files     '  
         ' for working with splines. Splines are useful     '  
         ' because of their ability to approximate or       '  
         ' "stand in" for other functions. They are flexible'  
         ' mimics that can imitate the important features   '  
         ' of other functions, while eliminating some of    '  
         ' the nasty side-effects associated with other     '  
         ' kinds of approximations (such as piecewise       '  
         ' linear curves).                                  '  
         '                                                  '  
         ' Splines are therefore used to model functions    '  
         ' of a more or less arbitrary nature. The Toolbox  '  
         ' makes it possible to create and work with        '  
         ' piecewise polynomial functions and curves in     '  
         ' the convenient and interactive MATLAB            '  
         ' environment.                                     '];
    infoCallbackStr='helpfun(''Splines'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('toolbox2','spline');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below
    tb2Hndl(11)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    tb2Hndl(12)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize Toolbox 3

    % Startup constants
    % Constants in pixel units
    pxBtnHt=25;
    pxBtnWid=140;
    pxGap=4;

    %====================================
    % Initialize the WELCOME Region
    pxBtnWid=150;
    xRef=560/2-(2*pxBtnWid-pxGap)/2;
    yRef=40;
    buttonCallbackStr='expomap(''abouttoolboxes'')';
    % Generic button information below
    tb3Hndl(1)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','About Toolboxes...', ...
	'Visible','off', ...
        'Callback',buttonCallbackStr);
    tb3Hndl(2)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef+(pxBtnWid+pxGap) yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','Return to Main Map', ...
	'Visible','off', ...
        'Callback','expomap(''showmain'');');

    %====================================
    % Initialize the ARROW Region
    pxBtnWid=40;
    pxBtnHt=40;
    xRef=30;
    yRef=60;
    buttonCallbackStr='expomap(''showtoolbox2'');';
    % Generic button information below
    tb3Hndl(3)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','<-', ...
	'Visible','off', ...
        'Callback',buttonCallbackStr);
    xRef=560-30-pxBtnWid;
    tb3Hndl(4)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','->', ...
	'Visible','off', ...
	'Enable','off');

    %====================================
    % Initialize the SYMBOLIC MATH Region
    pxBtnHt=25;
    pxBtnWid=150;
    pxGap=2;
    xRef=114;
    yRef=282;
    hlpStr= ...                                             
        ['                                                 '  
         ' The Symbolic Math Toolbox integrates powerful   '  
         ' symbolic and variable precision computing into  '  
         ' the MATLAB environment. The toolbox is          '  
         ' based on an embedded version of Maple V,        '  
         ' which is widely recognized as the most efficient'  
         ' and accurate symbolic computation software      '  
         ' available.                                      '  
         '                                                 '  
         ' Symbolic computations are often an important,   '  
         ' yet time-consuming, part of engineering         '  
         ' projects or theoretical work in basic sciences. '  
         ' Because the Symbolic Math Toolbox provides      '  
         ' access to symbolic computation within the       '  
         ' numeric MATLAB environment, you can             '  
         ' choose the most appropriate tools for a job     '  
         ' without compromising either speed or accuracy.  '  
         '                                                 '];
    infoCallbackStr='helpfun(''Symbolic Math'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('toolbox2','symbolic');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below
    tb3Hndl(5)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    tb3Hndl(6)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the IMAGE PROCESSING Region
    xRef=377;
    hlpStr= ...                                                 
        ['                                                   '  
         ' The Image Processing Toolbox provides a           '  
         ' powerful and flexible environment for image       '  
         ' processing and analysis.  It represents the       '  
         ' state of the art in image and 2-dimensional       '  
         ' signal processing for a wide range of             '  
         ' applications.  Its comprehensive library of       '  
         ' functions is an open system that may be easily    '  
         ' tailored to fit specific application requirements.'  
         '                                                   '  
         ' The MATLAB environment is ideally suited to       '  
         ' image processing.  In particular, MATLAB''s        '  
         ' matrix-oriented language is well suited for       '  
         ' manipulating images, which are nothing more       '  
         ' than a visual rendering of matrices.  The result  '  
         ' is an incomparably easy to use, economical        '  
         ' way of expressing image processing                '  
         ' operations.                                       '];
    infoCallbackStr='helpfun(''Image Processing'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('toolbox2','images');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below
    tb3Hndl(7)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    tb3Hndl(8)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the STATISTICS Region
    xRef=114;
    yRef=164;
    hlpStr= ...                                              
        ['                                                '  
         ' The Statistics Toolbox is a collection of      '  
         ' MATLAB functions for descriptive, inferential, '  
         ' and graphical statistics, probability modeling,'  
         ' and random number generation. The toolbox      '  
         ' includes several interactive graphic           '  
         ' environments for dynamic visualization of data,'  
         ' functions, and probability distributions.      '  
         '                                                '  
         ' The Statistics Toolbox also includes datasets  '  
         ' for examples discussed in the User''s Guide.    '  
         ' The Tutorial and Reference sections explain    '  
         ' each statistical concept and provide examples, '  
         ' many of which are drawn from application areas '
         ' in science and engineering.                    '];

    infoCallbackStr='helpfun(''Statistics'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('toolbox2','stats');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below
    tb3Hndl(9)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    tb3Hndl(10)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the TOOLBOX X Region
    xRef=377;

    %====================================
    % Initialize Extras

    % Startup constants
    % Constants in pixel units
    pxBtnHt=25;
    pxBtnWid=140;
    pxGap=2;

    %====================================
    % Initialize the WELCOME Region
    pxBtnHt=25;
    pxBtnWid=150;
    xRef=150-pxBtnWid/2;
    yRef=80;
    buttonCallbackStr='expomap(''aboutextras'');';
    % Generic button information below
    extrHndl(1)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','About Extras...', ...
	'Visible','off', ...
        'Callback',buttonCallbackStr);
    extrHndl(2)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','Go to Main Map', ...
	'Visible','off', ...
        'Callback','expomap(''showmain'');');

    %====================================
    % Initialize the GALLERY Region
    pxBtnHt=25;
    pxBtnWid=140;
    xRef=410;
    yRef=380;

    hlpStr= ...                                          
        ['                                            '  
         ' The Gallery is a place to hang particularly'  
         ' elegant examples of graphic visualization  '  
         ' in MATLAB. These pieces are, by themselves,'  
         ' testament to the power at your fingertips. '];

    infoCallbackStr='helpfun(''Gallery'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('extras','gallery');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below
    extrHndl(3)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'Callback',infoCallbackStr, ...
	'Visible','off', ...
	'UserData',hlpStr);
    extrHndl(4)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the GAMES Region
    yRef=280;

    hlpStr= ...                                            
        ['                                              '  
         ' The Games area is self-explanatory. Some of  '  
         ' the games in this region are participatory,  '  
         ' while some, like Conway''s "Game of Life", are'  
         ' less so.                                     '  
         '                                              '  
         ' Keep in mind everything you see is written   '  
         ' in MATLAB code. The possibilities are        '  
         ' truly limitless.                             '];

    infoCallbackStr='helpfun(''Games'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('extras','games');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below
    extrHndl(5)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    extrHndl(6)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the MISCELLANEOUS Region
    yRef=180;

    hlpStr= ...                                         
        ['                                           '  
         ' The Miscellaneous region is a catchall.   '  
         ' Browse through the demos here, and you    '  
         ' will find curiosities that couldn''t fit or'  
         ' shouldn''t be elsewhere.                   '];

    infoCallbackStr='helpfun(''Miscellaneous'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('extras','misc');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below
    extrHndl(7)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    extrHndl(8)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    %====================================
    % Initialize the CONTACT INFO Region
    yRef=80;

    hlpStr= ...                                             
        ['                                               '  
         ' This region contains the information you      '  
         ' need in order to reach us at The MathWorks,   '  
         ' whether by phone, by fax, or by foot.         '  
         '                                               '  
         ' If you have any questions, please feel free to'  
         ' call your MathWorks representative at         '  
         ' (508) 653-2452, extension 400.                '  
         '                                               '  
         ' We look forward to hearing from you.          '];

    infoCallbackStr='helpfun(''Contact Information'',get(gco,''UserData''));';
    [labelList,nameList]=menulist('extras','contact');
    labelList=str2mat('Select a demo',labelList);
    nameList=str2mat(' ',nameList);

    % Generic button information below
    extrHndl(9)=uicontrol(figNumber, ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[xRef yRef-pxBtnHt pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String','More Info...', ...
	'UserData',hlpStr, ...
	'Visible','off', ...
	'Callback',infoCallbackStr);
    extrHndl(10)=uicontrol(figNumber, ...
        'Style','popupmenu', ...
        'Units','pixels', ...
        'Position',[xRef yRef-2*(pxBtnHt+pxGap) pxBtnWid pxBtnHt], ...
        'BackgroundColor',btnColor, ...
        'String',labelList, ...
	'Callback',popupCallbackStr, ...
	'Visible','off', ...
	'UserData',nameList);

    % Increase the size of the popup menus if the machine is a PC
    bigpop;

    % Now assemble the UserData matrix; each map has a different row.
    lenMain=length(mainHndl);
    lenMat=length(matHndl);
    lenSim=length(simHndl);
    lenTB1=length(tb1Hndl);
    lenTB2=length(tb2Hndl);
    lenTB3=length(tb3Hndl);
    lenExtr=length(extrHndl);    
    maxLen=max([lenMain lenMat lenSim lenTB1 lenTB2 lenTB3 lenExtr]);
    % We have to pad the vectors before we concatenate in order to 
    % get a genuine matrix. Pad the back of the vector with copies
    % of the first element.
    mainHndl=[mainHndl zeros(1,maxLen-lenMain)];
    matHndl=[matHndl zeros(1,maxLen-lenMat)];
    simHndl=[simHndl zeros(1,maxLen-lenSim)];
    tb1Hndl=[tb1Hndl zeros(1,maxLen-lenTB1)];
    tb2Hndl=[tb2Hndl zeros(1,maxLen-lenTB2)];
    tb3Hndl=[tb3Hndl zeros(1,maxLen-lenTB3)];
    extrHndl=[extrHndl zeros(1,maxLen-lenExtr)];
    hndlMatrix=[mainHndl; matHndl; simHndl; tb1Hndl; tb2Hndl; tb3Hndl; extrHndl];
