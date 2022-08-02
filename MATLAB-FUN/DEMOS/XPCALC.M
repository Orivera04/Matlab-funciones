function xpcalc(action);
%XPCALC  Calculus operations using the Symbolic Math Toolbox.

%	Calls XPEZPLT.

%       Denise L. Chen, August 1993.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin<1,
    action='initialize';
end;

if strcmp(action,'initialize'),
    oldFigNumber=watchon;

    pos=get(0,'DefaultFigurePosition');
    pos=[pos(1) pos(2)-40 560 460];
    figNumber=figure( ...
	'NumberTitle','off', ...
	'Name','Calculus',...
        'Position',pos);
    axes( ...
	'Units','normalized', ...
        'Position',[0.07 0.43 0.60 0.50]);

    xpezplt('1/(5+4*cos(x))');

    %===================================

    % Set up the Comment Window
    top=0.33;
    left=0.05;
    right=0.70;
    bottom=0.05;
    labelHt=0.00;
    spacing=0.005;
 
    % First, the MiniCommand Window frame
    frmBorder=0.015;
    frmPos=[left-frmBorder bottom-frmBorder ...
        (right-left)+2*frmBorder (top-bottom)+2*frmBorder];
    frmHndl=uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
        'BackgroundColor',[0.5 0.5 0.5]);
    % Then the editable text field
    str1 = ' >> f = ''1/(5+4*cos(x))'' ';
    str2 = ' f = ';
    str3 = ' 1/(5+4*cos(x))';
    str4 = ' >> ezplot(f)';
    dispStr = str2mat(str1,'',str2,str3,'',str4);
    txtPos=[left bottom (right-left) top-bottom-labelHt-spacing];
    txtHndl=uicontrol( ...
        'Style','edit', ...
        'Units','normalized', ...
        'Max',10, ...
        'BackgroundColor',[1 1 1], ...
        'Position',txtPos,...
        'String',dispStr);
    % Save this handle for future use
    set(gcf,'UserData',txtHndl);
 
    %====================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    top=0.95;
    bottom=0.05;
    left=0.75;
    yInitLabelPos=0.90;
    left=0.75;
    labelWid=0.20;
    labelHt=0.05;
    btnWid=0.20;
    btnHt=0.04;
    % Spacing between the label and the button for the same command
    btnOffset=0.003;
    % Spacing between the button and the next command's label
    spacing=0.02;

    %====================================
    % The CONSOLE frame
    frmBorder=0.02;
    yPos=0.05-frmBorder;
    frmPos=[left-frmBorder yPos btnWid+2*frmBorder 0.9+2*frmBorder];
    h=uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
	'BackgroundColor',[0.50 0.50 0.50]);
    
    %====================================
    % The F command popup button
    btnNumber=1;
    yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
    btnPos=[left yLabelPos-labelHt-btnHt-btnOffset btnWid 2*btnHt];
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position', btnPos, ...
        'String',' f(x)', ...
        'Callback','xpcalc(''fcn'')');
 
    %====================================
    % The DIFF F command popup button
    btnNumber=2;
    yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
    btnPos=[left yLabelPos-labelHt-btnHt-btnOffset btnWid 2*btnHt];
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position', btnPos, ...
        'String','Diff f(x)', ...
        'Callback','xpcalc(''diff'')');
 
    %====================================
    % The INT F command popup button
    btnNumber=3;
    yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
    btnPos=[left yLabelPos-labelHt-btnHt-btnOffset btnWid 2*btnHt];
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position', btnPos, ...
        'String','Int f(x)', ...
        'Callback','xpcalc(''int'')');
 
    %====================================
    % The 1/f command popup button
    btnNumber=4;
    yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
    btnPos=[left yLabelPos-labelHt-btnHt-btnOffset btnWid 2*btnHt];
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position', btnPos, ...
        'String',' 1/f(x)', ...
        'Callback','xpcalc(''1/f'')');
 
    %====================================
    % The FINVERSE command popup button
    btnNumber=5;
    yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
    btnPos=[left yLabelPos-labelHt-btnHt-btnOffset btnWid 2*btnHt];
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position', btnPos, ...
        'String','Finverse', ...
        'Callback','xpcalc(''finverse'')');
 
    %====================================
    % The SOLVE command popup button
    btnNumber=6;
    yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
    btnPos=[left yLabelPos-labelHt-btnHt-btnOffset btnWid 2*btnHt];
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position', btnPos, ...
        'String',' Solve', ...
        'Callback','xpcalc(''solve'')');
 
    %====================================
    % The INFO button
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',[left bottom+2*btnHt+spacing btnWid 2*btnHt], ...
        'String','Info', ...
        'Callback','xpcalc(''info'')');
 
    %====================================
    % The CLOSE button
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',[left bottom btnWid 2*btnHt], ...
        'String','Close', ...
        'Callback','close(gcf)');
 
