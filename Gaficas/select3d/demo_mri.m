%DEMO_MRI
%  Demonstrates SELECT3D. Click on the mri patch
%  and you should see the 3-D point selected along
%  with location output to the command window.

%  Copyright Joe Conti 2002 
%  Send comments to jconti@mathworks.com

load mri
D = squeeze(D);
D(:,1:60,:) = [];
p = patch(isosurface(D, 5), 'FaceColor', 'red', 'EdgeColor', 'none');
h = patch(isocaps(D, 5), 'FaceColor', 'interp', 'EdgeColor', 'none');
view(20,20); axis tight;  daspect([1 1 .4])
colormap(gray(100))
camlight; lighting gouraud
isonormals(D, h);
       
select3dtool;

