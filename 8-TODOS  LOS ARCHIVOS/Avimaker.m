% This program can generate AVI movies starting from a series of ASCII files containing your data in matrix format.
% All you have to do is selecting the directory containing the ASCII files ordered names (with an increasing number in name
% filename001.txt filename002.txt ...) and the program will open the first and the last, it will 
% evaluate the range for the colorbar and it will show the z range so that you can change. 
% After that you will have to set the parameters for your movie (using GETFRAME and ADDFRAME), 
% set the dimensions (in case you need to crop the images), select the color for the background
% of the frames, the coordinates for the Camera if you need a 3D visualization and in the desired 
% directory you will find your AVI file.
% For details on AVI options see ADDFRAME and GETFRAME.

%Tested under MATLAB 6.0

%Danilo Botta 06-04-05 

clc;
echo off;
clear all;
close all;
fclose('all');

%Input file directory selection
percorso=[];
[rfile,percorso]=uigetfile('*.*','Select input file directory');
path(path,percorso);

%Output file directory selection
stringa=['Select output file directory'];
filex='ini.txt';
[filex,perf1]=uiputfile(filex,stringa);

%Iterative file loading routine (ascending order)   
files=[];
files=dir(percorso);
fileN=[];
filesN=(files(3:length(files)));




%Colorbar range evaluation;
rfx1=filesN(1).name;
npx1=find(rfx1=='.');
rfcpx1=rfx1(1:npx1(length(npx1))-1);
fx1=[percorso,rfcpx1,'.txt'];
Ax1=load(fx1);
[rAx,cAx]=size(Ax1);

max1=max(max(Ax1));
min1=min(min(Ax1));

rfx2=filesN(length(filesN)).name;
npx2=find(rfx2=='.');
rfcpx2=rfx2(1:npx2(length(npx2))-1);
fx2=[percorso,rfcpx2,'.txt'];
Ax2=load(fx2);

max2=max(max(Ax2));
min2=min(min(Ax2));

maxx=[max1 max2];
minx=[min1 min2];

Ma=num2str(max(maxx));
mi=num2str(min(minx));

rep=2;

    

xmap='bone';
mix=mi;
Max=Ma;
while rep==2,
    close all;
    
    figure;
    pcolor(Ax2);
    shading interp;
    view(0,270);
    set(gca,'DataAspectRatio',[1 1 1]);
    colormap(xmap);
    colorbar;
    axis off;
    box off;
    title('Frame example - Last frame');
        
    prompt={'Colormap:','Colormap lower limit:','Colormap higher limit:'};
    tit1='Image setup';
    lines=1;
    def= {xmap,mix,Max};
    limiti=inputdlg(prompt,tit1,lines,def);
    map=limiti{1};
    low=limiti{2};
    high=limiti{3};
    clear col;
    col=uisetcolor([1 1 1], 'Select background color:');
    
    lim(1)=str2num(low);
    lim(2)=str2num(high);
    
    figure;
    pcolor(Ax1);
    shading interp;
    view(0,270);
    set(gca,'DataAspectRatio',[1 1 1]);
    set(gcf,'Color',col);
    caxis(lim);
    colormap(map);
    colorbar;
    axis off;
    box off;
    title('Background color example - First frame');    
    
    figure;
    pcolor(Ax2);
    shading interp;
    view(0,270);
    set(gca,'DataAspectRatio',[1 1 1]);
    set(gcf,'Color',col);
    caxis(lim);
    colormap(map);
    colorbar;
    axis off;
    box off;
    title('Background color example - Last frame');
    
    clear npx1 npx2;
    rep=menu('Do you want to confirm the setup?', 'Yes', 'Change');
    xmap=map;
    clear map
    mix=low;
    Max=high;
    close all;

end

