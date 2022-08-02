%scLabels: Draws different standard labels on smith chart
%
%  SYNOPSIS:
%     This function draws different standard labels on smith chart. This function is
%     called by scDraw to to so. If called from the matlab commant prompt, it may not
%     produce the desired results.
%
%     
%  SYNTAX:
%     scLabels
%
%  INPUT ARGUMENTS:
%     none
%
%  OUTPUT ARGUMENT:
%     none
%
%
%     Mohammad Ashfaq - (31-05-2000)  mohammad.ashfaq@ruhr-uni-bochum.de
%     Copyright (c) 2000 by the Chair for High-Frequency Engineering
%     Ruhr-University Bochum, Germany. 
%

 function scLabels

 % LABEL FOR INNER SCALE
 r  = 1.25;
 th = [145:-.1:140]*pi/180;
 plot (r*cos(th), r*sin(th),'k');
 h = text(r*cos(th(1)), r*sin(th(1)), '<');
 set(h,'rotation',(th(1)-pi/2)*180/pi,'VerticalAlignment','middle');

 PStr = 'arg(r) Inner Scale';
 th = (linspace(140,120,length(PStr)))*pi/180;
 for jj = 1: length(PStr)
    h = text(r*cos(th(jj)), r*sin(th(jj)), PStr(jj));
    set(h,'rotation',(th(jj)-pi/2)*180/pi, 'fontsize',9, 'fontname','Times New Roman');
 end



 % LABEL FOR OUTER SCALE
 r  = 1.35;
 th = [125:-.1:120]*pi/180;
 plot (r*cos(th), r*sin(th),'k');
 h = text(r*cos(th(length(th))), r*sin(th(length(th))), '<');
 set(h,'rotation',(th(length(th))+pi/2)*180/pi,'VerticalAlignment','middle');

 th = [146 145 144]*pi/180;
 h = text(r*cos(th(1)), r*sin(th(1)), 'l');
 set(h,'rotation',(th(1)-pi/2)*180/pi, 'fontsize',9, 'fontname','mt extra');
 h = text(r*cos(th(2)), r*sin(th(2)), '/');
 set(h,'rotation',(th(2)-pi/2)*180/pi, 'fontsize',9, 'fontname','Times New Roman');
 h = text(r*cos(th(3)), r*sin(th(3)), '\lambda');
 set(h,'rotation',(th(3)-pi/2)*180/pi, 'fontsize',9);
 

 PStr = 'Outer scale';
 th = (linspace(142,126,length(PStr)))*pi/180;
 for jj = 1: length(PStr)
    h = text(r*cos(th(jj)), r*sin(th(jj)), PStr(jj));
    set(h,'rotation',(th(jj)-pi/2)*180/pi, 'fontsize',9, 'fontname','Times New Roman');
 end


 % PRINT ZL =   AT THE BOTTOM RIGHT CORNER

 h = text (1.0, -1, 'Z_L =      \Omega');
 set(h, 'fontname', 'Times New Roman', 'fontsize', 14,'HorizontalAlignment', 'right');
 

 % DRAW THE TRANSMISSION LINE SYMBOL AT THE BOTTOM LEFT CORNER

 % TL OUTLINE
 Lx = -1.00;
 Rx = -0.75;
 Ty = -0.95;
 By = -1.05;
 plot([Lx Rx],[Ty Ty], 'r');
 plot([Lx Rx],[By By], 'r');
 
 % CONNECTION POINTS
 Cx = 0.03;
 h=plot([Rx-Cx Rx-Cx Lx Lx],[Ty By Ty By], '.');
 set(h,'linewidth',1.5);


 % CONNECTIVE LINES
 Cy = 0.02
 plot([Rx Rx],[Ty Ty-Cy], 'r');
 plot([Rx Rx],[By By+Cy], 'r');

 % IMPEDANCE HORIZONTAL LINES
 Ix = 0.01;
 plot([Rx-Ix Rx+Ix], [By+Cy By+Cy] , 'b');
 plot([Rx-Ix Rx+Ix], [Ty-Cy Ty-Cy] , 'b');

 % IMPEDANCE VERTICAL LINES
 plot([Rx-Ix Rx-Ix], [Ty-Cy By+Cy] , 'b');
 plot([Rx+Ix Rx+Ix], [Ty-Cy By+Cy] , 'b');

 % LABEL R+jX
 h = text (Lx,(Ty+By)/2,'R + jX');
 set (h, 'fontname', 'Times New Roman', 'fontsize', 5);

 % LABEL l and lines etc.
 h = text ((Rx+Lx-Cx)/2, By -0.05,'l');
 set (h, 'fontname', 'mt extra', 'fontsize', 5, 'HorizontalAlignment', 'center');
 plot([Lx    (Rx+Lx-Cx)/2-0.01],[By-0.05 By-0.05], 'k');
 plot([Rx-Cx (Rx+Lx-Cx)/2+0.01],[By-0.05 By-0.05], 'k');
 plot([Lx    Lx   ], [By-0.04 By-0.06],'k');
 plot([Rx-Cx Rx-Cx], [By-0.04 By-0.06],'k');
 
 
 
