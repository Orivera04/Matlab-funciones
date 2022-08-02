%XPLANG Expo demo of MATLAB's language capability.

%	Mark W. Reichelt, 7-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Demo initialization ====================
if ~exist('SlideShowGUIFlag'), figNumber=0; end;

if ssinit(figNumber)
  cla
  load logo
  n = length(L(:,1));
  if isstudent
     k = 1:2:n; n = length(k);
     L = L(k,k); R = R(k,k);
  end
  surf(L,R), colormap(M)
  axis off, axis([1 n 1 n -.2 .35]), view(-37.5,60)
  title('"Life is too short to spend writing DO loops..."');

  str = str2mat( ...
  ' Press the "Start" button to see a brief introduction', ...
  ' to the power of the MATLAB programming language.', ...
  '', ...
  ' All of the Expo demos (including this one) are written in', ...
  ' MATLAB language M-files.', ...
  '', ...
  ' >> load logo', ...
  ' >> surf(L,R), colormap(M)', ...
  ' >> n = size(L,1);', ...
  ' >> axis off, axis([1 n 1 n -.2 .35]), view(-37.5,60)', ...
  ' >> title(''"Life is too short to spend writing DO loops..."'');' ...
  );
  ssdisp(figNumber,str);                                            

  if figNumber, return; end
end

% Beginning of the demo ==================

ord = get(gcf,'defaultaxescolororder');
set(gcf,'defaultaxescolororder',hsv(20))
c = peaks; contour(c,20);
surface(ones(size(c)),c);
colormap(hsv(20)); shading flat
view(3)
title('"An ounce of MATLAB is worth a pound of C or FORTRAN..."');
set(gcf,'defaultaxescolororder',ord);