%AVI file setup
nomefile=[perf1 'film'];
prompt={'File name:','fps:','quality:','compression:','colormap:','colormap lower limit:','colormap higher limit:','tot n° of frames'};
tit1='AVI setup';
lines=1;
def= {nomefile,'1','100','none',xmap,mix,Max,num2str(length(filesN)),'Yes'};
limiti=inputdlg(prompt,tit1,lines,def);
name=limiti{1};
fp=str2num(limiti{2});
qual=str2num(limiti{3});
cp=limiti{5};
cpx=limiti{4};
nt=str2num(limiti{8});


aviobj=avifile(name);
aviobj.Quality=qual;
aviobj.fps=fp;

aviobj.compression=cpx;
l(1)=str2num(limiti{6});
l(2)=str2num(limiti{7});

figure;
pcolor(Ax2);
shading interp;
view(0,270);
set(gca,'DataAspectRatio',[1 1 1]);
set(gcf,'Color',col);
caxis(l);
colormap(xmap);
colorbar;
axis off;
box off;
title('Last frame');

%Resize setup
go1=2;
clear Ax2old;
Ax2old=Ax2;

go1=menu('Do you want to crop the images in the frames?', 'No', 'Crop');
[rA,cA]=size(Ax2old);
X1=1;
X2=cA;
Y1=1;
Y2=rA;
while go1>=2, 
    close all;
    if go1==3,
        clear Ax2;
        Ax2=Ax2old;
    end
    
    figure;
    pcolor(Ax2);
    shading interp;
    view(0,270);
    set(gca,'DataAspectRatio',[1 1 1]);
    set(gcf,'Color',col);
    caxis(l);
    colormap(xmap);
    colorbar;
    axis off;
    box off;
    title('Last frame - Select range to crop');
   
    msg1=sprintf('Select the 2 points to drag a selection box');
    h=msgbox(msg1,'Crop');
    waitfor(h)
    
    msg1=sprintf('Select the 1st point - Please wait');
    h=msgbox(msg1,'Crop');
    waitfor(h)
    
    k = waitforbuttonpress;
    point1 = get(gca,'CurrentPoint');    % 1st point
    finalRect = rbbox;   
    
    msg1=sprintf('Select the 2nd point - Please wait');
    h=msgbox(msg1,'Crop');
    waitfor(h)
    k = waitforbuttonpress;
    point2 = get(gca,'CurrentPoint');    % 2nd point
    point1 = point1(1,1:2);              % extract x and y
    point2 = point2(1,1:2);
    p1 = min(point1,point2);             % calculate locations
    offset = abs(point1-point2);         % and dimensions
    x = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
    y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
    hold on
    axis manual
    axis off;
    plot(x,y)
    box off;
    
    X1c=round(min(point1(1,1),point2(1,1)));
    Y1c=round(min(point1(1,2),point2(1,2)));
    X2c=round(max(point1(1,1),point2(1,1)));
    Y2c=round(max(point1(1,2),point2(1,2)));
    
    prompt={'Xmin:','Ymin:','Xmax:','Ymax:'};
    tit1='Cut frame properties';
    lines=1;
    def= {num2str(X1c),num2str(Y1c),num2str(X2c),num2str(Y2c)};
    lim=inputdlg(prompt,tit1,lines,def);
    X1=str2num(lim{1});
    Y1=str2num(lim{2});
    X2=str2num(lim{3});
    Y2=str2num(lim{4});

    clear Acrop;
    Acrop(1:(Y2-Y1)+1,1:(X2-X1)+1)=Ax2(Y1:Y2,X1:X2);
    
    close;
    
    figure;
    pcolor(Acrop);
    shading interp;
    view(0,270);
    set(gca,'DataAspectRatio',[1 1 1]);
    set(gcf,'Color',col);
    caxis(l);
    colormap(xmap);
    colorbar;
    axis off;
    box off;
    title('Last frame - Cropped');
    

    clear Ax2;
    Ax2=Acrop;

    go1=menu('Do you want to crop the images in the frames?', 'No', 'Crop','Undo');
    
end

