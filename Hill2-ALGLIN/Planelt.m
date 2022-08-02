function planelt                                %last updated 9/13/98
%PLANELT   Demonstration of plane linear transformations:
%
%                Rotations              Reflections  
%          Expansions/Compressions      Shears
%
%          Or you may specify your own transformation.
%
%          Graphical results of successive plane linear
%          transformations can be seen using a multiple window
%          display. Standard fiqures can be chosen or you may
%          choose to use your own figure.
%
%          Use in the form  ==>  planelt  <==
%
%          By: David R. Hill, Math Dept, Temple Uinversity
%              Philadelphia, Pa. 19122
     

% Notes: Input trapped for empty (ie returns).
%        Can not trap for alpha input where numeric is expected.
%
%        clc done after input to try to reduce flicker upon
%        return from graphics.

fighead=[blanks(20) 'FIGURE CHOICES'];
figmenu=['1. Unit Square.                4. A triangle.       ';
         '                                                    ';
         '2. Rectangle 2 by 1.           5. A pentagon.       ';
         '                                                    ';
         '3. Parallelogram.              6. Enter your figure.';
         '                                                    ';
         '0. Quit.                                            '];
s0=' ';
s1='Enter your choice  ==> ';
s2='Press Enter to continue.';
s3='*** Invalid choice.';
s4='Choices';
s5='Original Figure';
s6='Current Figure';
s7='Previous Figure';
s8='MATRIX of Current Lin. Trans.';

figcolor='rbmgck'; %colors for the six figure types
figchmax=6;
ltchmax=11;
plthead=[blanks(20) 'PLANE LINEAR TRANSFORMATIONS'];
pltmenu=...
['1. Rotation (in degrees).         6. Expand/compress in x-direction.     ';
 '2. Reflect about x-axis.          7. Expand/compress in y-direction.     ';
 '3. Reflect about y-axis.          8. Shear in x-direction.               ';
 '4. Reflect about line y = x.      9. Shear in y-direction.               ';
 '5. Reflect about line y = -x.    10. Use your 2 by 2 matrix.             ';
 '                                 11. Restore the original figure.        ';
 '                                                                         ';
 '-1. Undo the last transformation. (Can not be used successively.)        ';
 '                                                                         ';
 '0. Start with a new figure.                                              '];
intro=...
['                         INTRODUCTION                          ';
 '                                                               ';
 '     This is a demonstration of "Plane Linear Transformations".'; 
 'That is, linear transformations from a PLANE into itself. Each ';
 'such transformation is represented by a 2 by 2 matrix A. To    ';
 'perform the transformation on a figure represented by a set of ';
 'ordered pairs, we multiply each ordered pair by A to obtain the';
 '"coordinates" of the transformed figure. Some transformations  ';
 'result in familiar geometric manipulations of a figure. Simple ';
 'computer graphics notions can be illustrated by "before" and   ';
 '"after" pictures displayed side-by-side. Experiments can be    ';
 'performed.                                                     '];
directions=...
['                       GENERAL DIRECTIONS                      ';
 '                                                               ';
 '     The first step is to choose a figure to "transform". You  ';
 'can view the figure before beginning your transformation       ';
 '"experiments". Next you can choose a number of different       ';
 'geometric transformations to maneuver your figure around the   ';
 'plane. For simplicity we "view" the plane as a square 10 units ';
 'on a side. Just follow the directions.                         '];
figure1=[0 0;1 0;1 1;0 1;0 0]'; %Unit square
figure2=[0 0;2 0;2 1;0 1;0 0]'; %Rect 2 by 1
figure3=[0 0;3 1;4 3;1 2;0 0]'; %Parallelogram
figure4=[-2 0;2 0;0 2;-2 0]'; %Triangle
figure5=[1 -1;-1 1;1 2;2 1;2 0;1 -1]'; %Pentagon
figure6=[];
figname=['Unit Square     ';'Rectangle 2 by 1';'Parallelogram   ';
         'Triangle        ';'Pentagon        ';'Your Figure     '];
viewmenu=['1. See the                                       ';
          '                                                 ';
          '2. Use this figure. Go to select transformations.';
          '                                                 ';
          '0. Choose a different figure.                    '];
yourst=...
['Your figure consists of a set of ordered pairs which are connected in';
 'the order entered. To obtain a closed figure make the last ordered   ';
 'pair the same as the first. Example: to enter the triangle with      ';
 'vertices       (-1,0),  (0,3),  (1,0)   enter into MATLAB            ';
 '                                                                     ';
 '                    [-1 0 1 -1;0 3 0 0]                              ';
 '                                                                     ';
 'which is the list of x-coordinates separated from the corresponding  ';
 'y-coordinates by a semicolon with brackets surrounding these items.  '];