%=======================================================================
    
elseif strcmp(action,'fcn')
    xpezplt('1/(5+4*cos(x))');
    str1 = ' >> f = ''1/(5+4*cos(x))'' ';
    str2 = ' f = ';
    str3 = ' 1/(5+4*cos(x))';
    str4 = ' >> ezplot(f)';
    dispStr= str2mat(str1,'',str2,str3,'',str4);
    set(get(gcf,'UserData'),'String',dispStr);

elseif strcmp(action,'diff')
    xpezplt('4/(5+4*cos(x))^2*sin(x)');
    str1 = ' >> deriv = diff(f)';
    str2 = ' deriv =';
    str3 = ' 4/(5+4*cos(x))^2*sin(x)';
    str4 = ' >> ezplot(deriv)';
    dispStr= str2mat(str1,'',str2,str3,'',str4);
    set(get(gcf,'UserData'),'String',dispStr);

elseif strcmp(action,'int')
    xpezplt(' 2/3*atan(1/3*tan(1/2*x))');
    str1 = ' >> integr = int(f)';
    str2 = ' integr =';
    str3 = ' 2/3*atan(1/3*tan(1/2*x))';
    str4 = ' >> ezplot(integr)';
    dispStr= str2mat(str1,'',str2,str3,'',str4);
    set(get(gcf,'UserData'),'String',dispStr);

elseif strcmp(action,'1/f')
    xpezplt(' 5+4*cos(x)');
    str1 = ' >> g = symdiv(1,f)';
    str2 = ' g =';
    str3 = ' 5+4*cos(x)';
    str4 = ' >> ezplot(g)';
    dispStr= str2mat(str1,'',str2,str3,'',str4);
    set(get(gcf,'UserData'),'String',dispStr);

elseif strcmp(action,'finverse')
    xpezplt(' acos(1/4*(1-5*x)/x)');
    str1 = ' >> h = finverse(f)';
    str2 = ' h =';
    str3 = ' acos(1/4*(1-5*x)/x)';
    str4 = ' >> ezplot(h)';
    dispStr= str2mat(str1,'',str2,str3,'',str4);
    set(get(gcf,'UserData'),'String',dispStr);

elseif strcmp(action,'solve')
    xpezplt('exp(x)');           
    set(get(gca,'ch'),'Color','m');
    hold on;
    xpezplt('1/(5+4*cos(x))');
    
    str1 = ' Solve the equation: f(x) = exp(x)';
    str2 = ' >> p = solve([f,'' = exp(x)'']);';
    str3 = ' >> fp = subs(f,p,''x'');';
    str4 = ' Plot the solution by numerically evaluating its';
    str5 = ' coordinates (p,fp)';
    str6 = ' >> plot(numeric(p), numeric(fp), ''oc'');';
    dispStr= str2mat(str1,str2,str3,'',str4,str5,str6);
    set(get(gcf,'UserData'),'String',dispStr);

    plot( -1.59218236313467, 0.20348105726304, 'oc');
    hold off;

elseif strcmp(action,'info'),
    ttlStr=' Calculus ';
    hlpStr1= ...                    
        ['                                                   '  
         ' This demo shows several symbolic calculations     '  
         ' on the function f(x) = 1/(5+4*cos(x)).            '  
         '                                                   '  
         ' "f(x)" creates the function f(x).                 '  
         ' "Diff f(x)" differentiates f(x) with respect to x.'  
         ' "Int f(x)" integrates f(x) with respect to x.     '  
         ' "1/f(x)" calculates 1/f(x).                       '  
         ' "Finverse" finds the functional inverse of f(x).  '  
         ' "Solve" solves the equation f(x) = exp(x).        '  
         '                                                   '  
         ' The command used to perform the symbolic          '  
         ' operation and the resulting output is shown in    '  
         ' the text window below the plot of the result.     '  
         ' The plot is generated using the "ezplot" function.'  
         '                                                   '  
         '                                                   '  
         ' File name: xpcalc.m                               '  
         '                                                   '  
         '                                                   '];
    hlpStr2= ...                                             
        ['                                               '  
         ' This demo was generated using the Symbolic    '  
         ' Math Toolbox. Note that the MATLAB Expo       '  
         ' does not include an executable version of this'  
         ' toolbox.                                      '];
    helpfun(ttlStr,hlpStr1,hlpStr2);                                                                    

end;    % if strcmp(action, ...