str = str2mat( ...
  ' MATLAB is a powerful programming language.', ...
  '', ...
  ' It is such a compact and highly efficient language that,', ...
  ' line-for-line, a MATLAB program may contain some', ...
  ' of the most potent code you ever write.', ...
  '', ...
  ' >> c = peaks; contour(c,20);', ...
  ' >> surface(ones(size(c)),c);', ...
  ' >> colormap(hsv(20)); shading flat', ...
  ' >> view(3)' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


imagesc(flipud(peaks));
colormap(hsv);
title('"Think of MATLAB as a power tool for your brain..."')

str = str2mat( ...
  ' MATLAB programs, or M-files, are ascii files denoted by', ...
  ' the filename suffix ".m" and come in two basic flavors:', ...
  ' SCRIPTS and FUNCTIONS.', ...
  '', ...
  '', ...
  '', ...
  '', ...
  ' >> imagesc(flipud(peaks));', ...
  ' >> colormap(hsv);', ...
  ' >> title(''"Think of MATLAB as a power tool for your brain..."'')' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


cla reset
set(gca,'Box','on','XTick',[],'YTick',[],'Visible','on');
text(.05,.9,'% fibscript.m');
text(.05,.8,'% A script to calculate Fibonacci numbers');
text(.05,.7,'% first described by Leonardo of Pisa.');
text(.05,.6,'f = [1 1]; n = 1;');
text(.05,.5,'while f(n) + f(n + 1) < 80');
text(.05,.4,'    f(n + 2) = f(n) + f(n + 1)');
text(.05,.3,'    n = n + 1;');
text(.05,.2,'end');
text(.05,.1,'f');

str = str2mat( ...
  ' When the name of a SCRIPT M-file is typed at the', ...
  ' command line, MATLAB simply executes the commands', ...
  ' found in the file.', ...
  '', ...
  ' This can be used to automate long sequences of', ...
  ' commands.', ...
  '', ...
  ' >> set(gca,''Box'',''on'',''XTick'',[ ],''YTick'',[ ],''Visible'',''on'');', ...
  ' >> text(.05,.9,''% fibscript.m'');', ...
  ' >> text(.05,.8,''% A script to calculate Fibonacci numbers'');' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


cla reset
set(gca,'Box','on','XTick',[],'YTick',[],'Visible','on');
text(.05,.9,'function f = fibfun(n)');
text(.05,.8,'% FIBFUN For calculating Fibonacci numbers.');
text(.05,.7,'% Incidentally, the name Fibonacci comes from');
text(.05,.6,'% Filius Bonassi, or "son of Bonassus".');
text(.05,.5,'if n > 2');
text(.05,.4,'    f = fibfun(n - 1) + fibfun(n - 2);');
text(.05,.3,'else');
text(.05,.2,'    f = 1;');
text(.05,.1,'end');

str = str2mat( ...
  ' A FUNCTION M-file is like a SCRIPT, except that it allows', ...
  ' argument passing and local variables.', ...
  '', ...
  ' Many of the MATLAB commands available at the command', ...
  ' line are actually FUNCTION M-files that are open for', ...
  ' your inspection.' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


cla reset
set(gca,'Box','on','XTick',[],'YTick',[],'Visible','on');
text(.05,.9,'>> fibfun(10)');
text(.05,.8,'ans =');
text(.05,.7,'    55');

text(.05,.5,'>> help fibfun');
text(.05,.4,'FIBFUN For calculating Fibonacci numbers.');
text(.05,.3,'Incidentally, the name Fibonacci comes from');
text(.05,.2,'Filius Bonassi, or "son of Bonassus".');

str = str2mat( ...
  ' For example, once the Fibonacci function has been defined,', ...
  ' we can use it at the command line, as shown above.', ...
  '', ...
  ' In this way, MATLAB is extendable.  The sky''s the limit.', ...
  '', ...
  ' (For example, all of Expo is written in MATLAB M-files.)' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


cla reset
set(gca,'Box','on','XTick',[],'YTick',[],'Visible','on');
text(.1,.9,'Think VECTORIZED, i.e. use');
text(.2,.75,'y = sum(x);');
text(.1,.6,'instead of');
text(.2,.45,'y = 0;');
text(.2,.35,'for i = 1:length(x)');
text(.2,.25,'    y = y + x(i);');
text(.2,.15,'end');

str = str2mat( ...
  ' In M-files, the familiar IF, WHILE, and FOR statements of', ...
  ' other programming languages can be used for control flow.', ...
  '', ...
  ' Nevertheless, some of the most ingenious and efficient', ...
  ' M-files use MATLAB''s built-in vector and matrix', ...
  ' operations instead of explicit loops.' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


cla reset
set(gca,'Box','on','XTick',[],'YTick',[],'Visible','on');
text(.05,.9,'dbstop'); text(.3,.9,'Set breakpoint.');
text(.05,.8,'dbclear'); text(.3,.8,'Remove breakpoint.');
text(.05,.7,'dbcont'); text(.3,.7,'Resume execution.');
text(.05,.6,'dbdown'); text(.3,.6,'Change local workspace context.');
text(.05,.5,'dbstack'); text(.3,.5,'List who called whom.');
text(.05,.4,'dbstatus'); text(.3,.4,'List all breakpoints.');
text(.05,.3,'dbstep'); text(.3,.3,'Execute one or more lines.');
text(.05,.2,'dbtype'); text(.3,.2,'List M-file with line numbers.');
text(.05,.1,'dbup'); text(.3,.1,'Change local workspace context.');

str = str2mat( ...
  ' And, in the event that you should have a hard-to-find', ...
  ' bug in an M-file you create, MATLAB is equipped with a', ...
  ' powerful debugger to root out any problems.', ...
  '', ...
  ' The debugger provides a variety of familiar and useful', ...
  ' functions, like set breakpoint, resume execution, etc...' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


cla reset
image, colormap(1-gray(15))
axis image, axis off
t = get(gca,'Title');
set(t,'String','"Read my lips.  MATLAB is great..."');

str = str2mat( ...
  ' To summarize, anything that you can type at the command', ...
  ' line can be placed into an M-file.  This has several', ...
  ' important implications.', ...
  '', ...
  ' First, you have the incredibly powerful vector and matrix', ...
  ' notation of MATLAB to make your code concise.', ...
  '', ...
  ' >> image, colormap(1-gray(15))', ...
  ' >> axis image, axis off' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


cla reset
set(gca,'Box','on','XTick',[],'YTick',[],'Visible','on');
drawnow
h = [];
i = 1;
pos = get(gca,'Position');
x = .5; x2 = pos(3) * x + pos(1);

y = .9 - (i-1) * .15; y2 = pos(4) * y + pos(2);
text(.2,y,'pushbuttons')
h(i) = uicontrol('Style','pushbutton','Units','normalized', ...
                 'String','Push Me','Position',[x2 y2-.03 .15 .05]);
i = i + 1;
y = .9 - (i-1) * .15; y2 = pos(4) * y + pos(2);
text(.2,y,'radiobuttons')
h(i) = uicontrol('Style','radiobutton','Units','normalized', ...
                 'String','Click Me','Position',[x2 y2-.03 .15 .05]);
i = i + 1;
y = .9 - (i-1) * .15; y2 = pos(4) * y + pos(2);
text(.2,y,'checkboxes')
h(i) = uicontrol('Style','checkbox','Units','normalized', ...
                 'String','Click Me','Position',[x2 y2-.03 .15 .05]);
i = i + 1;
y = .9 - (i-1) * .15; y2 = pos(4) * y + pos(2);
text(.2,y,'edit boxes')
h(i) = uicontrol('Style','edit','Units','normalized', ...
                 'String','    Edit Me','Position',[x2 y2-.03 .15 .05]);
i = i + 1;
y = .9 - (i-1) * .15; y2 = pos(4) * y + pos(2);
text(.2,y,'text')
h(i) = uicontrol('Style','text','Units','normalized', ...
                 'String','Static Text','Position',[x2 y2-.03 .15 .05]);
i = i + 1;
y = .9 - (i-1) * .15; y2 = pos(4) * y + pos(2);
text(.2,y,'sliders')
h(i) = uicontrol('Style','slider','Units','normalized', ...
                 'Value',.5,'Position',[x2 y2-.03 .15 .05]);

str = str2mat( ...
  ' Second, MATLAB invisibly handles all memory allocation,', ...
  ' and supports file I/O and string manipulation.', ...
  '', ...
  ' Finally, MATLAB contains an extensive collection of', ...
  ' graphical interface tools (shown above) that you can use to', ...
  ' build beautiful and useful user interfaces.', ...
  '', ...
  ' >> text(.2,y,''pushbuttons'')', ...
  ' >> h(i) = uicontrol(''Style'',''pushbutton'',''Units'',''normalized'', ...', ...
  '         ''String'',''Push Me'',''Position'',[x2 y2-.03 .15 .05]);' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), cla, delete(h), return; end;
delete(h);

cla reset
cplxroot(3,15);
colormap(hsv);
title('f(z) = z^(1/3)');

str = str2mat( ...
  ' And, of course, you can invoke any of the functions that', ...
  ' make MATLAB the premier program for numerical linear', ...
  ' algebra, matrix manipulation and data visualization.', ...
  '', ...
  ' For example, we can plot the Riemann surface for z^(1/3).', ...
  '', ...
  '', ...
  ' >> cplxroot(3,15);', ...
  ' >> colormap(hsv);', ...
  ' >> title(''f(z) = z^(1/3)'');' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


cla
load logo
n = length(L(:,1));
if isstudent
   k = 1:2:n; n = length(k);
   L = L(k,k); R = R(k,k);
end
surf(L,R), colormap(M)
n = size(L,1);
axis off, axis([1 n 1 n -.2 .35]), view(-37.5,60)
title('MATLAB.  Picture the Power.');

str = str2mat( ...
  ' Study the M-files that are shipped with MATLAB, and you', ...
  ' will be amazed by some of the ingenuity and power of the', ...
  ' MATLAB programming language.', ...
  '', ...
  ' MATLAB.  Picture the Power.', ...
  '', ...
  ' >> load logo', ...
  ' >> surf(L,R), colormap(M)', ...
  ' >> n = size(L,1);', ...
  ' >> axis off, axis([1 n 1 n -.2 .35]), view(-37.5,60)', ...
  ' >> title(''MATLAB.  Picture the Power.'');' ...
);
ssdisp(figNumber,str);                                         

% End of the demo ========================