setwin='if handel==0,figure,set(gcf,''units'',''normal''),';
setwin=[setwin 'set(gcf,''position'',[0 0 1 1]),handel=gcf;end'];
        %setting graphics window to full size
setwin2='if handel~=0,figure(handel),set(handel,''units'',''normal''),';
setwin2=[setwin2 'set(handel,''position'',[0 0 1 1]),end'];
        %setting graphics window to full size second time or higher
skfig='axlim=[1 -1];';    %COMPUTING X & Y axis lengths to draw
skfig=[skfig 'xmax=max([wkfig(1,:) axlim])+1;'];
skfig=[skfig 'xmin=min([wkfig(1,:) axlim])-1;'];
skfig=[skfig 'ymax=max([wkfig(2,:) axlim])+1;'];
skfig=[skfig 'ymin=min([wkfig(2,:) axlim])-1;'];
%Determining if figure is a line or not via least squares
skfig=[skfig 'pcoef=polyfit(wkfig(1,:),wkfig(2,:),1);'];
skfig=[skfig 'vcoef=polyval(pcoef,wkfig(1,:));ckline=max(abs(wkfig(2,:)-vcoef));'];
skfig=[skfig 'if ckline<1000*eps,plot(wkfig(1,:),wkfig(2,:),figcolor(figch)),'];
skfig=[skfig 'else,'];
skfig=[skfig 'fill(wkfig(1,:),wkfig(2,:),figcolor(figch)),end,'];
skfig=[skfig 'hold on,'];
skfig=[skfig 'plot([xmin xmax],[0 0],''-y'','];
skfig=[skfig '[0 0],[ymin ymax],''-y'',''erasemode'',''none''),'];
skfig=[skfig 'if ckline<1000*eps,plot(wkfig(1,:),wkfig(2,:),'];
skfig=[skfig 'figcolor(figch)),end,']; %redrawing line in case it
                                               %is an axis
skfig=[skfig 'drawnow,title(sklabel),hold off,'];

mat1='[cos(deg) -sin(deg);sin(deg) cos(deg)]';
mat2=[1 0;0 -1];
mat3=[-1 0;0 1];
mat4=[0 1;1 0];
mat5=[0 -1;-1 0];
mat6='[xk 0;0 1]';
mat7='[1 0;0 yk]';
mat8='[1 xk;0 1]';
mat9='[1 0;yk 1]';
mat10=[];

%START ****************************
%detsw='N'; %switch for user matrix being singular; initializing
done='N';
while done=='N'
   clc,disp(intro),disp(s0),disp(s2),pause
   clc,disp(directions),disp(s0),disp(s2),pause,clc
   figch=20; %setting a switch
   while figch~=0,gotfig='N'; %setting a switch
      while gotfig=='N'
         handel=0; %initialize figure number so we 
                   %know a figure does not exist
         disp(fighead),disp(s0),disp(s0),disp(figmenu),disp(s0)
         figch=input(s1);clc  %CHOOSING A FIGURE
         if isempty(figch),figch=-10;end
         while abs(fix(figch))~=figch | figch > figchmax
            disp(s3),disp(s0),disp(s2),pause,clc
            disp(fighead),disp(s0),disp(s0),disp(figmenu),disp(s0)
            figch=input(s1);  %CHOOSING A FIGURE
            clc
            if isempty(figch),figch=-10;end
         end
         if figch==0,clc,disp('Plane Linear transformations is over!')
            return
         end
         if figch > 0 & figch < 6
            st=['figure' num2str(figch)];
            origfig=eval(st);wkfig=origfig;prevfig=origfig;
         end
         if figch==6
            disp([blanks(30) 'Enter Your Figure']),disp(s0)
            disp(yourst),disp(s0),figure6=input('Your figure ==> ');
            clc
            origfig=figure6;wkfig=origfig;prevfig=origfig;
         end
         viewch=20; %setting a switch
         seeit='N'; %setting switch about viewing figure first
         while viewch~=0
            disp(s0),disp([blanks(30) s4]),disp(s0)
            viewmenu(1,12:27)=figname(figch,:);
            disp(viewmenu),disp(s0),viewmenu(1,12:27)=blanks(16);
            viewch=input(s1);  % VIEW A FIGURE
            clc
            if isempty(viewch),viewch=-10;end
            while abs(fix(viewch))~=viewch | viewch > 2
               disp(s3),disp(s0),disp(s2),pause
               clc,disp(s0),disp([blanks(30) s4]),disp(s0)
               viewmenu(1,12:27)=figname(figch,:);
               disp(viewmenu),disp(s0),viewmenu(1,12:27)=blanks(16);
               viewch=input(s1);clc
               if isempty(viewch),viewch=-10;end
            end
            if viewch==0,gotfig='N';end
            if viewch==1,gotfig='N';seeit='Y';
               figure,set(gcf,'units','normal')
               set(gcf,'position',[0 0 1 1])  
               %setting position of graphics window to full size
               handel=gcf;
               clf,sklabel=s5;subplot(2,2,4),eval(skfig)
               xlabel(s2)
               pause,close(handel)
               clc
            end
            if viewch==2,gotfig='Y';viewch=0;end
         end %viewch~=0
      end %gotfig
