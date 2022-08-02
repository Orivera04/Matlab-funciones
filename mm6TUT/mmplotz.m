function H = mmplotz(varargin)
%MMPLOTZ Plot with Axes Drawn Through ZERO. (MM)
% MMPLOTZ(X,Y) plots vector X versus vector Y. If X or Y is a matrix,
% then the vector is plotted versus the rows or columns of the matrix,
% whichever line up.
% MMPLOTZ(FUN,X,Y) plots the data using the plotting function FUN which
% can be one of 'plot', 'area', 'semilogx', 'semilogy', or 'fill'.
% MMPLOTZ(Y) plots the columns of Y versus their index.
% If Y is complex, MMPLOTZ(Y) is equivalent to MMPLOTZ(real(Y),imag(Y)).
% In all other uses of MMPLOTZ, the imaginary part is ignored.
% MMPLOTZ(X,Y,S) where S is a character string specifying a color,
% marker, and/or linestyle for the (X,Y) plot as per the PLOT command.
%
% Any number of X,Y pairs, or X,Y,S triples can be plotted just as in
% the standard PLOT function. Also, additional parameter/value pairs 
% can be appended to specify additional properties of the lines.
%                                   
% H=MMPLOTZ returns a column vector of handles to LINE objects.
%
% MMPLOTZ without arguments redraws the zero axes and ticks.
% Clicking on the axes, tick marks, or tick labels refreshes the axes.
%
% See also PLOT, PLOTYY, MMPLOTI, MMPLOTC, MMPLOT2.

% Calls: mmget, mmgca.

% B.R. Littlefield, University of Maine, Orono, ME, 04469
% 4/29/97, 5/12/97, 2/12/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

laboff = -1.5;
labtol = 2.0;

% Find an existing plot or create a new one.

if nargin > 0
   if ischar(varargin{1})
      if nargin == 1, error('Not enough input arguments.'), end;
      switch varargin{1}
      case 'plot', Hl = plot(varargin{2:end}, 'tag', 'MMPLOTZ');
      case 'area', Hl = area(varargin{2:end}, 'tag', 'MMPLOTZ');
      case 'fill', Hl = fill(varargin{2:end}, 'tag', 'MMPLOTZ');
      case 'semilogx', Hl = semilogx(varargin{2:end}, 'tag', 'MMPLOTZ');
      case 'semilogy', Hl = semilogy(varargin{2:end}, 'tag', 'MMPLOTZ');
      otherwise, error(sprintf('Unknown plot command: %s.',varargin{1}));
      end
   else
      Hl = plot(varargin{:}, 'tag', 'MMPLOTZ');
   end
else
   Hl = findobj(mmgca, 'tag', 'MMPLOTZ');
   if isempty(Hl), return, end
end

% Get the parent axes and delete old axes lines and ticks.

Ha = get(Hl(1), 'parent');
delete(findobj(Ha, 'tag', 'MMPZOBJ'));

% Determine tick line lengths.

[tl, xlim, ylim] = mmget(Ha, 'ticklength', 'xlim', 'ylim');
axpos = mmgetpos(Ha, 'Pixels');
ppt = tl(1)*max(axpos(3:4));
xtlen = ppt*diff(xlim)/axpos(3);
ytlen = ppt*diff(ylim)/axpos(4);

if (prod(ylim) < 0) 
   
   % Y data spans zero; relocate the X axis line and tick marks.
   
   set(Ha, 'xticklabelmode', 'auto'); 
   [xt, xtl, xc] = mmget(Ha, 'xtick', 'xticklabel', 'xcolor');
   xtl = cellstr(xtl);
   
   xtmp = [xt; xt; repmat(nan, size(xt))];
   xtmp = [xlim'; nan; xtmp(:)]; xtmp(end) = [];
   
   ytmp = [zeros(size(xt)); repmat(-ytlen, size(xt)); repmat(nan, size(xt))];
   ytmp = [zeros(2,1); nan; ytmp(:)]; ytmp(end) = [];
   
   line(xtmp, ytmp, 'color', xc, 'tag', 'MMPZOBJ', 'buttondownfcn', 'mmplotz');
   
   % Relocate the X tick labels.
   
   yoff = repmat(laboff*ytlen, size(xt));
   Hxt=text(xt, yoff, xtl, 'horizontalalignment', 'center', 'tag', 'MMPZOBJ',...
      'verticalalignment', 'top', 'buttondownfcn', 'mmplotz');
   set(Ha, 'xticklabel', []);
   
   % Move outer labels into the plot.
   
   xtol = abs(labtol*xtlen);
   if (abs(xt(1)-xlim(1)) < xtol)
      set(Hxt(1), 'HorizontalAlignment', 'left')
   end
   if (abs(xt(end)-xlim(2)) < xtol)
      set(Hxt(end), 'HorizontalAlignment', 'right')
   end
   
   % Add exponent info if required.
   
   xtm = sscanf(xtl{end}, '%g'); 
   if (abs(xt(end)-xtm) > sqrt(eps)) & (xtm ~= 0)
      xex = round(log10(xt(end)/xtm));
      set(Hxt(end), 'HorizontalAlignment', 'center',...
         'string', [xtl{end} sprintf(' x10^{ %.0f }', xex)])
   end
   
end

if (prod(xlim) < 0) 
   
   % X data spans zero; relocate the Y axis.
   
   set(Ha, 'yticklabelmode', 'auto'); 
   [yt, ytl, yc] = mmget(Ha, 'ytick', 'yticklabel', 'ycolor');
   ytl = cellstr(ytl);
   
   ytmp = [yt; yt; repmat(nan, size(yt))];
   ytmp = [ylim'; nan; ytmp(:)]; ytmp(end) = [];
   
   xtmp = [repmat(-xtlen, size(yt)); zeros(size(yt)); repmat(nan, size(yt))];
   xtmp = [zeros(2,1); nan; xtmp(:)]; xtmp(end) = [];
   
   line(xtmp, ytmp, 'color', yc, 'tag', 'MMPZOBJ', 'buttondownfcn', 'mmplotz');
   
   % Relocate the Y tick labels.
   
   xoff = repmat(laboff*xtlen, size(yt));
   Hyt = text(xoff, yt, ytl, 'horizontalalignment', 'right', 'tag', 'MMPZOBJ',...
      'verticalalignment', 'middle', 'buttondownfcn', 'mmplotz');
   set(Ha, 'yticklabel', []);
   
   % Move outer labels into the plot.
   
   ytol = abs(labtol*ytlen);
   if (abs(yt(1)-ylim(1)) < ytol)
      set(Hyt(1), 'VerticalAlignment', 'bottom')
   end
   if (abs(yt(end)-ylim(2)) < ytol)
      set(Hyt(end), 'VerticalAlignment', 'top')
   end
   
   % Add exponent info if required.
   
   ytm=sscanf(ytl{end}, '%g');
   if (abs(yt(end)-ytm) > sqrt(eps)) & (ytm~=0)
      yex = round(log10(yt(end)/ytm));
      set(Hyt(end), 'string', [ytl{end} sprintf(' x10^{ %.0f }', yex)],...
         'HorizontalAlignment', 'center')
   end
   
end

if nargout > 0, H = Hl; end;
