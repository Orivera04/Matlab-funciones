function handles = m_clabel(ch,varargin)
%M_CLABEL   Modified version of clabel
%   This function does the same as clabel(ch,'manual').
%   It was created because sometimes clabel puts not the real
%   values but rounded !?
%
%   Syntax:
%      HANDLES = M_CLABEL(CH,VARARGIN)
%
%   Inputs:
%      CH   Contour handles as output of [cs,CH]=contour(...)
%      VARARGIN:
%         'font'     font name ('Helvetica')
%         'size'     font size (7)
%         'color'    text color ('k')
%         'marker'   marker ('+')
%         'msize'    marker size (6)
%         'mcolor'   marker color
%         'pointer'  mouse pointer shape ('custom')
%         'halign'   text horizontal alignment ('left')
%         'valign'   text vertical alignment ('baseline')
%
%   Output:
%      HANDLES   markers and text handles
%
%   Comment:
%      Labeling will stop when a button other than left is pressed.
%
%   Example:
%      figure
%      [cs,ch] = contour(peaks,5);
%      h = m_clabel(ch);
%      % see the difference:
%      clabel(cs,'manual')
%
%   MMA 17-2-2005, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro

ax = get(ch(1),'parent');
fig = get(ax,'parent');
figure(fig);

fontname    = 'Helvetica';
fontsize    = 7;
fontcolor   = 'k';
marker      = '+';
markersize  = 6;
markercolor = 'b';
pointer     = 'custom';
halign      = 'left';
valign      = 'baseline';

vin = varargin;
for i=1:length(vin)
  if isequal(vin{i},'font')
    fontname = vin{i+1};
  end
  if isequal(vin{i},'size')
    fontsize = vin{i+1};
  end
  if isequal(vin{i},'color')
    fontcolor = vin{i+1};
  end
  if isequal(vin{i},'marker')
    marker = vin{i+1};
  end
  if isequal(vin{i},'msize')
    markersize = vin{i+1};
  end
  if isequal(vin{i},'mcolor')
    markercolor = vin{i+1};
  end
  if isequal(vin{i},'pointer')
    pointer = vin{i+1};
  end
  if isequal(vin{i},'halign')
    halign = vin{i+1};
  end
  if isequal(vin{i},'valign')
    valign = vin{i+1};
  end
end

v=version;
if v(1)=='7'
  ch = get(ch,'children');
end
x = get(ch,'xdata');
y = get(ch,'ydata');

n = 0;
for i=1:length(ch)
  n=max(n,length(x{i}));
end
X = repmat(nan,length(ch),n);
Y = X;

for i=1:length(ch)
  evalc('X(i,1:length(x{i})) = x{i};', ' X(i,1:length(x{i})) = transp(x{i});');
  evalc('Y(i,1:length(y{i})) = y{i};', ' Y(i,1:length(y{i})) = transp(y{i});');
end

is_hold=ishold;
hold on

uistate=uisuspend(gcf);
if isequal(pointer,'custom')
  my_pointer;
else
  set(gcf,'pointer',pointer)
end

button = 'normal';
cont = 0;

dar = get(gca,'DataAspectRatio');
while strcmp(button,'normal')
  keydown = waitforbuttonpress;
  button = get(gcf, 'SelectionType');

  if  strcmp(button,'normal')
      cont = cont+1;
      cp=get(gca,'currentpoint');
      xi=cp(1,1);
      yi=cp(1,2);

      dist=1/dar(1)*(xi-X).^2+1/dar(2)*(yi-Y).^2;
      [i,j]=find(dist == min(min(dist))); i =i(1); j=j(1);

      val = get(ch(i),'userdata');
      xx = X(i,j);
      yy = Y(i,j);

      markers(cont) = plot(xx,yy,'MarkerSize',markersize,'Color',markercolor,'Marker',marker);
      labels(cont)  = text(xx,yy,num2str(val),'FontSize',fontsize,'FontName',fontname,'Color',fontcolor,...
                           'VerticalAlignment',valign,'HorizontalAlignment',halign);
  end
end
set(gcf,'pointer','arrow');
uirestore(uistate);

if  ~is_hold
  hold off
end

if cont > 1
  handles.markers = markers;
  handles.labels  = labels;
else
  handles = [];
end

function my_pointer
shape = [
   1     nan   nan   nan    1     1     1     1     1     1     1    nan   nan   nan   nan          1
  nan    nan   nan   nan   nan   nan   nan    1    nan   nan   nan   nan   nan   nan   nan         nan
  nan    nan   nan   nan   nan   nan   nan    1    nan   nan   nan   nan   nan   nan   nan         nan
  nan    nan   nan   nan   nan   nan   nan    1    nan   nan   nan   nan   nan   nan   nan         nan
   1     nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan    1          nan
   1     nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan    1          nan
   1     nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan    1          nan
   1      1     1     1    nan   nan   nan   nan   nan   nan   nan    1     1     1     1          nan
   1     nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan    1          nan
   1     nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan    1          nan
   1     nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan    1          nan
  nan    nan   nan   nan   nan   nan   nan    1    nan   nan   nan   nan   nan   nan   nan         nan
  nan    nan   nan   nan   nan   nan   nan    1    nan   nan   nan   nan   nan   nan   nan         nan
  nan    nan   nan   nan   nan   nan   nan    1    nan   nan   nan   nan   nan   nan   nan         nan
   1     nan   nan   nan    1     1     1     1     1     1     1    nan   nan   nan   nan          1


   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan   nan
];
set(gcf,'pointer','custom');
set(gcf,'PointerShapeCData',shape);
set(gcf,'PointerShapeHotSpot',[8 8]);
