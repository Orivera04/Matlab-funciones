%                                                    last updated 10/24/97
%LSQLINE   This routine will construct the equation of the least
%          square line to a data set of ordered pairs and then graph the
%          line and the data set. A short menu of options is available,
%          including evaluating the equation of the line at points and
%          displaying the deviations between the linear model and the
%          data set.
%
%          Use in the form:  --> lsqline  <--
%
%          You will be prompted for input.
%
%          On exit variable lsqcoeff contains the coefficiencts 
%          of the least squares line:
%
%                         y = c(1)*x + c(2)
%
%          Uses mat2strh utility.
%  By: David R. Hill, Math. Dept., Temple University,
%      Philadelphia, Pa. 19122     Email: hill@math.temple.edu

%=======================================================================
%Code for setting color definition to emulate MATLAB version 4
%within version 5.
%The idea is to try to use the same code for version 4 as 5 with the 
%m-files that accompany  LINEAR ALGEBRA LABS with MATLAB, Second Edition
%                      by Hill and Zitarelli
%                        Prentice Hall, 1996
vers=version;vers=vers(1);
specstr='colordef none';
specstr1='colordef white';
if vers=='5',eval(specstr),end
%=======================================================================


%STRINGS


s0=' ';
s1='Your choice: ==>  ';
s2='Improper choice; try again!';
s3='Press ENTER to continue.';
s4a='LSQLINE is over!';
header1='LEAST SQUARES';header2='LINE MODEL';
head=['                    <><><>  Least Squares Line  <><><>';
      '                                                      ';
      '**** Input Options ****                               '];


s5='Enter the name of the n by 2 matrix of data ==>';
s8='Data Matrix = ';
s9=['Enter x-coordinates in a vector like [ 2,5, ... ]';
    'Do not forget the square brackets.               '];
s10='Enter vector  ==> ';
s11=['Enter y-coordinates in a vector like [ 3,-9, ... ]';
     'Do not forget the square brackets.                '];
s14='Matrix of data must be n by 2';

dmenu=[' 1. Type in vectors containing the x & y          ';
       '    coordinates of the data.                      ';
       '                                                  ';
       ' 2. Enter the name of a vector containing the     ';
       '    x-coordinates of the data and another name    ';
       '    that contains the y-coordinates.              ';
       '                                                  ';
       ' 3. Enter the name of an n by 2 matrix of data.   ';
       '                                                  ';
       ' 0. QUIT.                                         '];
makech='Enter your choice  ==>  ';
cont='Press ENTER to continue.';

%INPUT Routine
%
%Determining Data Input MODE
%
validch='N';
while validch=='N'
   clc,disp(s0),disp(head),disp(s0),disp(s0)
   disp(dmenu),ch=input(makech);
   if ch==0
      if vers=='5',eval(specstr1),end
      validch='Y';clc,disp(s4a),return
   end
   if ch==2
      validch='Y';
      clc,disp(s0)
      x=input('Enter name of vector containing x-coordinates ==> ');
      disp(s0)
      y=input('Enter name of vector containing y-coordinates ==> ');
      x=x(:);y=y(:);
      xlen=length(x);ylen=length(y);
      if (xlen~=ylen)
         validch='N';
         disp('ERROR: Input vectors do not have the same number of points.')
         disp(s0),disp(s3),pause
      end    
   end 
   if ch==1
      validch='Y';clc
      disp(s9),x=input(s10);disp(s11),y=input(s10);
      x=x(:);y=y(:);
      xlen=length(x);ylen=length(y);
      if (xlen~=ylen)
         validch='N';
         disp('ERROR: Input vectors do not have the same number of points.')
         disp(s0),disp(s3),pause
      end    
   end 
   if ch==3, validch='Y';
      clc,disp(s0),dmat=input(s5);,disp(s0)
      [m,n]=size(dmat);
      if n~=2
         disp(s14),disp(s3),validch='N';pause
      else
        x=dmat(:,1);y=dmat(:,2);
      end      
   end
  
