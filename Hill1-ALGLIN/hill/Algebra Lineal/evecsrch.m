function VEC = evecsrch(A)                       %last updated 4/9/95
%EVECSRCH  Searching for eigenvectors of a 2 by 2 real matrix A.
%          Vectors x around the unit circle are used as 
%          input to the function F(x) = A*x. If x and F(x)
%          are parallel their images are retained otherwise
%          both input & output are erased. The vectors x 
%          such that x and F(x) are parallel can be returned
%          to the user in matrix VEC. If A has complex 
%          eigenvectors a message is displayed.
%
%  Use in the form  
%  ==>  VEC = evecsrch(A)   or  evecsrch(A)  or  evecsrch  <==
%
%  In the latter form the user will be prompted for input. 
%  A demo is available in this mode.
%
%By: David R. Hill, Math. Dept., Temple University,
%    Philadelphia, Pa. 19122  Email: hill@math.temple.edu

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%Operational Notes:
%     1. If the input matrix is the zero matrix the unit circle is filled.
%     2. Routine mat2strh is used.
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

cont='Press ENTER to continue.';
s0=' ';
menu=['            OPTIONS                     ';
      '                                        ';
      ' 1. Enter a 2 by 2 matrix.              ';
      '                                        ';
      ' 2. See a built-in demonstration.       ';
      '                                        ';
      ' 3. View information about this routine.';
      '                                        ';
      ' 0. Quit.                               ';
      '                                        '];
choice='Type your choice ==>  ';
matenter='Enter your 2 by 2 matrix in the form [a b;c d]';
badmat='Matrix must be 2 by 2.';
header1='A Search for EIGENVECTORS.';
header='EIGENVECTOR Search';
bkgr='white';

if nargin~=1
   gdsw='N';
   while gdsw=='N'
      clc,disp(s0),disp(header1),disp(s0),disp(s0),disp(menu)
      ch=input(choice);
      if ch==0,return,end
      if ch==3, clc,help evecsrch,disp(s0),disp(cont),pause,end
      if ch==2,A=[1 15;5 3];gdsw='Y';end
      if ch==1,disp(s0),disp(matenter),B = input('Your matrix ==>');
         [m,n]=size(B);
         if m~=2 | n~=2
            disp(badmat),disp('TRY AGAIN'),disp(cont),pause
         end
         A=B;gdsw='Y';
      end
   end
end

%graph address
grfad=[.4 .1 .65 .65];
spread=[-1 1 -1 1];

%DRAW CIRCLE
circ='plot(cx,cy,''-b'',''erasemode'',''none'',''linewidth'',3),drawnow;';

% Graph SET UP
pfig='pgrf=axes(''position'',grfad);';
pfig=[pfig 'plot(spread(1:2),[0 0],''-w'',[0 0],spread(3:4),''-w'');'];
pfig=[pfig 'set(pgrf,''xcolor'',[0 0 0],''ycolor'',[0 0 0]);'];
pfig=[pfig 'set(pgrf,''linewidth'',2);'];
pfig=[pfig 'axis(spread);axis(''square'');axis(axis);'];
pfig=[pfig 'hold on;'];

% GET the eigenvectors
[v d]=eig(A);

%check complex
if abs(imag(d(1,1)))>10*eps | abs(imag(d(2,2)))>10*eps
   clc
   disp('Complex eigenvalues.')
   disp('Search for eigenvectors can not be done in the real plane.')
   disp('Routine is over!')
   return
end

%compute angle of eigenvectors make with x-axis
v1=v(:,1);v2=v(:,2);start=[1 0]';


%Set parameters.
mytol=.5e-3;
step=.02;
t=0:step:2*pi; 
t=t+fix(10*rand)*pi/7; % randomize the starting point
k=length(t);%number of vector searched
cx=cos(t);cy=sin(t);

%insert exact eigenvectors into the 'search'

uvec=[cx;cy];
for js=1:k
    v1s(js)=norm(uvec(:,js)-v1);v2s(js)=norm(uvec(:,js)-v2);
    v1sn(js)=norm(uvec(:,js)+v1);v2sn(js)=norm(uvec(:,js)+v2);
end

[m1 i1]=min(v1s);
[m2 i2]=min(v2s);
[m3 i3]=min(v1sn);
[m4 i4]=min(v2sn);

cx(i1)=v1(1); 
cx(i2)=v2(1); 
cx(i3)=-v1(1); 
cx(i4)=-v2(1); 

%DOING the figure
%
hfig=figure('units','normal','position',[0 0 1 1],'color',bkgr);
axis('off')


%Having done a graphics command the axes for that graphics screen have been
%given a handle. We label it basehndl.
basehndl=gca;

