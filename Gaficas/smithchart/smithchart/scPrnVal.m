%scPrnVal: Prints x and r values on the smith chart
%
%  SYNOPSIS:
%     This fuction prints x and r values on the smith chart.
%
%     THIS function is called internally from the function scDraw.
%
%     see also
%     
%  SYNTAX:
%     scPrnVal(vPrn, rORx)
%
%  INPUT ARGUMENTS:
%     vPrn  : value to be printed
%     rORx  : whether an 'r' or an 'x' value is to be printed.
%
%  OUTPUT ARGUMENT:
%     none
%
%
%     Mohammad Ashfaq - (31-05-2000)  mohammad.ashfaq@ruhr-uni-bochum.de
%     Copyright (c) 2000 by the Chair for High-Frequency Engineering
%     Ruhr-University Bochum, Germany. 
%

 function scPrnVal(vPrn, rORx)

 if rORx == 'x'
    % PRINT x VALUES
    for jj = 1 : length(vPrn)
       xc   = vPrn(jj);
       [xco1, yco1] = scPOI(0, xc);
       [xco2, yco2] = scPOI(1, xc);

       if floor(xc)==xc & length(num2str(floor(xc)))>=2
          PrStr='%0.0f';
       else
          PrStr='%0.1f';
       end

       h = text (min(xco1), max(yco1), num2str(xc,PrStr));
       set(h,'color','r', 'rotation', 180*atan2(1-min(xco1), max(yco1)-abs(1/xc))/pi, 'fontsize', 4.5, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
   
       h = text (min(xco1), -max(yco1), num2str(xc, PrStr));
       set(h,'color','r', 'rotation', 180+180*atan2(-1+min(xco1), max(yco1)-abs(1/xc))/pi, 'fontsize', 4.5, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
       if xc <=1
          h = text (min(xco2), -max(yco2), num2str(xc, PrStr));
          set(h,'color','r', 'rotation', 180+180*atan2(-1+min(xco2), max(yco2-abs(1/xc)))/pi, 'fontsize', 4.5, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');

          h = text (min(xco2), max(yco2), num2str(xc, PrStr));
          set(h,'color','r', 'rotation', 180*atan2(1-min(xco2), max(yco2)-abs(1/xc))/pi, 'fontsize', 4.5, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
       end
    end
 elseif rORx == 'r'
    % PRINT r VALUES
    for jj = 1 : length(vPrn)
       rc   = vPrn(jj);
       xco1 = (rc-1)/(rc+1);
       yco1 = 0.01;
       [xco2, yco2] = scPOI(rc, 1);
       if floor(rc)==rc & length(num2str(floor(rc)))>=2
          PrStr='%0.0f';
       else
          PrStr='%0.1f';
       end
       h = text (xco1, yco1, num2str(rc,PrStr));
       set(h,'color','r','rotation',90,'fontsize',4.5,'HorizontalAlignment','left', 'VerticalAlignment', 'bottom');
       if rc <= 1
          h = text (xco2, yco2, num2str(rc,PrStr));
          set(h,'color','r','rotation',180*atan2(rc/(1+rc)-xco2, yco2)/pi, 'fontsize',4.5,'HorizontalAlignment','left', 'VerticalAlignment', 'bottom');
          h = text (xco2, -yco2, num2str(rc,PrStr));
          set(h,'color','r','rotation', 180+180*atan2(rc/(1+rc)-xco2, -yco2)/pi, 'fontsize',4.5,'HorizontalAlignment','left', 'VerticalAlignment', 'bottom');
       end
    end
 else
    error('scPrnVal.m: The second argument must either be r or x');
 end
   
   