end %of while





[m,n]=size(x);x=reshape(x,m*n,1);
[m,n]=size(y);y=reshape(y,m*n,1);
if length(x)~=length(y)
   disp(' Error: number of x and y values must be the same.')
   return
end

%Getting least squares line coeff
%
c=polyfit(x,y,1);lsqcoeff=c;

%setting up bounds
xl=min(x);xh=max(x);
xd=xh-xl;yd=max(y)-min(y);
xpl=xl-.2*xd;xpr=xh+.1*xd;ypb=min(y)-.1*yd;ypt=max(y)+.1*yd;
rval=[xpl xpr ypb ypt];
yl=c(1)*xpl+c(2);yh=c(1)*xpr+c(2);
%Error computation
serr=0;
for ii=1:length(x);serr=serr+(y(ii)-(c(1)*x(ii)+c(2)))^2;end

%locations of deviation messages
%
locsum1=[-.16 .60;-.16 .55;-.16 .50;-.16 .45;-.16 .40;-.16 .35];


%callback for the help button
helps='set(gcf,''visible'',''off'');clc,help lsqline,disp(s3),';
helps=[helps 'pause,set(gcf,''visible'',''on'');'];

%CALL back for quit button
done = 'close(gcf),if vers==''5'',eval(specstr1),end,clc,disp(s4a)';
%callback for quit button
%

%callback for radio button for deviations
%
drawit='form=[''-'' clor];axes(grbox);hold on;';
drawit=[drawit 'for ii=1:length(x),'];
drawit=[drawit 'plot([x(ii) x(ii)],[y(ii) c(1)*x(ii)+c(2)],form,'];
drawit=[drawit '''erasemode'',''none''),drawnow,end,hold off'];

%call back for ERROR-- Sum of squares of deviations
%
disperr=['axes(basehndl);sterr=[''Error = '' num2str(serr)];'];
disperr=[disperr 'if vers~=''5'','];
disperr=[disperr 'text(.05,.42,sterr,''color'',''red'','];
disperr=[disperr '''fontsize'',16,''fontweight'',''bold'');'];
disperr=[disperr 'else,'];
disperr=[disperr 'text(.05,.35,sterr,''color'',''red'','];
disperr=[disperr '''fontsize'',16,''fontweight'',''bold'');'];
disperr=[disperr 'end;'];

%callback for show data table
dispdata='set(gcf,''visible'',''off'');clc,more on, [x y],more off,disp(s3),';
dispdata=[dispdata 'pause,set(gcf,''visible'',''on'');'];

%callback for evaluating the model]
valmodel='scrmess=''To Return to the Graphics Screen select Figure No. '';';
valmodel=[valmodel 'scrmess=[scrmess num2str(gcf) ];'];
valmodel=[valmodel 'scrmess1= '' from the Windows pull down menu.'';'];
valmodel=[valmodel 'set(gcf,''visible'',''off'');clc,'];
valmodel=[valmodel 'disp(''Evaluating the Least Squares Line Model''),'];
valmodel=[valmodel 'disp(s0),disp(s0),'];
valmodel=[valmodel 'disp([''The model equation is: '' eqn]),'];
valmodel=[valmodel 'disp(s0),disp(s0),'];
valmodel=[valmodel 'disp(''Enter a single value for x or ''),'];
valmodel=[valmodel 'disp(''a vector of values enclosed '];
valmodel=[valmodel 'between square brackets.''),disp(s0),'];
valmodel=[valmodel 'inval=input(''Input value(s) ==> '');inval=inval(:);'];
valmodel=[valmodel 'outval=c(1)*inval+c(2);more on,'];
valmodel=[valmodel 'for jj=1:length(inval),'];
valmodel=[valmodel 'disp([''At '' num2str(inval(jj)) '];
valmodel=[valmodel ''' the model value is '' num2str(outval(jj)) '' .'']),'];
valmodel=[valmodel 'end,pause(3),'];
valmodel=[valmodel 'more off,disp(s3),pause,set(gcf,''visible'',''on'')'];

