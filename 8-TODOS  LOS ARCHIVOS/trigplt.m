function trigplt(action)

if nargin==0
  uicontrol('Callback','trigplt Sine','Position',[508 351 51 26], ...
      'String','Sine');
  uicontrol('Callback','trigplt Cosine','Position',[508 322 51 26], ...
      'String','Cos');
  uicontrol('Callback','trigplt Tangent','Position',[508 293 51 26], ...
      'String','Tan');
else
  x = linspace(0,2*pi);
  switch(action)
    case 'Sine'
      y = sin(x); titstr = 'y = sin(x)';
    case 'Cosine'
      y = cos(x); titstr = 'y = cos(x)';
    case 'Tangent'
      y = tan(x); titstr = 'y = tan(x)';
  end
plot(x,y)
end
