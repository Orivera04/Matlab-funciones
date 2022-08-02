% scResCirc: draws r circles in the smith chart
%
%  SYNOPSIS:
%     This fuction draws r circles which have their centers on the real axis and
%     the radius is always such that they pass through the point (1,0).
%     The function is called by scDraw to do so. It may not produce desired results
%     if called from the matlab command prompt.
%
%     see also scDraw, scLength, sc
%     
%     
%  SYNTAX:
%     scResCirc(r, LinCol, xR, xL)
%
%  INPUT ARGUMENTS:
%     r      : a vector consisting of the desired values of r 
%     LinCol : desired color of the circle(s)
%     xR     : a vector containing right termination points for r circles
%     xL     : a vector containing left termination points for r circles
%
%  OUTPUT ARGUMENT:
%     none
%
%
%     Mohammad Ashfaq - (31-05-2000)  mohammad.ashfaq@ruhr-uni-bochum.de
%     Copyright (c) 2000 by the Chair for High-Frequency Engineering
%     Ruhr-University Bochum, Germany. 
%

 function scResCirc(r, LinCol, xR, xL)

 % PLOT CIRCLES
 for ii = 1:length(r)
    rc = r(ii);
    if xR(ii)~=0
       xc1 = xR(ii);
       [xco1, yco1] = scPOI(rc, xc1);
    else
       xco1 = 1;
    end

    if xL(ii)~=0
       [xco2, yco2] = scPOI(rc, xL(ii));
    else
       xco2 = 20;
    end
    if xco1 < xco2
      u      = linspace((rc-1)/(rc+1), xco1, 500);
      vplus  = sqrt((1/(1+rc))^2-(u-rc/(1+rc)).^2);
      vminus = (-sqrt((1/(1+rc))^2-(u-rc/(1+rc)).^2));
      plot(real(u),real(vplus),LinCol);
      hold on;
      plot(real(u),real(vminus),LinCol);
   end
   if xco2 ~= 20
      u      = linspace(xco2, xco1, 200);
      vplus  = sqrt((1/(1+rc))^2-(u-rc/(1+rc)).^2);
      vminus = (-sqrt((1/(1+rc))^2-(u-rc/(1+rc)).^2));
      plot(real(u),real(vplus),LinCol);
      hold on;
      plot(real(u),real(vminus),LinCol);
    end
 end