%3D visualization
[Y2c,X2c]=size(Ax2);
X1c=1;
Y1c=1;

close all;
scrsz = get(0,'ScreenSize');   
h=figure('Position',[1 30 scrsz(3) scrsz(4)/1.2]); 
surf(Ax2);
shading interp;
set(gca,'DataAspectRatio',[1 1 1]);
set(gcf,'Color',col);
caxis(l);
colormap(cp);
colorbar;
axis([1 X2c 1 Y2c l(1) l(2)]);
box off;
grid off;
axis off;
view(0,270);
po=campos;
pox=po(1);
poy=po(2);
poz=po(3);
poxold=pox;
poyold=poy;
pozold=poz;
poxs=num2str(pox);
poys=num2str(poy);
pozs=num2str(poz);
title('Last frame - 3D visualization');

go3=menu('Do you want to visualize the image in 3 dimensions?', 'No','Yes');

no3D=0;
if go3==1,
    no3D=1;
end

while go3>=2,
        
    if go3==3,
        poxs=num2str(poxold);
        poys=num2str(poyold);
        pozs=num2str(pozold);
    end
    close all;
    prompt={'Camera position (x):','Camera position (y):','Camera position (z):'};
    tit1='3D visualization';
    lines=1;
    def= {poxs,poys,pozs};
    datig=inputdlg(prompt,tit1,lines,def);
    pox=str2num(datig{1});     
    poy=str2num(datig{2});  
    poz=str2num(datig{3});  
    
    
    scrsz = get(0,'ScreenSize');   
    h=figure('Position',[1 30 scrsz(3) scrsz(4)/1.2]); 
    surf(Ax2);
    shading interp;
    set(gca,'DataAspectRatio',[1 1 1]);
    set(gcf,'Color',col);
    caxis(l);
    colormap(cp);
    colorbar;
    axis([1 X2 1 Y2 l(1) l(2)]);
    box off;
    grid off;
    axis off;

    axis vis3d off;
    campos([pox, poy,poz]);
    poxs=datig{1};
    poys=datig{2};
    pozs=datig{3};
    drawnow;

    title(['Camera position x: ', datig{1},' - y: ',datig{2},' - z: ',datig{3}])
    
    go3=menu('3D Visualization ','Confirm coordinates','New coordinates','Undo');

end

% Iterative loading
close all;
for jf=1:nt,
   rf=filesN(jf).name;
   np=find(rf=='.');
   rfcp=rf(1:np(length(np))-1);
   f=[];
   f=[percorso,rfcp,'.txt'];
   B=[];
   B=load (f);
   [righeA,colonneA]=size(B);
   
   [num2str(jf),'/',num2str(length(filesN)), ' frames processed']
   
   A(1:(Y2-Y1)+1,1:(X2-X1)+1)=B(Y1:Y2,X1:X2);
   
   scrsz = get(0,'ScreenSize');   
   h=figure('Position',[1 30 scrsz(3) scrsz(4)/1.2]);   
   set(gcf,'Color',col);
   surf(A);
   axis([1 X2 1 Y2 l(1) l(2)]);
   shading interp;
   set(gca,'DataAspectRatio',[1 1 1]);
   caxis(l);
   colormap(cp);
   colorbar;
   box off;
   if no3D==1,
       view(0,270);
       axis off;
   else
       axis vis3d off
       campos([pox,poy,poz]);
       drawnow;
   end
   %grid off;
   %axis off;

    
   frame=getframe(h);
   aviobj = addframe(aviobj,frame);
    
   filename=[perf1,rfcp];
   saveas(gcf,filename,'tif');
   
   close;
   clear A;
end


aviobj=close (aviobj);
['AVI file in directory ', perf1]
msg1=sprintf(['AVI file created in ']);
msg1=[msg1, perf1];
h=msgbox(msg1,'Finished');
waitfor(h)


rmpath(percorso);

clear all;
close all;
status = fclose('all');

