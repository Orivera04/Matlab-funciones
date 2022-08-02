% Demonstration of surface construction by extrusion.
%

srf = nrbextrude(nrbtestcrv,[0 0 5]);
nrbplot(srf,[40 10]);
title('Extrusion of a test curve along the z-axis');
