%scDraw : Draws a blank smith chart
%
%  SYNOPSIS:
%     When called without arguments, the function draws a standard smith chart.
%     Otherwise, one may want to draw only specific curves for r and/or x values.
%     For different calling syntaxes see under SYNTAX.
%
%     See also scRay, scMove, scConCirc, scMatchCirc : available for different tasks
%     
%     
%  SYNTAX:
%     [h] = scDraw(r, x, ChColor, xR, xL, rR, rL)
%           draws only the r and x lines required with extrimitiex [rR rL] & [xR xL]
%     [h] = scDraw(r, x, ChColor)
%           draws only the r and x lines required
%     [h] = scDraw
%           draws a standard smith chart
%
%     And one can suppress the secondary details like scales and labels by calling:
%     [h] = scDraw(0)
%           draws 'only' a standard smith chart without r and m scales etc.
%
%  INPUT ARGUMENTS:
%     r       : A vector consisting of the desired values of r 
%     x       : A vector consisting of the desired values of x
%     ChColor : Color of the smith chart
%     xL      : a vector of x values containing left termination points for r circles
%     xR      : a vector of x values containing right termination points for r circles
%     rL      : a vector of r values containing left termination points for x arcs
%     rR      : a vector of r values containing right termination points for r arcs
%
%  OUTPUT ARGUMENT:
%     h : figure handle. If no output argument is given, the handle is returned in
%         the workspace variable ans. 
%
%
%     Mohammad Ashfaq - (31-05-2000)  mohammad.ashfaq@ruhr-uni-bochum.de
%     Copyright (c) 2000 by the Chair for High-Frequency Engineering
%     Ruhr-University Bochum, Germany. 
%

 function h = scDraw(r, x, ChColor, xR, xL, rR, rL)
 
 FullMapWithLabels = 1;
 if nargin==1
    FullMapWithLabels   = r;
 end
 if nargin<=1
    % DEFINE STANDARD DEFAULT FOR r
    r= [0.00, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50, 0.50, 0.55, 0.60, 0.65,...
        0.70, 0.75, 0.80, 0.85, 0.90, 0.95, 1.00, 1.10, 1.20, 1.30, 1.40, 1.50, 1.50, 1.60, 1.70,...
        1.80, 1.90, 2.00, 2.20, 2.40, 2.50, 2.60, 2.80, 3.00, 3.50, 4.00, 4.50, 5.00, 6.00, 7.00,...
        8.00, 9.00, 10.0, 15.0, 20.0, 50.0];
    xR=[   0,    1,    2,    1,    4,    1,    2,    1,    4,    1,    2,    5,     1,   4,    1,...
           2,    1,    4,    1,    2,    1,   10,    2,    4,    2,    4,    2,     5,   4,    2,...
           4,    2,   20,    2,    2,    5,    2,    2,   10,    5,   10,    5,    10,  10,   10,...
          10,   10,   20,   20,   50,   0];

    xL=[   0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     4,     0,   0,    0,...
           0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     4,   0,    0,...
           0,    0,    0,    0,    0,    2,    0,    0,    0,    0,    0,     0,     0,   0,    0,...
           0,    0,    0,    0,    0,    0];
    rPrint = [[0.1:0.1:1.0],1.5 2.0 3.0 4.0 5.0 10 20 50];

    % DEFINE STANDARD DEFAULT FOR x
    x=[0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50,  0.50, 0.55, 0.60, 0.65, 0.70,...
       0.75, 0.80, 0.85, 0.90, 0.95, 1.00, 1.10, 1.20, 1.30, 1.40,  1.50, 1.50, 1.60, 1.70, 1.80,...
       1.90, 2.00, 2.20, 2.40, 2.50, 2.60, 2.80, 3.00, 3.20, 3.40,  3.50, 3.60, 3.80, 4.00, 4.50,...
       5.00, 6.00, 7.00, 8.00, 9.00, 10.0, 15.0, 20.0, 50.0];
    rR=  [1,    2,    1,    3,    1,    2,    1,    3,    1,    2,     5,    1,    3,    1,    2,...
          1,    3,    1,    2,    1,   10,    2,    3,    2,    3,     2,    5,    3,    2,    3,...
          2,   10,    2,    2,    5,    2,    2,   10,    2,    2,     5,    2,    2,   10,    5,...
         10,   10,   10,   10,   10,   20,   20,   50,   0];

    rL=  [0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     3,    0,     0,   0,    0,...
          0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,    3,     0,   0,    0,...
          0,    0,    0,    0,    2,    0,    0,    0,    0,    0,     2,    0,     0,   0,    0,...
          0,    0,    0,    0,    0,    0,    0     0,    0];
    xPrint  = [[0.1:0.1:1.0],1.5 2.0 3.0 4.0 5.0 10 20 50];
    ChColor = 'b';
 end
 
 if nargin == 2 | nargin ==3 
    rR = zeros(size(r));
    rL = zeros(size(x));
    xR = zeros(size(r));
    xL = zeros(size(x));
    rPrint = r;
    xPrint = x;
 end
 if nargin ==2 
    ChColor = 'b';
 end
 
 if isempty(get(gcf, 'name')) | nargin ==0
    h = gcf;
    set(gcf,'MenuBar','none','numbertitle','off','name','Smith Chart');
    set(gca,'position',[0.01 0.01 0.98 0.98]);
    scPresent = 0;
 else
    scPresent = 1;
 end
 
 
 % DRAW r CIRCLES
 scResCirc(r, ChColor, xR, xL);
 axis equal;
 axis off;


 % DRAW x ARCS
 scReacArc(x, 1, ChColor, rR, rL);
 scReacArc(x, -1, ChColor, rR, rL);

 if ~scPresent

    % DRAW THE OUTER CIRCLE AND THE X-AXIS
    plot([-1 1],[0 0], ChColor);
    plot([-1:.001:1], sqrt(1-[-1:.001:1].^2), ChColor);
    plot([-1:.001:1],-sqrt(1-[-1:.001:1].^2), ChColor);

    % PRINT r VALUES
    scPrnVal(rPrint, 'r');
   
    % PRINT x VALUES
    scPrnVal(xPrint, 'x');
    
    % DRAW THE ANGLE BOUNDARY
    scConCirc(1.01,'r');
    scConCirc(1.08,'r');
    scAngles(1.01, 1.08, 'r');
    
    % DRAW THE LENGTH BOUNDARY
    scConCirc(1.085,'m');
    scConCirc(1.16,'m');
    scLength(1.085, 1.16, 'm');
   
    if FullMapWithLabels
       scScales;
       scLabels;
    end
 end
