eopen('chrcode.eps');
eglobpar;

%titel
etext('Character Codes',eWinWidth/2,230,10,0);

%text character 
eTextFont=1;
eTextFontSize=4;
xValue=5;
yValue=210;
lineStep=-4.5;
etext('Character codes of font 1-12 and 14-31 call by  octal value',xValue,yValue);
yValue=yValue+lineStep;
eTextFontSize=3;
for i=0:254
  c=sprintf('  \\134%o=',i);
  s=sprintf('\\%o',i);
  if rem(i,15)==0
    yValue=yValue+lineStep;
    xValue=5;
  end
  etext(c,xValue,yValue,eTextFontSize,1);
  etext(s,0,0,eTextFontSize,1);
  xValue=xValue+11;
end
yValue=yValue+lineStep;
yValue=yValue+lineStep;
yValue=yValue+lineStep;
eTextFontSize=4;
xValue=5;
etext('Character Codes of font 13 call by  octal value',xValue,yValue);
yValue=yValue+lineStep;
eTextFontSize=3;
for i=0:254
  c=sprintf('  \\134%o=',i);
  s=sprintf('\\%o',i);
  if rem(i,15)==0
    yValue=yValue+lineStep;
    xValue=5;
  end
  etext(c,xValue,yValue,eTextFontSize,1);
  etext(s,0,0,eTextFontSize,1,13);
  xValue=xValue+11;
end

eclose;
ebbox(5);
eview;
