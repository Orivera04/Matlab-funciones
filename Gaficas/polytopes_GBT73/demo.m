% Demo of randomly generating a set of points and computing their convex
% hull and displaying the result. Then intersecting this with a box:

V=rand(100,3);
P=convh(V);
figure(1);clf;
ax=view3d(P);

% generating a box and intersecting it with the polytope:

B=defbox([0,0,0],0.5*[1,1,1]);
P2=intersct(P,B);

view3d(P2,ax,'interp',[0,1,0]);

figure(2);clf;view(3); 
view3d(P2,gca,'interp',[0.2,1,0.2]); axis equal

% This can be also done in 4 or 5 dimensions!