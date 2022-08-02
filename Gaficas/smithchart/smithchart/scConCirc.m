%scConCirc: draws concentric circles about the origin
%
%  SYNOPSIS:
%     Draws circle about origin in desired color.
%
%     See also scDraw, scInv, scMove, scMatchCirc  
%     
%  SYNTAX:
%     scConCirc(r,color)
%
%  INPUT ARGUMENTS:
%     r      : radius of the circle
%     LinCol : desired color of the arc, optional, default = 'r', red
%
%  OUTPUT ARGUMENT:
%     none
%
%
%     Mohammad Ashfaq - (31-05-2000)  mohammad.ashfaq@ruhr-uni-bochum.de
%     Copyright (c) 2000 by the Chair for High-Frequency Engineering
%     Ruhr-University Bochum, Germany. 
%

 function scConCirc(r,LinCol)
 
 if nargin == 1
    LinCol = 'r';
 end

 x = linspace(-r,r,200);
 plot(x, sqrt(r^2-x.^2),LinCol);
 plot(x,-sqrt(r^2-x.^2),LinCol);
