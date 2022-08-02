%scAngles: subdivides and shows angles on smith chart boundary
%
%  SYNOPSIS:
%     Marks angles on the outer periphery of the smith chart. The function is called
%     by scDraw to do so. May not produce desired results if called from the matlab
%     command prompt.
%
%     see also scDraw, scLength, sc
%     
%  SYNTAX:
%     scAngles(inr, outr, color)
%
%  INPUT ARGUMENTS:
%     inr   : radiur of the circle
%     outr  : radiur of the circle
%     color : desired color of the circle
%
%  OUTPUT ARGUMENT:
%     none
%
%
%     Mohammad Ashfaq - (31-05-2000)  mohammad.ashfaq@ruhr-uni-bochum.de
%     Copyright (c) 2000 by the Chair for High-Frequency Engineering
%     Ruhr-University Bochum, Germany. 
%


 function scAngles(inr, outr, color)
 for ii=0:2:360
    if floor(ii/10) ~= ii/10
       plot([inr*cos(pi*ii/180), inr*1.015*cos(pi*ii/180)], [inr*sin(pi*ii/180), inr*1.015*sin(pi*ii/180)], 'k');
    else
       plot([inr*cos(pi*ii/180), inr*1.025*cos(pi*ii/180)], [inr*sin(pi*ii/180), inr*1.025*sin(pi*ii/180)], color);
       if ii~=360
          degstr = [num2str(ii),'°'];
          h = text(inr*1.04*cos(pi*(ii)/180), inr*1.04*sin(pi*(ii)/180), degstr);
          set(h,'HorizontalAlignment','center','color',color,'rotation',270+ii+2.5,'fontsize',6);
       end
    end
 end

