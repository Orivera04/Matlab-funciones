function navfig(c,x2)
% NAVFIG   - function for navigation in figure windows
%
% This function let all graphs in a figure window change its horizontal
% scaling by keyboard control.  It can also control the scaling of multiple
% figure windows at the same time.
%
%   navfig - installs "navfig" in current figure
%   navfig('follow',figurs) : after having "navfig" installed for the current
%                             figure, this lets other figures follow this figure
%   navfig('link',figuren) : similar to above, but this also installs navfig
%               (navfig('link') "links" alle figures)
%
% The following keyboard commands are possible :
%   'i' : zoom in
%   'I' : zoom in with a small step
%   'o' : zoom out
%   'O' : zoom out with a small step
%   'l' : shift left (lower axis values)
%   'L' : shift left with a full screen
%   'r' : shift right
%   'R' : shift right with a full screen
%   'c' : close this figure
%   'C' : close this figure and all figures linked to current figure

% Copyright (c)1997-2002, Stijn Helsen <SHelsen@compuserve.com> August 2002
% Revision history:
%         1997  SHe  Created
%    8/08/2002  SHe  Translated to English and prepared for "publication"


f=gcf;
if ~exist('c')
	set(f,'KeyPressFcn',sprintf('navfig(get(%d,''CurrentCharacter''));',f))
	return
end

if isempty(c)
	% system key
	return
elseif isstr(c)
	if strcmp(c,'follow')
		set(f,'UserData',x2)
	elseif strcmp(c,'link')
		if ~exist('x2')|isempty(x2)
			x2=get(0,'children');
		end
		for i=1:length(x2)
			set(x2(i)	...
				,'KeyPressFcn',sprintf('navfig(get(%d,''CurrentCharacter''));',x2(i))	...
				,'UserData',x2	...
				);
		end
		return
	end
elseif ~isstr(c)|length(c)~=1
	error('wrong use of navfig')
end

as=findobj(f,'Type','axes','Visible','on');
if isempty(as)
	return
end
ll=findobj(as,'Tag','legend');
if ~isempty(ll)
	as=setdiff(as,ll);
end
x=get(as(1),'XLim');
dx=diff(x);
doebepfig=0;
switch c
	case 'l'
		x=x-dx/2;
		doebepfig=1;
	case 'L'
		x=x-dx;
		doebepfig=1;
	case 'r'
		x=x+dx/2;
		doebepfig=1;
	case 'R'
		x=x+dx;
		doebepfig=1;
	case 'i'
		x=[x(1) x(1)+dx/2];
		doebepfig=1;
	case 'I'
		x=[x(1) x(1)+dx*0.95];
		doebepfig=1;
	case 'o'
		x=[x(1) x(2)+dx];
		doebepfig=1;
	case 'O'
		x=[x(1) x(2)+dx/20];
		doebepfig=1;
	case {'p','P'}
		printdlg(f)
	case 'c'
		close(f);
	case 'C'
		f=intersect(get(0,'children'),union(f,get(f,'UserData')));
		close(f);
end
if doebepfig
	set(as,'XLim',x);
	andere=get(f,'UserData');
	if ~isempty(andere)
		as=findobj(andere,'Type','axes','Visible','on');
		if isempty(as)
			return
		end
		ll=findobj(as,'Tag','legend');
		if ~isempty(ll)
			as=setdiff(as,ll);
		end
		set(as,'XLim',x)
	end
end
