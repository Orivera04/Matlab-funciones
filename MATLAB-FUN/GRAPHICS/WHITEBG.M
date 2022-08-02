function whitebg(fig,c)
%WHITEBG Change background color of figure.
%	WHITEBG toggles the current figure's background color
%	between white and black and changes other properties as
%	well so graphs look good. In addition, the root's default
%	properties are set so subsequent plots in the current figure
%	and new figures use the new background.
%
%	WHITEBG(FIG) changes the figures in the column vector FIG.
%	Include the root window handle (0) to affect the default
%	properties for new windows or for CLF RESET.
%
%	WHITEBG(FIG,C) or WHITEBG(C) sets the default background
%	color to C and changes other properties as well so that
%	graphs look good.  C can be a 1-by-3 rgb color or a color
%	string such as 'white' or 'w'.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.12 $  $Date: 1994/01/25 15:57:36 $

rgbspec = [1 1 0;1 0 1;0 1 1;1 0 0;0 1 0;0 0 1;1 1 1;0 0 0];
cspec = ['ymcrgbwk'];
def = ['wk' % Default text colors
       'wk' % Default axesxcolors and xlabel colors
       'wk' % Default axesycolors and ylabel colors
       'wk' % Default axeszcolors and zlabel colors
       'kk' % Default surface edge color
];

if nargin==0,
  fig = [gcf 0];
  if all(get(fig(1),'color')==[1 1 1]),
    c = [0 0 0];
  else
    c = [1 1 1];
  end

elseif nargin==1,
  if all(size(fig)==[1 3]) & max(max(fig))<=1, 
    c = fig; fig = [gcf 0];
  elseif isstr(fig),
    c = fig; fig = [gcf 0];
  else
    c = zeros(length(fig),3);
    for i=1:length(fig),
      if fig(i)==0,
       if all(get(fig(i),'defaultfigurecolor')==[1 1 1]),
          c(i,:) = [0 0 0];
        else
          c(i,:) = [1 1 1];
        end
      else
        if all(get(fig(i),'color')==[1 1 1]),
          c(i,:) = [0 0 0];
        else
          c(i,:) = [1 1 1];
        end
      end
    end
  end
end

if length(fig)~=size(c,1) & ~isstr(c)
  c = c(ones(length(fig),1),:);
end

% Deal with string color specifications.
if isstr(c),
  k = find(cspec==c(1));
  if isempty(k), error('Unknown color string.'); end
  if k~=6 | length(c)==1,
    c = rgbspec(k,:);
  elseif length(c)>2,
    if lower(c(1:3))=='bla',
      c = [0 0 0];
    elseif lower(c(1:3))=='blu',
      c = [0 0 1];
    else
      error('Unknown color string.');
    end
  end
  c = c(ones(length(fig),1),:);
end

n = size(c,1);
lum = [.298936021 .58704307445 .114020904255]*c';
mode = (lum>=.5) + 1; % mode = 1 for black, mode = 2 for white.

for k=1:n,  % Change all the requested figures
  if fig(k)==0,  set(fig(k),'defaultfigurecolor',c(k,:)), end
  set(fig(k),'defaulttextcolor',def(1,mode(k)))
  set(fig(k),'defaultaxesxcolor',def(2,mode(k)))
  set(fig(k),'defaultaxesycolor',def(3,mode(k)))
  set(fig(k),'defaultaxeszcolor',def(4,mode(k)))
  set(fig(k),'defaultsurfaceedgecolor',def(5,mode(k)))
  if (get(0,'ScreenDepth') == 1)
    if mode(k)==1, co = [1 1 1]; else co = [0 0 0]; end
  else
    co = rgbspec(1:6,:);
  end
  nco = size(co,1);
  if mode(k)==1,
    set(fig(k),'defaultaxescolororder',co);
  else
    set(fig(k),'defaultaxescolororder',co(fftshift(1:nco),:));
  end

  if all(c(k,:)==[0 0 0]), % Set inverthardcopy only if the background is black
    if fig(k)==0, 
      set(fig(k),'defaultfigureinverthardcopy','on');
    else
      set(fig(k),'inverthardcopy','on');
    end
  else
    if fig(k)==0, 
      set(fig(k),'defaultfigureinverthardcopy','off');
    else
      set(fig(k),'inverthardcopy','off');
    end
  end
      
  if fig(k)~=0,
    % Now set the properties of the figure and axes in the current figure.
    set(fig(k),'color',c(k,:))
    h = get(fig(k),'children');
    for i=1:length(h),
      if strcmp(get(h(i),'Type'),'axes'),
        set(h(i),'xcolor',def(2,mode(k)))
        set(h(i),'ycolor',def(3,mode(k)))
        set(h(i),'zcolor',def(4,mode(k)))
        hh = [get(h(i),'Title')
              get(h(i),'xlabel')
              get(h(i),'ylabel')
              get(h(i),'zlabel')
              get(h(i),'children')];
        for j=1:length(hh),
          if mode(k) == 1; cc = [0 0 0]; else cc = [1 1 1]; end
          if strcmp(get(hh(j),'Type'),'text'),
            if all(get(hh(j),'Color')==cc), 
              set(hh(j),'Color',def(1,mode(k))); 
            end
          elseif strcmp(get(hh(j),'Type'),'line'),
            if all(get(hh(j),'Color')==cc),
              set(hh(j),'Color',def(1,mode(k)));
            end
          end
        end
      end
    end
  end
end
