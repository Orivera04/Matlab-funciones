function pltn(numlines)
% Shows you what it looks like when plt plots many traces (up to 99).
% pltn takes an argument which specifies how many traces to plot.
% For instance pltn(1) will plot a single trace and pltn(99) will
% plot 99 traces. For 99 traces the trace IDs in the selection box will
% overlap unless you have a very high resolution display.
% If you call pltn with no arguments, it will plot as many traces
% as will fit comfortably. For example, if your screen resolution is
% 1600x1200, pltn will plot 64 traces but if your screen resolution is
% 1024x768 only 35 traces will appear.

  set(0,'units','pixels');
  h = get(0,'screensize'); hmax = h(4)-88;  % max figure height
  if ~nargin                                % if # of lines not specified
    numlines = round((hmax-150)/15);        % default to as many as will fit
  end;
  h = max(525,min(hmax,150+numlines*15));   % figure height between 525 and hmax
  t  = (0:399)/400;  u = 1-t;
  y1 = 8.6 - 1.4*exp(-6*t).*sin(70*t);
  y2 = repmat([1 0 1 0 1 0]+6.4,100,1); y2 = y2(:)';
  f = (0:.15:25)-12.5; f = sin(f)./f;
  y2 = filter(f,sum(f),y2); y2(1:200) = [];
  y3 = 2 * t .* cos(15*u.^3) + 5;
  y4 = 4 - 2*exp(-1.4*t).*sin(30*t.^5);
  y5 = u .* sin(20*u.^3) + 2.2;
  w = ones(ceil(numlines/5),1);  wi = flipud(cumsum(w))-1;
  s = 5.3*(t-.5);  v = wi * (sqrt(16-s.*s)-3)/8;
  y = [y1(w,:)+v; y2(w,:)+v; y3(w,:)+v; y4(w,:)+v; y5(w,:)+v];
  y = y(1:numlines,:); t = 1e-10 * (t+.08);
  plt(t,y,'Xlim',t([1 end]),'Ylim',[min(y(end,:)) max(y(1,:))] + [-.1 .1],...
      'LabelX','seconds','Position',[8 8 800 h]);
% end function pltn
