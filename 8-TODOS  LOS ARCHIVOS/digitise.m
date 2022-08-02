%DIGITISE.M
%
%To digitise a curve stuck onto the screen within a matlab graph
%window.  Use a photocopy of the curve on transparency and stick
%it onto the screen with sticky tape.  Crude but it works!
%
%					A. Knight, July 1992


disp('This program is used when you have a plot on a piece of paper that you want')
disp('to digitise with the mouse.  Here are the steps to follow:')
disp(' ')
disp('1. Photocopy your graph onto a piece of transparency.')
disp(' ')
disp('2. Stick the transparency onto your computer screen with sticky-tape, blue')
disp('tack, or some other such material.')
disp(' ')
disp('3. If you already have a matlab figure open, issue a clf command and make')
disp('the figure big enough to cover the entire area of your transparent graph.')
disp('If you don''t have a matlab figure, create one by typing ''figure''.  Then make')
disp('it bigh enough to cover you transparent graph.')
disp(' ')
disp('4. Type ''digitise'' at the matlab prompt, and follow the instructions.')
disp('  ')
disp('  ')

disp('Press return to continue')
pause

clc

clear xpts ypts
clf
axHndl = axes(...
    'Position',[0 0 1 1],...
    'XLim',[0 1],...
    'YLim',[0 1],...
    'Visible','off');
hold on
disp('Please click on the corners of your plot')
disp('(Lower left followed by upper right...')
[x,y] = ginput(2);
set(axHndl,...
    'Position',[x(1) y(1) x(2)-x(1) y(2)-y(1)],...
    'Visible','on',...
    'XTick',[],...
    'YTick',[],...
    'Box','on')

ax = zeros(1,4);
ax(1) = input('xmin = ? ');
ax(2) = input('xmax = ? ');
set(axHndl,'XLim',[ax(1) ax(2)],...)
    'XTickMode','auto')
logxscale = input('Do you have a logarithmic x scale (y/n) ? ','s');
if isempty(logxscale)
  logxscale = 'n';
end
if logxscale=='y'|logxscale=='Y'
set(axHndl,...
    'XScale','log')
end

ax(3) = input('ymin = ? ');
ax(4) = input('ymax = ? ');
set(axHndl,...
    'YLim',[ax(3) ax(4)],...
    'YTickMode','auto')
logyscale = input('Do you have a logarithmic y scale (y/n) ? ','s');
if isempty(logyscale)
  logyscale = 'n';
end
if logxscale=='y'|logxscale=='Y'
  set(axHndl,...
    'XScale','log')
end


hold on
curve = 0;
finished = 0;
while ~finished
  curve = curve + 1;
  if curve>1
    ans = input('Plot grid at previous x values (y/n) [default=y] ? ','s');
    if isempty(ans),ans = 'y';end
    if ans=='y'|ans=='Y'
      plot([xpts ; xpts],[ax(3) ; ax(4)]*ones(1,size(xpts,2)),':k')
    end
    clear xpts ypts
  end
  button = 1;
  disp('You may now digitise your curve')
  disp('(Press return when you have finished)')
  while ~isempty(button)
    [xpt,ypt,button] = ginput(1);
    if ~isempty(button)
      if ~exist('xpts'),
	xpts = xpt;
      else
	xpts = [xpts xpt];
      end
      if ~exist('ypts'),
	ypts = ypt;
      else
	ypts = [ypts ypt];
      end
      h = plot(xpts,ypts,xpts,ypts,'o');
      for i=1:length(h)
	set(h(i),'clipping','off')
      end
    end
  end
  str = ['x' int2str(curve) '=xpts;'];
  eval(str)
  str = ['y' int2str(curve) '=ypts;'];
  eval(str)
  disp(['These points are called x' int2str(curve) ' and y' ...
	  int2str(curve)])
  ans = input('Do another curve (y/n) [default=y] ? ','s');
  if isempty(ans),ans = 'y';end
  if ans~='y' & ans~='Y'
    finished = 1;
  end
end

