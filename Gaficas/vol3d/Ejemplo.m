 % Visualizing fluid flow
 v = flow(50);
 h = vol3d('cdata',v,'texture','2D');
 view(3); 
 % Update view since 'texture' = '2D'
 vol3d(h);  
 alphamap('rampdown'), alphamap('decrease'), alphamap('decrease')
 
 % Visualizing MRI data
 load mri.mat
 D = squeeze(D);
 h = vol3d('cdata',D,'texture','2D');
 view(3); 
 % Update view since 'texture' = '2D'
 vol3d(h);  
 axis tight;  daspect([1 1 .4])
 alphamap('rampup');
 alphamap(.06 .* alphamap);
