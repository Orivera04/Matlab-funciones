%FUNTOOL A function calculator.
%	FUNTOOL is an interactive graphing calculator that manipulates
%	functions of a single variable.  At any time, there are two functions
%	displayed, f(x) and g(x).  The result of most operations replaces f(x).
%
%	The controls labeled 'f = ' and 'g = ' are editable text which may
%	be changed at any time to install a new function.  The control
%	labeled 'x = ' may be changed to specify a new domain.  The control
%	labeled 'a = ' may be changed to specify a new value of a parameter.
%
%	Variables named f, g, x and a which exist in the MATLAB workspace
%	when FUNTOOL is invoked will be used instead of the defaults.
%
%	The top row of control buttons are unary function operators which
%	involve only f(x).  These operators are:
%	   D f      - Symbolically differentiate f(x).
%	   I f      - Symbolically integrate f(x).
%	   Simp f   - Simplify the symbolic expression, if possible.
%	   Num f    - Extract the numerator of a rational expression.
%	   Den f    - Extract the denominator of a rational expression.
%	   1/f      - Replace f(x) by 1/f(x).
%	   finv     - Replace f(x) by its inverse function.
%
%	The operators I f and finv may fail if the corresponding symbolic
%	expressions do not exist in closed form.
%
%	The second row of buttons translate and scale f(x) by the parameter 'a'.
%	The operations are:
%	   f + a    - Replace f(x) by f(x) + a.
%	   f - a    - Replace f(x) by f(x) - a.
%	   f * a    - Replace f(x) by f(x) * a.
%	   f / a    - Replace f(x) by f(x) / a.
%	   f ^ a    - Replace f(x) by f(x) ^ a.
%	   f(x+a)   - Replace f(x) by f(x + a).
%	   f(x*a)   - Replace f(x) by f(x * a).
%
%	The third row of buttons are binary function operators which
%	operate on both f(x) and g(x).  The operations are:
%	   f + g  - Replace f(x) by f(x) + g(x).
%	   f - g  - Replace f(x) by f(x) - g(x).
%	   f * g  - Replace f(x) by f(x) * g(x).
%	   f / g  - Replace f(x) by f(x) / g(x).
%	   f(g)   - Replace f(x) by f(g(x)).
%	   g = f  - Replace g(x) by f(x).
%	   swap   - Interchange f(x) and g(x).
%
%	The first three buttons in the fourth row manage a list of functions.
%	The Insert button places the current active function in the list.
%	The Cycle button rotates the function list.
%
%	The Delete button removes the active function from the list.  
%	The list of functions is named fxlist.  A default fxlist containing 
%           several interesting functions is provided.
%	The Reset button sets f, g, x, a and flist to their initial values.
%	The Help button prints this help text.  
%
%	The Demo button poses the following challenge: Can you generate the
%	function sin(x) without touching the keyboard, using just the mouse?
%	The demo does it with a reset and then nine clicks.  If you can do
%	it with fewer clicks, please send e-mail to moler@mathworks.com.
%
%	The Close button closes all three windows.
%
%	See also EZPLOT.

%	C. Moler, 9/25/93, A. Potvin 6/2/94
%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.18 $  $Date: 1994/06/16 14:54:09 $

% Initialize.

funtoolf = 'x';
funtoolg = '1';
funtoolx = '[-2*pi, 2*pi]';
funtoola = '1/2';
funtooll = str2mat( ...
    '1/(5+4*cos(x));  [-2*pi, 2*pi]', ...
    'cos(x^3)/(1+x^2);  [-2*pi, 2*pi]', ...
    'x^4*(1-x)^4/(1+x^2);  [0, 1]', ...
    'x^7-7*x^6+21*x^5-35*x^4+35*x^3-21*x^2+7*x-1;  [0.985, 1.015]', ...
    'log(abs(sqrt(x)));  [0, 2]', ...
    'tan(sin(x))-sin(tan(x));  [-pi, pi]');

