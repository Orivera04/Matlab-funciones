data = rand(10,10,10);         % random data
datas = smooth3(data,'box',3); % smoothed data

subplot(1,2,1) % random data
p = patch(isosurface(data,.5), ...
     'FaceColor','Blue','EdgeColor','none');
patch(isocaps(data,.5), ...
     'FaceColor', 'interp', 'EdgeColor', 'none');
isonormals(data,p)
view(3); axis vis3d tight off
camlight; lighting phong
title({'Figure 26.36a:' 'Random Data'})

subplot(1,2,2) % smoothed random data
p = patch(isosurface(datas,.5), ...
     'FaceColor','Blue','EdgeColor','none');
patch(isocaps(datas,.5), ...
     'FaceColor', 'interp', 'EdgeColor', 'none');
isonormals(datas,p)
view(3); axis vis3d tight off
camlight; lighting phong
title({'Figure 26.36a:' 'Smoothed Data'})