% CLXROTZ.M  Rotate a vector around the z axis 
%  Input the vector [x y z] and the angle in degrees.
%  Function clxrotzf is called to perform rotation
v1=input(' Vector [x y z]= ')
theta=input(' Input rotation angle (degrees)= ')
v11=[v1 1]';                % Form homogeneous vector
vrotz=clxrotzf(v11,theta);  % Rotate
fprintf('Rotated vector\n')
vrotz                       % Display result

