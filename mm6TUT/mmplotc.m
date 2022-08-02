function H=mmplotc(x,y,m,c,s,f,w)
%MMPLOTC 2-D Plot with an ASCII Character Marker at Data Points. (MM)
%  MMPLOTC(X,Y,M,C,S,F,W) plots the vector Y versus the vector X
%  by marking the data points with the single character
%  given in M, using the colorspec specified in C, the point
%  size in S, the font name specified in the string F, and the
%  font weight in W.
%
%  M can be a string character or an ASCII numerical value.
%  If unspecified, the default character is #.
%  If unspecified, the default text object color is used. (black)
%  If unspecified, the default text object pointsize is used. (10)
%  If unspecified, the default text object font is used. (Helvetica)
%  If unspecified, the default text object font weight is used. (normal)
%  H=MMPLOTC(...) returns handles to created text objects.
%  Examples:
%  MMPLOTC(X,Y,'%',[1 .5 0]) plots % characters in orange.
%  MMPLOTC(X,Y,98,'r',14,[],'bold') plots the letter 'b' in red,
%  in 14 pt. default font, bold.

% Calls: mmempty

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 12/28/95, v5: 1/14/97, 5/10/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

% text function does not set axis limits, but rather adds to current axes,
% so must use plot or line function to set axis and to make hold work.
% also, plotting data then setting line to invisible removes axis limits
% so data extremes are plotted in axes background color to hide them.

if nargin<2, error('Not enough input arguments'), end
if nargin==2,      m='#';
elseif isempty(m), m='#';
end
if ~ischar(m), m=char(fix(abs(m))); end

Hl=plot([min(x) max(x)],[max(y) min(y)]);	% set axis limits
ac=get(gca,'Color');
if ischar(ac)	% no axis color defined, get figure's color
   ac=get(gcf,'Color');
end

% use background color to hide points under markers
set(Hl,'Marker','.','MarkerSize',1,'Color',ac)

Ht=text(x,y,m(1),...	% now plot markers
   'HorizontalAlignment','center',...
   'VerticalAlignment','middle');
if nargin>=4, set(Ht,'Color',mmempty(c,[0 0 0]));       end
if nargin>=5, set(Ht,'FontSize',mmempty(s,10));         end
if nargin>=6, set(Ht,'FontName',mmempty(f,'Helvetica'));end
if nargin==7, set(Ht,'FontWeight',mmempty(w,'normal')); end

if nargout,H=Ht;end
