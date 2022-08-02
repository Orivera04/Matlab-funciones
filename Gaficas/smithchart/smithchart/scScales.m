%scScales: draws the reflection factor and m scales on the smith chart
%
%  SYNOPSIS:
%     This function draws the reflection factor and m scales on the smith chart
%     The function is called by scDraw to do so. It may not produce desired results
%     if called from the matlab command prompt.
%
%     see also scDraw, scLength, sc
%     
%     
%  SYNTAX:
%     scScales
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

 function scScales

 % DRAW BASE LINES
 hold on;
 yB = 1.50;
 xB = 0.05;

 plot(xB+[0 1], (yB+0.00)*[1 1], 'r');
 plot(xB+[0 1], (yB+0.01)*[1 1], 'r');

 % DRAW r DIVISIONS  AND PLACE r TEXT LABELS
 for jj = 0:10
    plot(xB+[jj,jj]/10, [yB+0.01, yB+.04],'r');
    if jj ~=10
       plot(xB+[jj+.5,jj+.5]/10,[yB+0.01, yB+0.03],'r');
    end
    h = text(xB+jj/10, yB+0.05,num2str((10-jj)/10,'%1.1f'));
    set(h,'rotation',90,'fontsize',5,'fontname','Times New Roman');
 end
 
 % PUT CAPTION TEXT ETC. FOR REFLECTION FACTOR
 h = text(xB+0.5, yB+0.18, 'Reflection Factor |r|');
 set (h, 'fontname','Times New Roman','fontsize', 8,'fontname','Times New Roman','HorizontalAlignment','center');
 h = text(xB+0.15, yB+0.18, '<');
 set (h, 'color','b');
 plot(xB+[0.15 0.25], (yB+0.18)*[1 1]);


 % DRAW REFLECTED POWER DIVISIONS  AND PLACE TEXT LABELS
 PVal = [1:-0.1:0.2, 0.1:-0.02:0.02, 0.01 0.0];
 for jj = 1: length(PVal)
    plot(xB+[1-sqrt(PVal(jj)), 1-sqrt(PVal(jj))], [yB, yB-0.03], 'r');
    if jj ~=length(PVal)
       plot(xB+[1-sqrt((PVal(jj)+PVal(jj+1))/2), 1-sqrt((PVal(jj)+PVal(jj+1))/2)], [yB, yB-.02], 'r');
    end
    if PVal(jj)>0 & PVal(jj)<0.1
       PrStr = '%1.2f';
    else
       PrStr = '%1.1f';
    end
    h = text(xB+1-sqrt(PVal(jj)), yB-0.04,num2str(PVal(jj),'%1.2f'));
    set(h,'rotation',90,'HorizontalAlignment','right','fontname','Times New Roman','fontsize',5);
 end


 % PUT CAPTION TEXT ETC. FOR REFLECTED POWER
 h = text(xB+0.5, yB-0.19, 'Reflected Power');
 set (h, 'fontname','Times New Roman','fontsize', 8,'fontname','Times New Roman','HorizontalAlignment','center');
 h = text(xB+0.15, yB-0.19, '<');
 set (h, 'color','b');
 plot(xB+[0.15 0.25], (yB-0.19)*[1 1]);


 % ESTABLISH AND DRAW SCALES FOR m
 mValMain = [0:0.1:1];
 rUpMain  = abs((mValMain-1)./(mValMain+1));
 mValSub  = [0.05:0.1:0.95];
 rUpSub   = abs((mValSub-1)./(mValSub+1));

 mdBMain  = [0:2:10 15 20 30 40];
 rDoMain  = abs((10.^(-mdBMain/20)-1)./(1+10.^(-mdBMain/20)));
 mdBSub   = [1 3 5 7 9 11 12 13 14 16 17 18 19 22 24 26 28];
 rDoSub   = abs((10.^(-mdBSub/20)-1)./(1+10.^(-mdBSub/20)));

 plot(-xB-[0 1], (yB+0.00)*[1 1], 'r');
 plot(-xB-[0 1], (yB+0.01)*[1 1], 'r');


 % DRAW m DIVISIONS  AND PLACE m TEXT LABELS
 for jj = 1:length(mValMain)
    plot(-xB-[rUpMain(jj),rUpMain(jj)], [yB+0.01, yB+.04],'r');
    h = text(-xB-rUpMain(jj), yB+0.05,num2str(mValMain(jj),'%1.1f'));
    set(h,'rotation',90,'fontsize',5,'fontname','Times New Roman');
 end
 for jj = 1:length(mValSub)
    plot(-xB-[rUpSub(jj),rUpSub(jj)], [yB+0.01, yB+.03],'r');
 end
 
 % PUT CAPTION TEXT ETC. FOR REFLECTION FACTOR
 h = text(-xB-0.5, yB+0.18, 'm = |u_{min}/u_{max}|');
 set (h, 'fontname','Times New Roman','fontsize', 8,'fontname','Times New Roman','HorizontalAlignment','center');
 h = text(-xB-0.145, yB+0.18, '<');
 set (h, 'color','b','rotation',180);
 plot(-xB-[0.15 0.25], (yB+0.18)*[1 1]);



 % DRAW mdB DIVISIONS  AND PLACE mdB TEXT LABELS
 for jj = 1:length(mdBMain)
    plot(-xB-[rDoMain(jj),rDoMain(jj)], [yB, yB-.03],'r');
    h = text(-xB-rDoMain(jj), yB-0.04, num2str(mdBMain(jj), '%.0f'));
    set(h,'rotation',90,'fontsize',5,'fontname','Times New Roman','HorizontalAlignment','right');
 end
 plot(-xB-[1,1], [yB, yB-.03],'r');
 h = text(-xB-1, yB-0.04, '\infty');
 set(h,'rotation',90,'fontsize',5,'HorizontalAlignment','right');


 for jj = 1:length(mdBSub)
    plot(-xB-[rDoSub(jj),rDoSub(jj)], [yB, yB-.02],'r');
 end
 
 % PUT CAPTION TEXT ETC. FOR mdB
 h = text(-xB-0.5, yB-0.19, 'm in db');
 set (h, 'fontname','Times New Roman','fontsize', 8,'fontname','Times New Roman','HorizontalAlignment','center');
 h = text(-xB-0.75, yB-0.19, '<');
 set (h, 'color','b');
 plot(-xB-[0.65 0.75], (yB-0.19)*[1 1]);