if ~exist('f'), f = funtoolf; end
if ~exist('g'), g = funtoolg; end
if ~exist('x'), x = funtoolx; end
if ~exist('a'), a = funtoola; end
if ~exist('fxlist'), fxlist = funtooll; end
if ~isstr(a), a = sym(a); end

% Macros

blanks = '  ';
p = .12*(1:7) - .02;
q = .60 - .14*(1:4);
r = [.10 .10];
putf = 'ezplot(f,x,figf), set(Sf,''string'',[blanks f])';
putg = 'ezplot(g,x,figg), set(Sg,''string'',[blanks g])';
darken = [.5 .5 .5];

% Position the two figures and the control panel.

figf = figure('units','normalized','pos',[.01 .50 .48 .48],'menu','none');
figg = figure('units','normalized','pos',[.50 .50 .48 .48],'menu','none');
figp = figure('units','normalized','pos',[.25 .05 .50 .40],'menu','none', ...
              'Color',get(0,'DefaultUIControlBackgroundColor'), ...
              'DefaultUIControlUnit','norm');

% Plot f(x) and g(x).

figure(figf)
ezplot(f,x,figf)
figure(figg)
ezplot(g,x,figg)

% Control panel

figure(figp)
uicontrol('style','frame','pos',[0.01 0.60 0.98 0.38]);
uicontrol('style','frame','pos',[0.01 0.01 0.98 0.58]);
uicontrol('style','text','string','f = ','pos',[0.04 0.86 0.09 0.10]);
uicontrol('style','text','string','g = ','pos',[0.04 0.74 0.09 0.10]);
uicontrol('style','text','string','x = ','pos',[0.04 0.62 0.09 0.10]);
uicontrol('style','text','string','a = ','pos',[0.54 0.62 0.09 0.10]);
Sf = uicontrol('pos',[.12 .86 .82 .10],'style','edit','horiz','left', ...
    'backgroundcolor','white', ...
    'string', [blanks f],'call','f = get(Sf,''string''); ezplot(f,x,figf)');
Sg = uicontrol('pos',[.12 .74 .82 .10],'style','edit','horiz','left', ...
    'backgroundcolor','white', ...
    'string', [blanks g],'call','g = get(Sg,''string''); ezplot(g,x,figg)');
Sx = uicontrol('pos',[.12 .62 .32 .10],'style','edit','horiz','left', ...
    'backgroundcolor','white','string',[blanks x], ...
    'call',['x = get(Sx,''string''); if isempty(findstr(x,''['')), ' ...
    'x = [''['' x '']'']; set(Sx,''string'',[blanks x]); end; ' ...
    'ezplot(f,x,figf), ezplot(g,x,figg)']);
Sa = uicontrol('pos',[.62 .62 .32 .10],'style','edit','horiz','left', ...
    'backgroundcolor','white', ...
    'string',[blanks a],'call','a = get(Sa,''string'');');

% Top row of unary operators.

B(1) = uicontrol('pos',[p(1) q(1) r],'string','D f', ...
    'call','f = diff(f); eval(putf)');
B(2) = uicontrol('pos',[p(2) q(1) r],'string','I f', ...
    'call','f = int(f); eval(putf)');
B(3) = uicontrol('pos',[p(3) q(1) r],'string','Simp f', ...
    'call','f = simple(f); eval(putf)');
B(4) = uicontrol('pos',[p(4) q(1) r],'string','Num f', ...
    'call','[f,ans] = numden(f); eval(putf)');
B(5) = uicontrol('pos',[p(5) q(1) r],'string','Den f', ...
    'call','[ans,f] = numden(f); eval(putf)');
B(6) = uicontrol('pos',[p(6) q(1) r],'string','1/f', ...
    'call','f = symdiv(1,f); eval(putf)');
B(7) = uicontrol('pos',[p(7) q(1) r],'string','finv', ...
    'call','f = finverse(f); eval(putf)');

