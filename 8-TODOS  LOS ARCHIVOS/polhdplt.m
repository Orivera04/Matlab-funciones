function polhdplt(x,y,z,idface,colr)
%
% polhdplt(x,y,z,idface,colr)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function makes a surface plot of an 
% arbitrary polyhedron.
%
% x,y,z  - vectors containing the corner 
%          indices of the polyhedron
% idface - a matrix in which row j defines the 
%          corner indices of the j'th face. 
%          Each face is traversed in a 
%          counterclockwise sense relative to 
%          the outward normal. The column 
%          dimension equals the largest number 
%          of indices needed to define a face. 
%          Rows requiring fewer than the 
%          maximum number of corner indices are 
%          padded with zeros on the right.
% colr   - character string or a vector 
%          defining the surface color
%
% User m functions called: cubrange
%----------------------------------------------

if nargin<5, colr=[1 0 1]; end
hold off, close; nf=size(idface,1);
v=cubrange([x(:),y(:),z(:)],1.1); 
for k=1:nf
  i=idface(k,:); i=i(find(i>0));
  xi=x(i); yi=y(i); zi=z(i);
  fill3(xi,yi,zi,colr); hold on;
end
axis(v); grid on;
xlabel('x axis'); ylabel('y axis');
zlabel('z axis');
title('Surface Plot of a General Polyhedron');
figure(gcf); hold off;