%Screen Title
axes(basehndl);
text(.3,1.05,header,'color','green','fontsize',24,...
    'fontweight','bold','erasemode','none')
text(-.1,.9,'x = input','color','red','fontsize',22,...
    'fontweight','bold','erasemode','none')
text(-.1,.75,'A*x = output','color','black','fontsize',22,...
    'fontweight','bold','erasemode','none')
Amat=mat2strh(A,3);
text(.0,.6,Amat(1,:),'color','blue','fontsize',22,...
    'fontweight','bold','erasemode','none')
text(.0,.5,Amat(2,:),'color','blue','fontsize',22,...
    'fontweight','bold','erasemode','none')
text(-.08,.55,'A = ','color','blue','fontsize',24,...
    'fontweight','bold','erasemode','none')

%vanity
text(.8,-.1,'by D.R.Hill','color','black','fontweight','bold',...
     'fontsize',12,'erasemode','none')

%SHOW GRAPHS
eval(pfig)
eval(circ)

%BEGIN SEARCH
savevec=[];
ii=1;
%If A is the zero matrix, the unit circle is filled.
if sum(sum(abs(A)))==0,fill(cx,cy,'m'),ii=k+1;end
while ii<k
   x=[cx(ii);cy(ii)];
   xim=A*x;xim=xim/norm(xim);
   axes(pgrf);
   invec=plot([0,x(1)],[0,x(2)],'-r','erasemode','none','linewidth',3);
   drawnow
   outvec=plot([0,xim(1)],[0 xim(2)],'-k','erasemode','none','linewidth',3);
   drawnow
   ctheta=dot(x,xim);
   if ii==i1 | ii==i2 |ii==i3 | ii==i4                 
      %FINDING AN EIGENVECTOR
           
      set(invec,'color','white');set(outvec,'color','white');
      delete(invec);delete(outvec);  %getting rid approximants
            
      if ii==i1,truvec=v1;end    %setting up true vectors
      if ii==i2,truvec=v2;end
      if ii==i3,truvec=-v1;end
      if ii==i4,truvec=-v2;end
      x=truvec;
      ii=ii+2; %to leave the area once we get a hit
      savevec=[savevec; x'];sv=savevec'; %arranging saved vectors into cols
      [mk nk]=size(sv);
      
      %drawing the true vector
         plot(x(1),x(2),'*m','erasemode','none','linewidth',3)
         drawnow
         plot([0,x(1)],[0,x(2)],'-m','erasemode','none','linewidth',3)
         drawnow
         if nk <= 2
            set(basehndl,'visible','on'); % <======== WHY????????
            if nk==1                      % do I need this???
               axes(basehndl)             % without it things do not show up
               text(-.1,.4,'The Eigenvectors:','color','black',...
                   'fontsize',16,...
                   'fontweight','bold','erasemode','none'),drawnow
            end
            matsav=mat2strh(truvec,4); %Using true eigenvectors here!
            axes(basehndl);
            text(-.1+(nk-1)*.2,.3,matsav(1,:),'color','magenta',...
                'fontsize',16,...
                'fontweight','bold','erasemode','none'),drawnow
            text(-.1+(nk-1)*.2,.2,matsav(2,:),'color','magenta',...
                'fontsize',16,...
                'fontweight','bold','erasemode','none'),drawnow
         end
      %done with true vector & its display
  else
      set(invec,'color','white');set(outvec,'color','white');
      delete(invec);delete(outvec);
      [sm sn]=size(savevec);
      if sm>0
         axes(pgrf);
         for jj=1:sm  %PLOTTING EIGENVECTORS ALREADY FOUND
           plot([0,savevec(jj,1)],[0,savevec(jj,2)],'-m',...
              'erasemode','none','linewidth',3) 
           drawnow
        end
      end
      ii=ii+1;
   end
   if 5*fix(ii/5)-ii==0,axes(pgrf);eval(circ),end
end %of while
axes(pgrf);
[sm sn]=size(savevec);
for jj=1:sm  %PLOTTING EIGENVECTORS ALREADY FOUND
    plot([0,savevec(jj,1)],[0,savevec(jj,2)],'-m',...
    'erasemode','none','linewidth',3) 
    drawnow
end
axes(basehndl)
bye=text(-.1,.1,'Search is over!','color','blue',...
    'fontsize',16,'fontweight','bold','erasemode','none');drawnow
bye1=text(-.1,0,cont,'color','blue',...
    'fontsize',16,'fontweight','bold','erasemode','none');drawnow
VEC=[v1 v2];
hold off
%pause
clc,disp(s0),disp('Eigenvector Search is over!')