% Second row of unary operators.

B(8) = uicontrol('pos',[p(1) q(2) r],'string','f+a', ...
    'call','f = symadd(f,a); eval(putf)');
B(9) = uicontrol('pos',[p(2) q(2) r],'string','f-a', ...
    'call','f = symsub(f,a); eval(putf)');
B(10) = uicontrol('pos',[p(3) q(2) r],'string','f*a', ...
    'call','f = symmul(f,a); eval(putf)');
B(11) = uicontrol('pos',[p(4) q(2) r],'string','f/a', ...
    'call','f = symdiv(f,a); eval(putf)');
B(12) = uicontrol('pos',[p(5) q(2) r],'string','f^a', ...
    'call','f = sympow(f,a); eval(putf)');
B(13) = uicontrol('pos',[p(6) q(2) r],'string','f(x+a)', ...
    'call','f = subs(f,symadd(''x'',a)); eval(putf)');
B(14) = uicontrol('pos',[p(7) q(2) r],'string','f(x*a)', ...
    'call','f = subs(f,symmul(''x'',a)); eval(putf)');

% Third row, binary operators.

B(15) = uicontrol('pos',[p(1) q(3) r],'string','f + g', ...
    'call','f = symadd(f,g); eval(putf)');
B(16) = uicontrol('pos',[p(2) q(3) r],'string','f - g', ...
    'call','f = symsub(f,g); eval(putf)');
B(17) = uicontrol('pos',[p(3) q(3) r],'string','f * g', ...
    'call','f = symmul(f,g); eval(putf)');
B(18) = uicontrol('pos',[p(4) q(3) r],'string','f / g', ...
    'call','f = symdiv(f,g); eval(putf)');
B(19) = uicontrol('pos',[p(5) q(3) r],'string','f(g)', ...
    'call','f = compose(f,g); eval(putf)');
B(20) = uicontrol('pos',[p(6) q(3) r],'string','g = f', ...
    'call','g = f; eval(putg)');
B(21) = uicontrol('pos',[p(7) q(3) r],'string','swap', ...
    'call','h = f; f = g; g = h; eval(putf), eval(putg)');

% Fourth row, auxilliary controls.

B(22) = uicontrol('pos',[p(1) q(4) r],'string','Insert','call', ...
    'fxlist = str2mat(fxlist,[f '';  '' x]);');
B(23) = uicontrol('pos',[p(2) q(4) r],'string','Cycle','call', ...
    ['fx = deblank(fxlist(1,:)); k = find(fx == '';''); ' ...
    'f = fx(1:k-1); x = fx(k+3:length(fx)); eval(putf); ' ...
    'set(Sx,''string'',[blanks x]); ' ...
    'k = [2:size(fxlist,1),1]; fxlist = fxlist(k,:);']);
B(24) = uicontrol('pos',[p(3) q(4) r],'string','Delete','call', ...
    ['fx = [f '';  '' x]; for k = 1:size(fxlist,1), ' ...
    'if strcmp(fx,deblank(fxlist(k,:))), fxlist(k,:) = []; break, ' ...
    'end, end; if isempty(fxlist), fxlist = ''0-0;  [0,1]''; end']);
B(25) = uicontrol('pos',[p(4) q(4) r],'string','Reset','call', ...
    ['x = funtoolx; set(Sx,''string'',[blanks x]); ' ...
    'a = funtoola; set(Sa,''string'',[blanks a]); ' ...
    'f = funtoolf; eval(putf); g = funtoolg; eval(putg); ' ...
    'fxlist = funtooll;']);
B(26) = uicontrol('pos',[p(5) q(4) r],'string','Help', ...
    'call','help funtool');
B(27) = uicontrol('pos',[p(6) q(4) r],'string','Demo', ...
    'call','funtoold');
B(28) = uicontrol('pos',[p(7) q(4) r],'string','Close', ...
    'call','close(figf), close(figg), close(figp)');

% end funtool
