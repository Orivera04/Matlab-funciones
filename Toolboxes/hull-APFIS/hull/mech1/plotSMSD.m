function []=plotSMSD(x,shear,moment,slope,displacement)
%PLOTSMSD Plots a Shear, Moment, Slope and Displacement diagram.
%   PLOTSMD(X,SHEAR,MOMENT,SLOPE,DISPLACEMENT) is a quick routine to show 
%   the SHEAR, MOMENT, SLOPE and DISPLACEMENT diagrams on the same figure.
%   This routine can and should b modified to specific needs.
%
%   See also PLOTSMD.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00


subplot(4,1,1)
plot ([0,x],[0,shear])
title ('Shear')
expandaxis; showx

subplot(4,1,2)
plot ([0,x],[0,moment])
title ('Moment')
expandaxis; showx
 
subplot (4,1,3)
plot (x,slope)
title ('Slope')
expandaxis; showx

subplot (4,1,4)
plot (x,displacement)
title ('Displacement')
expandaxis; showx
