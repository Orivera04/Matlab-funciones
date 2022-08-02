%scReacArc: draws x arcs in the smith chart
%
%  SYNOPSIS:
%     This fuction draws x arcs which have their centers on the the line parallel
%     to the imaginary axis and passing through the point (1,0).
%
%     The function is called by scDraw to do so. It may not produce desired results
%     if called from the matlab command prompt.
%
%     see also scDraw, scLength, scResCirc
%     
%     
%  SYNTAX:
%     scReacArc(x, updown, LinCol, rR, rL)
%
%  INPUT ARGUMENTS:
%     x     : a vector consisting of the desired values of x
%     updown: draw arc in the upper(lower) half plane if positive(negative)
%     LinCol: desired color of the arc
%     rR    : a vector containing left termination points for x arcs
%     rL    : a vector containing right termination points for x arcs
%
%  OUTPUT ARGUMENT:
%     none
%
%
%     Mohammad Ashfaq - (31-05-2000)  mohammad.ashfaq@ruhr-uni-bochum.de
%     Copyright (c) 2000 by the Chair for High-Frequency Engineering
%     Ruhr-University Bochum, Germany. 
%

 function scReacArc(x,updown,LinCol,rR, rL)

 for jj=1:length(x)
    xc     = x(jj);
    if rR(jj)~=0
       rc1 = rR(jj);
       [xco1, yco1] = scPOI(rR(jj), xc);
    else
       xco1 = 1;
    end

    if rL(jj)~=0
       [xco2, yco2] = scPOI(rL(jj), xc);
    else
       xco2 = 20;
    end
    if xco1 < xco2 & xc~=0
      % FOR THE ARCS STARTING FROM THE OUTERMOST CIRCLE
      if xc <= 1
      % IF THE 9'O CLOCK POS. OF THE X ARC DOES NOT LIE WITHIN THE SMITH CHART
         uup = [];
         vup = [];
         udn = linspace((xc^2-1)/(xc^2+1), xco1, 500);
         vdn = sign(updown)*(1/xc-sqrt((1/xc)^2-(udn-1).^2));

      elseif (1/xc-sqrt((1/xc)^2-(1-1/xc-1).^2)) < yco1
      % IF THE 9'O CLOCK POS. OF THE X ARC  IS LOWER THAN POINT OF INTERSECTION
         uup = linspace(xco1,(xc^2-1)/(xc^2+1),100);
         vup = sign(updown)*(1/xc+sqrt(1/xc^2-(uup-1).^2));
         udn = [];
         vdn = [];
      else
      % IF THE 9'O CLOCK POS. OF THE X ARC  IS HIGHER THAN POINT OF INTERSECTION
         uup = linspace(1-1/xc,(xc^2-1)/(xc^2+1),100);
         vup = sign(updown)*(1/xc+sqrt(1/xc^2-(uup-1).^2));
         udn = linspace(1-1/xc,xco1,500);
         vdn = sign(updown)*(1/xc-sqrt((1/xc)^2-(udn-1).^2));
      end
   end
   if xco2~=20 & xc~=0
      if (1/xc-sqrt((1/xc)^2-(1-1/xc-1).^2)) > yco2
         uup = [];
         vup = [];
         udn = linspace(xco2, xco1, 500);
         vdn = sign(updown)*(1/xc-sqrt((1/xc)^2-(udn-1).^2));
      else
      % IF THE 9'O CLOCK POS. OF THE X ARC  IS LOWER THAN POINT OF INTERSECTION
         uup = linspace(1-1/xc,xco2,100);
         vup = sign(updown)*(1/xc+sqrt(1/xc^2-(uup-1).^2));
         udn = linspace(1-1/xc,xco1,500);
         vdn = sign(updown)*(1/xc-sqrt((1/xc)^2-(udn-1).^2));
      end
   end
   if xc~=0
      plot(real(uup),real(vup),LinCol);
      plot(real(udn),real(vdn),LinCol);
   end
 end
