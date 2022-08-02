%scLength: draw length marks on the outer boundary of the smith chart
%
%  SYNOPSIS:
%     Marks angles on the outer periphery of the smith chart
%     
%  SYNTAX:
%     scLength(inr, outr, color)
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

 function scLength(inr, outr, color)
 VecLen = [0:.002:0.5];
 for ii= 1:length(VecLen)
    if floor((ii-1)/5) ~= (ii-1)/5,
       plot([inr*cos(pi*(180-100*VecLen(ii)*7.2)/180), 1.015*inr*cos(pi*(180 - 100*VecLen(ii)*7.2)/180)], [inr*sin(pi*(180 - 100*VecLen(ii)*7.2)/180), 1.015*inr*sin(pi*(180 - 100*VecLen(ii)*7.2)/180)], color);
    else
       plot([inr*cos(pi*(180 - 100*VecLen(ii)*7.2)/180), 1.025*inr*cos(pi*(180 - 100*VecLen(ii)*7.2)/180)], [inr*sin(pi*(180 - 100*VecLen(ii)*7.2)/180), 1.025*inr*sin(pi*(180 - 100*VecLen(ii)*7.2)/180)], 'k');
       if VecLen(ii)~=0.5
          h = text(inr*1.04*cos(pi*((180 - 100*VecLen(ii)*7.2))/180), inr*1.04*sin(pi*(180 - 100*VecLen(ii)*7.2)/180), num2str(VecLen(ii),'%0.2f'));
          set(h,'color',color,'rotation',90+3.6-100*VecLen(ii)*7.2,'fontsize',6,'HorizontalAlignment','center');
       end
    end
 end
