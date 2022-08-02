function plotmesh(u)
% Helper function for enginetable.mdl demo

% Author(s): Bora Eryilmaz
% Copyright 1995-2002 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:37:29 $

global X Y Z

set(gcf, 'Units', 'norm', 'Position', [0.1 0.1 .8 .4]); 

subplot(1,2,1)
h1 = surfl(Y,X,Z);
shading interp
colormap(gray)
title('Plant Surface using Measured Data')
xlabel('Engine Speed (rpm)');
ylabel(sprintf('Intake Manifold Pressure\n(kPa)'));
zlabel('Volumetric Efficiency');
axis([0 7000 0 100 0.5 1])

subplot(1,2,2)
h2 = surfl(Y,X,u);
shading interp
colormap(gray)
title('Plant Surface using Adaptive Lookup Table (Stair-fit)')
xlabel('Engine Speed (rpm)');
ylabel(sprintf('Intake Manifold Pressure\n(kPa)'));
zlabel('Volumetric Efficiency');
axis([0 7000 0 100 0.5 1])
