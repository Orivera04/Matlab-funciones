function uball2                                       %last updated 2/10/96
%UBALL2  Unit balls in 2-space for vector norms.
%  
%       A demonstration of the shape of the set of all vectors in two-space
%       whose norm is less than or equal to 1. Input consists of the number
%       of trials and the norm to be used. For instance the 1, 2, 3, ...
%       norms. To use the infinity norm enter inf as the input for the norm. 
%       EXPERIMENT!
%
%       Use in the form  ==> uball2  <==
%
%
%  By: David R. Hill, Mathematics Dept, Temple University
%      Philadelphia, Pa. 19122
top='                    UNIT BALL DEMO in 2-space';
intro=...
['A demonstration of the shape of the set of all vectors in two-space ';
 'whose norm is less than or equal to 1. Input consists of the number ';
 'of trials and the norm to be used. For instance the 1, 2, 3, ...    ';
 'norms. To use the infinity norm enter inf as the input for the norm.'; 
 'EXPERIMENT!                                                         '];
s0='  ';
s1='  Press ENTER to continue.  ';
s2='Norm must be selected positive! Try again.';
m=-1;
while m<=0
   clc,disp(s0),disp(top),disp(s0),disp(intro),disp(s0)
   m=input('Norm = ');disp(s0)
   if m<=0,disp(s2),disp(s1),pause,end  %forcing norm to be positive
end
n=input('Number of trials = ');disp(s0),n=abs(n);
k=1;
if m==inf
   st=['UNIT BALL Demo  norm = infinity'];
else
   st=['UNIT BALL Demo  norm = ' num2str(m)];
end
   %Create new figure and set its position & size
wsize=2; %size for graph
figure,set(gcf,'units','normal','position',[0 0 1 1])
plot([-wsize wsize],[0 0],'w-',[0 0],[-wsize wsize],'w-')
axis(axis),axis('square'),hold on,title(st)
while k<=n
  x=rand(1,2);t=fix(10*rand);s=fix(10*rand);
  x(1)=((-1)^t)*x(1);x(2)=((-1)^s)*x(2);
  x=x/norm(x,m);
  plot([0 x(1)],[0 x(2)],'-m','erasemode','none'),drawnow
  k=k+1;
end
pause(2)
q=text(-1.8,-1.5,'Press ENTER to Continue.',...
'erasemode','none');
pause
hold off
close(gcf)
clc,disp('UBALL2 is over!')