%COLOR settings
bkgr='white'; %background color
%

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%THE GUI STARTS HERE
hfig=figure('units','normal','position',[0 0 1 1],'color',bkgr);
axis('off')

%Having done a graphics command the axes for that graphics screen have been
%given a handle. We label it basehndl.
basehndl=gca;

%vanity
axes(basehndl);
text(.55,-.07,'by D.R.Hill','color','black','fontsize',12,...
     'fontweight','bold','fontangle','oblique','erasemode','none')

%
%TITLE
%

titext1=text(-.15,1.05,header1,'color','m',...
            'fontsize',22,'fontweight','bold',...
            'erasemode','none');
titext2=text(-.15,.95,header2,'color','m',...
            'fontsize',22,'fontweight','bold',...
            'erasemode','none');

%
%START PUSH BUTTONS for Utility Functions + frame
%
utfrm=uicontrol('style','frame','units','normal',...
                 'position',[.02 .14 .34 .08],'backgroundcolor','y');
helph = uicontrol('style','push','units','normal','pos',[.03 .15 .1 .06], ...
        'string','Help','call',helps);
rstarth = uicontrol('style','push','units','normal','pos',[.14 .15 .1 .06], ...
        'string','Restart','call','close(gcf),lsqline');
endh = uicontrol('style','push','units','normal','pos',[.25 .15 .1 .06], ...
        'string','QUIT','call',done);

%
%RADIO button for deviation pictures + frame
%
rbutfrm=uicontrol('style','frame','units','normal',...
                 'position',[.02 .25 .37 .08],'backgroundcolor','c');

rbuton=uicontrol('style','radio','string','Deviations ON',...
                  'units','normal','position',[.03 .26 .17 .06],...                
                  'callback',['set(rbuton,''value'',1),'...
                  'set(rbutoff,''value'',0),clor=''m'';eval(drawit);']);
rbutoff=uicontrol('style','radio','string','Deviations OFF',...
                  'units','normal','position',[.21 .26 .17 .06],...
                  'value',1,...
                  'callback',['set(rbuton,''value'',0),'...
                  'set(rbutoff,''value'',1),clor=''w'';eval(drawit);']);

%
%Button for Error
%
errfrm=uicontrol('style','frame','units','normal',...
                 'position',[.02 .49 .32 .08],'backgroundcolor','r');
err = uicontrol('style','push','units','normal','pos',[.03 .50 .3 .06], ...
        'string','Sum of Squares of Deviations','call',disperr);

%
%Button for table display of data
%
seetab = uicontrol('style','push','units','normal','pos',[.03 .60 .2 .06], ...
        'string','Show Data Table','call',dispdata);

%
%Button for model evaluation
%
valbut = uicontrol('style','push','units','normal','pos',[.03 .70 .2 .06], ...
        'string','Evaluate the Model','call',valmodel);



%
%Button to refresh screen if graph gets screwed up.
%
if vers~='5'
rfbut=uicontrol('style','push','units','normal','pos',[.85 .1 .15 .06], ...
        'string','Redraw Graph','call','refresh(gcf)');
end

%establish graphics box
%

grbox=axes('position',[.4 .25 .59 .74]);

%plot x and y axes and sides of box
%9/3/97 omitted the axes
%plot([rval(1) rval(2)],[0 0],'-k',[0 0],[rval(1),rval(2)],'-k',...
%    'erasemode','none')
axis(rval);axis('square');axis(axis);
set(grbox,'xcolor',[0 0 0],'ycolor',[0 0 0]);
hold on;

plot(x,y,'*k','erasemode','none');

plot([xpl xpr],[yl yh],'-b','linewidth',2,'erasemode','none');
drawnow
eqn=[num2str(c(1)) '*x'];
if c(2)>0, eqn=[eqn ' + '];else, eqn=[eqn ' - '];end
eqn=[eqn num2str(abs(c(2)))];
xlabel(['Model Equation: ' eqn])
hold off;



