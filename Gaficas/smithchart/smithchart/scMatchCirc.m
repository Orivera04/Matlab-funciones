%scMatchCirc : Draws the match-circle on smith chart
%
%  SYNOPSIS:
%     This function draws a circle for impedance matching purposes on the smith
%     chart. Such a circle has its origin at the point (-0.5, 0) and has a radius
%     equal to 0.5
%
%     See also scDraw, scInv, scMove, scConCirc
%     
%  SYNTAX:
%     scMatchCirc(LinCol)
%
%  INPUT ARGUMENTS:
%     LinCol     : Color of the matching circle, default = 'g', green
%
%  OUTPUT ARGUMENT:
%     none
%
%
%     Mohammad Ashfaq - (31-05-2000)  mohammad.ashfaq@ruhr-uni-bochum.de
%     Copyright (c) 2000 by the Chair for High-Frequency Engineering
%     Ruhr-University Bochum, Germany. 
%

function scMatchCirc(LinCol)

 if nargin == 0
    LinCol = 'g';
 end

 x = [-1:0.01:0];
 y = real(sqrt(0.5^2-(x+.5).^2));
 plot(x,  y, LinCol);
 plot(x, -y, LinCol);

