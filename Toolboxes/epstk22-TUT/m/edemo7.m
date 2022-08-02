%%
%% Routine: Text output
%% (see demo7.png) 
%%
eopen('demo7.eps');
eglobpar;

%a few global parameter
eTextFont=1;
eTextFontSize=6;

%titel
etext('Text',15,230,[15*2 15 -45]);
etext('Features',0,0,[15*2 15 45]);

%append text
etext('demo',30,30,100,1,2,45,[0.9 0.9 0.9]);
etext('Start at (20,210)...',20,210);
etext('10mm...',0,0,10);
etext('4mm...',0,0,4);
etext('new font...or Symbols:',0,0,6,1,2);
etext('\\141\\142\\147',0,0,6,1,13);
etext('new line...',20,185);
etext('go down... ',0,-3);
etext('go up... ',0,6);
etext('and back... ',0,-3);
etext('redtext... ',0,0,6,1,5,45,[1 0 0]);
etext('yellow... ',0,0,6,1,5,-45,[1 1 0]);
etext('blue... ',0,0,6,1,5,-135,[0 0 1]);
etext('red..',0,0,6,1,5,-225,[1 0 0]);
etext('green. ',0,0,6,1,5,45,[0 1 0]);
colorMap=ecolors(3,5);

% rotation
etext('rotate Text',50,140,6,1,2,0,colorMap(1,:));
etext('rotate Text',50,140,6,1,2,45,colorMap(2,:));
etext('rotate Text',50,140,6,1,2,90,colorMap(3,:));
etext('rotate Text',50,140,6,1,2,135,colorMap(4,:));
etext('rotate Text',50,140,6,1,2,180,colorMap(5,:));

etext('rotate Text',100,150,6,0,2,0,colorMap(1,:));
etext('rotate Text',100,150,6,3,2,45,colorMap(2,:));
etext('rotate Text',100,150,6,3,2,90,colorMap(3,:));
etext('rotate Text',100,150,6,3,2,135,colorMap(4,:));
etext('rotate Text',100,150,6,0,2,180,colorMap(5,:));

etext('rotate Text',150,160,6,-1,2,0,colorMap(1,:));
etext('rotate Text',150,160,6,-1,2,45,colorMap(2,:));
etext('rotate Text',150,160,6,-1,2,90,colorMap(3,:));
etext('rotate Text',150,160,6,-1,2,135,colorMap(4,:));
etext('rotate Text',150,160,6,-1,2,180,colorMap(5,:));

% left  center right
lineStep=-8;
yValue=130;
etext('left line1....',10,yValue,6,1);
etext('....center line1....',90,yValue,6,0);
etext('....right line1',170,yValue,6,-1);
yValue=yValue+lineStep;
etext('left line2..',10,yValue,6,1);
etext('..center line2..',90,yValue,6,0);
etext('..right line2',170,yValue,6,-1);
yValue=yValue+lineStep;
etext('left line3......',10,yValue,6,1);
etext('......center line3......',90,yValue,6,0);
etext('......right line3',170,yValue,6,-1);

%special character 
lineStep=-4;
eTextFont=1;
eTextFontSize=3;
xValue=10;
yValue=yValue+1.5*lineStep;
etext('Special Character by  octal value',xValue,yValue);
s=' ';
for i=[1,2,3,4,5,6,7,8,9,11,12,14,15,]
  c=sprintf('\\134%o=\\%o  ',i,i);
  s=[s,c];
end
yValue=yValue+lineStep;
etext(s,xValue,yValue);
s=' ';
for i=[16 17 22:31]
  c=sprintf('\\134%o=\\%o  ',i,i);
  s=[s,c];
end
yValue=yValue+lineStep;
etext(s,xValue,yValue);
s=' ';
for i=[33,34,35,36,37,38,47,64]
  c=sprintf('\\134%o=\\%o  ',i,i);
  s=[s,c];
end
yValue=yValue+1.3*lineStep;
etext(s,xValue,yValue);
s=' ';
for i=[91,92,93,123,124,125,126]
  c=sprintf('\\134%o=\\%o  ',i,i);
  s=[s,c];
end
yValue=yValue+lineStep;
etext(s,xValue,yValue);
s=' ';
for i=[128 [130:140] 142]
  c=sprintf('\\134%o=\\%o  ',i,i);
  s=[s,c];
end
yValue=yValue+lineStep;
etext(s,xValue,yValue);
s=' ';
for i=147:159
  c=sprintf('\\134%o=\\%o  ',i,i);
  s=[s,c];
end
yValue=yValue+lineStep;
etext(s,xValue,yValue);
s=' ';
for i=161:175
  c=sprintf('\\134%o=\\%o  ',i,i);
  s=[s,c];
end
yValue=yValue+lineStep;
etext(s,xValue,yValue);
s=' ';
for i=176:191
  c=sprintf('\\134%o=\\%o  ',i,i);
  s=[s,c];
end
yValue=yValue+lineStep;
etext(s,xValue,yValue);
s=' ';
for i=192:207
  c=sprintf('\\134%o=\\%o  ',i,i);
  s=[s,c];
end
yValue=yValue+lineStep;
etext(s,xValue,yValue);
s=' ';
for i=208:223
  c=sprintf('\\134%o=\\%o  ',i,i);
  s=[s,c];
end
yValue=yValue+lineStep;
etext(s,xValue,yValue);
s=' ';
for i=224:239
  c=sprintf('\\134%o=\\%o  ',i,i);
  s=[s,c];
end
yValue=yValue+lineStep;
etext(s,xValue,yValue);
s=' ';
for i=[[240:252] 254 255] 
  c=sprintf('\\134%o=\\%o  ',i,i);
  s=[s,c];
end
yValue=yValue+lineStep;
etext(s,xValue,yValue);

yValue=yValue+1.5*lineStep;
etext('Special Character of font 13(Symbol) call by  octal value',xValue,yValue);
yValue=yValue+1.3*lineStep;
etext('',xValue,yValue);
for i=65:71
  c=sprintf('  \\134%o=',i);
  s=sprintf('\\%o',i);
  etext(c,0,0,eTextFontSize,1);
  etext(s,0,0,eTextFontSize,1,13);
end
etext('  ...',0,0,eTextFontSize,1);
i=90;
c=sprintf('  \\134%o=',i);
s=sprintf('\\%o',i);
etext(c,0,0,eTextFontSize,1);
etext(s,0,0,eTextFontSize,1,13);
yValue=yValue+lineStep;
etext('',xValue,yValue);
for i=97:103
  c=sprintf('  \\134%o=',i);
  s=sprintf('\\%o',i);
  etext(c,0,0,eTextFontSize,1);
  etext(s,0,0,eTextFontSize,1,13);
end
etext('  ...',0,0,eTextFontSize,1);
i=122;
c=sprintf('  \\134%o=',i);
s=sprintf('\\%o',i);
etext(c,0,0,eTextFontSize,1);
etext(s,0,0,eTextFontSize,1,13);
yValue=yValue+lineStep;
etext('',xValue,yValue);

eclose;
newbbox=ebbox(5);
if ~exist('noDemoShow')
  eview                                   % start ghostview with eps-file
end