%BEGIN linear transformations
      ltdone='N'; %setting a switch

      while ltdone=='N'
         disp(plthead),disp(s0),disp(pltmenu),disp(s0)
         %handel,seeit
         ltch=input(s1);clc
         if isempty(ltch),ltch=-10;end
         if ltch~=-1
            while abs(fix(ltch))~=ltch | ltch >ltchmax
               disp(s3),disp(s0),disp(s2),pause
               clc,disp(plthead),disp(s0),disp(pltmenu),disp(s0)
               ltch=input(s1);clc
               if isempty(ltch),ltch=-10;end
            end
         end
         if ltch==0,ltdone='Y';end
         if ltch==-1
            eval(setwin),eval(setwin2)
            wkfig=prevfig;sklabel=s6;subplot(2,2,1),eval(skfig)
            xlabel('previous transformation undone')
            wkfig=prevfig;sklabel=s7;subplot(2,2,2),eval(skfig)
            wkfig=origfig;sklabel=s5;subplot(2,2,4),eval(skfig)
            xlabel(s2)
            pause,close(handel)
         end
         if ltch==11
            eval(setwin),eval(setwin2)
            wkfig=origfig;sklabel=s6;subplot(2,2,1),eval(skfig)
            prevfig=origfig;sklabel=s7;subplot(2,2,2),eval(skfig)
            sklabel=s5;subplot(2,2,4),eval(skfig)
            xlabel(s2)
            pause,close(handel)
         end
         if ltch==1
            disp([blanks(20) 'Rotation']),disp(s0)
            disp('Enter the rotation angle in degrees. Counter clockwise is a')
            disp('positive angle and clockwise a negative angle.')
            disp(s0),deg=input('  angle ==> ');
            while isempty(deg),deg=input('  angle ==> ');end
            clc
            angdeg=deg; %used in mess below
            deg=(deg*pi)/180;
            A=eval(mat1);
            mess=['Rotation of ' num2str(angdeg) 'deg. performed'];
         end
         if ltch==2
            A=mat2;mess='x-axis reflection performed';
         end
         if ltch==3
            A=mat3;mess='y-axis reflection performed';
         end
         if ltch==4
            A=mat4;mess='y = x reflection performed';
         end
         if ltch==5
            A=mat5;mess='y = -x reflection performed';
         end
         if ltch==6
            xk=0;
            while xk <= 0
            disp([blanks(20) 'Expand/compress in x-direction']),disp(s0)
            disp('Enter positive expansion/compression factor:')
            disp(s0),xk=input(' ==>  k = ');
            while isempty(xk),xk=input(' ==>  k = ');end
            clc
            end
            A=eval(mat6);
            if xk > 1,mess='expansion performed';end
            if xk < 1,mess='compression performed';end
            if xk==1,mess='identity transformation ';end
         end
         if ltch==7
            yk=0;
            while yk <= 0
            disp([blanks(20) 'Expand/compress in y-direction']),disp(s0)
            disp('Enter positive expansion/compression factor:')
            disp(s0),yk=input(' ==>  k = ');
            while isempty(yk),yk=input(' ==>  k = ');end
            clc
            end
            A=eval(mat7);
            if yk > 1,mess='expansion performed';end
            if yk < 1,mess='compression performed';end
            if yk==1,mess='identity transformation ';end
         end
         if ltch==8
            disp([blanks(20) 'Shear in x-direction']),disp(s0)
            disp('Enter shear factor:')
            disp(s0),xk=input(' ==>  k = ');
            while isempty(xk),xk=input(' ==>  k = ');end
            clc
            A=eval(mat8);
            mess='shear in x-direction';
         end
         if ltch==9
            disp([blanks(20) 'Shear in y-direction']),disp(s0)
            disp('Enter shear factor:')
            disp(s0),yk=input(' ==>  k = ');
            while isempty(yk),yk=input(' ==>  k = ');end
            clc
            A=eval(mat9);
            mess='shear in y-direction';
         end
         if ltch==10
            sz='N';
            while sz=='N'
            disp([blanks(20) 'Use your own matrix.']),disp(s0)
            disp('Enter your matrix in the form  [a b;c d], where the')
            disp('first row is a b and the second is c d.')
            disp(s0),A=input('  matrix  ==> ');clc
            if max(size(A))==2 & min(size(A))==2
               sz='Y';
            end
            end
            %degenerate case cause by singular matrix checked for in skfig
            mess='your transformation performed';
         end
         if ltch~=0 & ltch~=-1 & ltch~=11
            newfig=A*wkfig;prevfig=wkfig; %sketch transformed stuff
            %handel,seeit,pause
            eval(setwin)
            if seeit=='Y' %Checking if figured viewed initially
               eval(setwin2) %If seeit = Y, then handel ~=0 &
            end              %should execute setwin2
            seeit='Y';    %Turning off first time through indicator.
            wkfig=prevfig;sklabel=s7;subplot(2,2,2),eval(skfig)
            if ltch==4  %drawing line y = x if that reflection is chosen
               hold on
               plot([xmin xmax],[xmin xmax],'y','erasemode','none')
               drawnow,hold off
            end
            if ltch==5  %drawing line y = -x if that reflection is chosen
               hold on
               plot([xmin xmax],[-xmin -xmax],'y','erasemode','none')
               drawnow,hold off
            end
            tic;while toc<.75,end
            subplot(2,2,3) %Showing Lin. Trans. Matrix
            axis('off'),axis([-5 5 -5 5])
            %Putting in line from prev. fig. to matrix
            m=(3.05-7.62)/(4.06-7.85);h=-(7.85-4.06)/10;
            s=7.85+h*[0:10];t=7.62+m*(h*[0:10]);
            for j=1:11,tic;while toc<.2,end
               text(s(j),t(j),'<','FontWeight','bold',...
                   'FontAngle','oblique','Color','b','erasemode','none')
               drawnow
            end
            tic;while toc<.5,end
            text(-5,3,'MATRIX of Current Lin. Trans.','erasemode','none')  
            %hold
            vn=A;lvn=[];
            for i=1:2
              for j=1:2,
              if abs(vn(i,j))<10*eps,vn(i,j)=0;end %Setting small to zero     
              lvn(i,j)=length(mat2strh(vn(i,j)));
              end
            end
            vn=reshape(vn,4,1);lvn=reshape(lvn,4,1);
            for i=1:4
                st=mat2strh(vn(i));
                n=7-lvn(i);   %hoping e-format never encountered
                if n>0
                   for j=1:n
                       st=[st ' '];
                   end
                end
                if i==1, v1=st;end
                if i==2, v2=st;end
                if i==3, v3=st;end
                if i==4, v4=st;end
            end
            %text(-3,2,lct),text(4,2,rct),text(-3,-2,lcb),text(4,-2,rcb)
            text(-2.5,1,v1,'erasemode','none')
            text(1,1,v3,'erasemode','none')
            text(-2.5,-1,v2,'erasemode','none')
            text(1,-1,v4,'erasemode','none')
            %for i=-1.25:.5:1.5,text(-3,i,vl),text(4,i,vl),end
            %Putting in line from matrix to current fig.
            tic;while toc<.5,end
            m=(6.88-3.19)/(-4.46+6.37);h=(-4.46+6.37)/5;
            s=-6.37+h*[0:5];t=3.19+m*(h*[0:5]);
            for j=1:6,tic;while toc<.2,end
               text(s(j),t(j),'>','FontWeight','bold',...
                   'FontAngle','oblique','Color','r','erasemode','none')
            end
            tic;while toc<1,end
            wkfig=newfig;sklabel=s6;subplot(2,2,1),eval(skfig)
            if ltch==4  %drawing line y = x if that reflection is chosen
               hold on
               plot([xmin xmax],[xmin xmax],'y','erasemode','none')
               drawnow,hold off
            end
            if ltch==5  %drawing line y = -x if that reflection is chosen
               hold on
               plot([xmin xmax],[-xmin -xmax],'y','erasemode','none')
               drawnow,hold off
            end
            xlabel(mess)
            pause(2)
            wkfig=origfig;sklabel=s5;subplot(2,2,4),eval(skfig)
            pause(1)
            %subplot(2,2,3)
            xlabel(s2)
            pause,close(handel)
            wkfig=newfig;
         end
      end %ltch
   end %figch~=0
   if figch==0,done='Y';end
end %done
clc,disp('Plane Linear Transformations is over!')
