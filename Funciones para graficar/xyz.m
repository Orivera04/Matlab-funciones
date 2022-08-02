function xyz

%XYZ    Labels the x, y and, if necessary, z, axes with the labels 'x',
%       'y' and 'z'.

% Andrew Knight, April 1994

xlabel('x')
ylabel('y')

v = view;

if any(any(v~=eye(4)))
  zlabel('z')
end
