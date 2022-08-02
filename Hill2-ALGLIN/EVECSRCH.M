function VEC = evecsrch(A)                       %last updated 3/28/00
%EVECSRCH  Searching for eigenvectors of a 2 by 2 real matrix A.
%          Vectors x around the unit circle are used as 
%          input to the function F(x) = A*x. If x and F(x)
%          are parallel their images are retained otherwise
%          both input & output are erased. The vectors x 
%          such that x and F(x) are parallel can be returned
%          to the user in matrix VEC. A randomly selected
%          vector is used to start the search.
%
%          If A has complex eigenvectors a message is displayed.
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
      if isempty(ch)==1
         ch=999;
      end   
      if ch==0,return,end
      if ch==3, clc,help evecsrch,disp(s0),disp(cont),pause,end
      if ch==2,A=[1 15;5 3];gdsw='Y';end
      if ch==1,disp(s0),disp(matenter),
         havmat='N';
         while havmat=='N'
            B = input('Your matrix ==>');
            if isempty(B)==1
               disp('No matrix entered. try again.')
               disp(cont)
               pause
            else
               havmat='Y';
            end
         end   
         [m,n]=size(B);
         if m~=2 | n~=2
            disp(badmat),disp('TRY AGAIN'),disp(cont),pause
         else
            A=B;gdsw='Y';
         end
      end
   end
end

%graph address
%grfad=[.4 .1 .65 .65];
spread=[-1 1 -1 1];

%DRAW CIRCLE
circ='plot(cx,cy,''-b'',''erasemode'',''none'',''linewidth'',3),drawnow;';

% Graph SET UP
pfig=['pgrf=plot(spread(1:2),[0 0],''-w'',[0 0],spread(3:4),''-w'');'];
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
hfig=figure('units','normal','position',[0 0 1 1]);
axis('off')

%the subplots
grafsub=subplot('position',[.4 .1 .65 .65]);%axis('off')
titlesub=subplot('position',[.3 .95 .4 .07]);axis('off')
infosub=subplot('position',[.05 .55 .2 .3]);axis('off')
vanitysub=subplot('position',[.8 .01 .1 .07]);axis('off')
evecsub=subplot('position',[.01 .15 .2 .3]);axis('off')
byesub=subplot('position',[.05 .01 .2 .1]);axis('off')


%Screen Title
subplot(titlesub);
text(0,0,header,'color','magenta','fontsize',24,...
    'fontweight','bold','erasemode','none')

%case information
subplot(infosub);
text(0,.9,'x = input','color','red','fontsize',22,...
    'fontweight','bold','erasemode','none')
text(0,.55,'A*x = output','color','black','fontsize',22,...
    'fontweight','bold','erasemode','none')
Amat=mat2strh(A,3);
text(.3,.3,Amat(1,:),'color','blue','fontsize',22,...
    'fontweight','bold','erasemode','none')
text(.3,.0,Amat(2,:),'color','blue','fontsize',22,...
    'fontweight','bold','erasemode','none')
text(0,.15,'A = ','color','blue','fontsize',24,...
    'fontweight','bold','erasemode','none')


%vanity
subplot(vanitysub);
text(0,.1,'by D.R.Hill','color','black','fontweight','bold',...
     'fontsize',12,'erasemode','none')

%SHOW GRAPHS
subplot(grafsub);
eval(pfig)
eval(circ)

%manual start of search
subplot(byesub);
strt=text(0,1,'Press ENTER to start search!','color','red',...
    'fontsize',14,'fontweight','bold');
drawnow
pause
delete(strt);

%BEGIN SEARCH
savevec=[];
ii=1;
%If A is the zero matrix, the unit circle is filled.
if sum(sum(abs(A)))==0,fill(cx,cy,'m'),ii=k+1;end
while ii<k
   x=[cx(ii);cy(ii)];
   xim=A*x;xim=xim/norm(xim);
   subplot(grafsub);
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
            if nk==1                       
               subplot(evecsub);            
               text(0,.9,'Eigenvectors:','color','black',...
                   'fontsize',16,...
                   'fontweight','bold','erasemode','none'),drawnow
            end
            matsav=mat2strh(truvec,4); %Using true eigenvectors here!
            subplot(evecsub)
            nk
            text((nk-1)*.7,.7,matsav(1,:),'color','magenta',...
                'fontsize',16,...
                'fontweight','bold','erasemode','none'),drawnow
            text((nk-1)*.7,.4,matsav(2,:),'color','magenta',...
                'fontsize',16,...
                'fontweight','bold','erasemode','none'),drawnow
         end
      %done with true vector & its display
  else
      set(invec,'color','white');set(outvec,'color','white');
      delete(invec);delete(outvec);
      [sm sn]=size(savevec);
      if sm>0
         subplot(grafsub);
         for jj=1:sm  %PLOTTING EIGENVECTORS ALREADY FOUND
           plot([0,savevec(jj,1)],[0,savevec(jj,2)],'-m',...
              'erasemode','none','linewidth',3) 
           drawnow
        end
      end
      ii=ii+1;
   end
   if 5*fix(ii/5)-ii==0,subplot(grafsub);eval(circ),end
end %of while
subplot(grafsub);
[sm sn]=size(savevec);
for jj=1:sm  %PLOTTING EIGENVECTORS ALREADY FOUND
    plot([0,savevec(jj,1)],[0,savevec(jj,2)],'-m',...
    'erasemode','none','linewidth',3) 
    drawnow
end
subplot(byesub);
bye=text(0,1,'Search is over!','color','blue',...
   'fontsize',16,'fontweight','bold','erasemode','none');drawnow
bye2=text(0,.5,'(Any nonzero scalar multiple of the vectors above is also an eigenvector.)','color','black',...
   'fontsize',12,'fontweight','bold','erasemode','none');drawnow
bye1=text(0,.1,cont,'color','blue',...
    'fontsize',16,'fontweight','bold','erasemode','none');drawnow
VEC=[v1 v2];
hold off
%pause
clc,disp(s0),disp('Eigenvector Search is over!')
