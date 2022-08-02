%%
%% Routine: Text boxes
%% (see demo11.png) 
%%
bgcolor=[1 1 0.8];
eopen('demo11.eps');
eglobpar

% head
%eWinGridVisible=1;
w=eWinWidth;
fs=20;
x=0;
h=fs/2;y=eWinHeight-h;
text='epsTk News';
eframe(x,y,w,h,0,-1,[0.0 0.5 0.0]); %background
etxtbox(text,x,y,w,h,[fs fs 10],0,1,0,[0 0 0],[1 1]); %shadow text
etxtbox(text,x,y,w,h,[fs],0,1,0,bgcolor); %main text
etext('Mai 2007',160,y+h/2,4,3,1,0,[1 1 0]); %text
h=h*0.8;y=y-h;
eframe(x,y,w,h,0,-1,bgcolor); %background
etxtbox(text,x,y,w,h,[fs fs 10],0,1,0,[0 0 0],[1 1+fs/2]); %shadow text
etxtbox(text,x,y,w,h,fs,0,1,0,[1 0 0],[0 fs/2]); % main text
yHead=y;
eframe(0,0,eWinWidth,yHead,0,-1,bgcolor); %background of ellipse
eellipse(x+20,y+h,40,10,0,-1,[1 0 0],15); %fill ellipse
eellipse(x+20,y+h,40,10,0,0,[0 0 0],15);  %border of ellipse
etext('version 2.2',x+20,y+h,4,3,14,15,[1 1 0]); %text

% text
eTextBoxSpaceWest=1.5;
eTextBoxSpaceEast=1.5;
eTextBoxSpaceNorth=1.5;
w=eWinWidth/3;
h=17;y=y-h;
fs=6;
text='Econometrics with Octave';
etxtbox(text,x,y,w,h,[fs*1.5 fs 10],0,3,0,[0 0 0]); %title

rText=etxtread([ePath 'octave.asc']); %get text from file
h=y;y=y-h;
fs=3;
endKey='Version 1.0';
pos=findstr(rText,endKey);
text=rText(1:pos(1)-1);
rText=rText(pos(1):length(rText));
etxtbox(text,x,y,w,h,fs,2,1,0,[0 0 0]); %1. column of text

x=x+w;
h=143;y=yHead-h;
endKey='octave-epstk';
pos=findstr(rText,endKey);
text=rText(1:pos(1)-1);
rText=rText(pos(1):length(rText));
etxtbox(text,x,y,w,h,fs,2,1,0,[0 0 0]); %2. column of text 

[im cm]=eshadois;
h=w;y=y-h;
eframe(x,y,w,w,0.5,im,cm); % insert epstk logo
eframe(x,y,w,w,0.5,[1 3 1],[0 0 0]); %frame

h=50;y=y-h;
text=rText;
etxtbox(text,x,y,w,h,fs,2,3,0,[1 0 0]); % last part of text

% filelist
fs=6;
x=x+w;
h=eTextBoxSpaceNorth+fs+eTextBoxSpaceSouth;y=yHead-h;
text='M-Files of epsTk';
etxtbox(text,x,y,w,h,fs,0,3,0,[0 0 0]); %title
text=etxtread([ePath 'mFileList']);
[tPos n]=etxtlpos(text);
nRows=ceil(n/3);
fs=2.9;
h=(eTextBoxSpaceNorth+nRows*fs+eTextBoxSpaceSouth)*1.1;y=y-h;
cx=x;
cText=text(tPos(1,1):tPos(nRows,2));
etxtbox(cText,cx,y,w/3,h,fs,2,1,0,[0 0 1]); %1. column
cx=x+w/3;
cText=text(tPos(nRows+1,1):tPos(2*nRows,2));
etxtbox(cText,cx,y,w/3,h,fs,2,1,0,[0 0 1]); %2. column
cx=x+2*w/3;
cText=text(tPos(2*nRows+1,1):tPos(n,2));
etxtbox(cText,cx,y,w/3,h,fs,2,1,0,[0 0 1]); %3. column

% feature list
fs=6;
h=eTextBoxSpaceNorth+fs+eTextBoxSpaceSouth;
text='New feature of 2.2';
etxtbox(text,x,y,w,h,fs,0,3,0,[0 0 0]); %title

fs=5;
font=1;
dotSize=fs/2;
iDotX=x+eTextBoxSpaceWest+dotSize/2;
iDotShift=eTextBoxSpaceNorth+fs/2;
iTxtX=iDotX+dotSize/2;
iw=w-iTxtX+x;
edsymbol('dot','fring.psd',dotSize/10,dotSize/10,0,0,0,[0 0.3 0]);

rows=1;h=eTextBoxSpaceNorth+rows*fs+eTextBoxSpaceSouth;y=y-h;
esymbol(iDotX,y+h-iDotShift,'dot');
text='HTML documentation';
etxtbox(text,iTxtX,y,iw,h,fs,1,font,0,[0 0 0]); %feature list item

rows=1;h=eTextBoxSpaceNorth+rows*fs+eTextBoxSpaceSouth;y=y-h;
esymbol(iDotX,y+h-iDotShift,'dot');
text='rebuilt eimgzoom';
etxtbox(text,iTxtX,y,iw,h,fs,1,font,0,[0 0 0]); %feature list item

rows=1;h=eTextBoxSpaceNorth+rows*fs+eTextBoxSpaceSouth;y=y-h;
esymbol(iDotX,y+h-iDotShift,'dot');
text='new tools for encrytion';
etxtbox(text,iTxtX,y,iw,h,fs,1,font,0,[0 0 0]); %feature list item

rows=2;h=eTextBoxSpaceNorth+rows*fs+eTextBoxSpaceSouth;y=y-h;
esymbol(iDotX,y+h-iDotShift,'dot');
text='auto data reduction of plot data';
etxtbox(text,iTxtX,y,iw,h,fs,1,font,0,[0 0 0]); %feature list item

rows=1;h=eTextBoxSpaceNorth+rows*fs+eTextBoxSpaceSouth;y=y-h;
esymbol(iDotX,y+h-iDotShift,'dot');
text='more dash styles';
etxtbox(text,iTxtX,y,iw,h,fs,1,font,0,[0 0 0]); %feature list item

rows=1;h=eTextBoxSpaceNorth+rows*fs+eTextBoxSpaceSouth;y=y-h;
esymbol(iDotX,y+h-iDotShift,'dot');
text='more character codes';
etxtbox(text,iTxtX,y,iw,h,fs,1,font,0,[0 0 0]); %feature list item

rows=1;h=eTextBoxSpaceNorth+rows*fs+eTextBoxSpaceSouth;y=y-h;
esymbol(iDotX,y+h-iDotShift,'dot');
text='lot of bugs removed';
etxtbox(text,iTxtX,y,iw,h,fs,1,font,0,[0 0 0]); %feature list item
eclose

if ~exist('noDemoShow')
  eview                                   % start ghostview with eps-file
end
