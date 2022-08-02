function uball3                                     % last updated 2/10/96
%UBALL3 Unit balls in 3-space for vector norms.
%  
%       A demonstration of the shape of the set of all vectors in 3-space
%       whose norm is less than or equal to 1. Input consists of the number
%       of trials and the norm to be used. For instance the 1, 2, 3, ...
%       norms. To use the infinity norm enter inf as the input for the norm. 
%       EXPERIMENT!
%
%       Use in the form  ==> uball3  <==
%
%
%  By: David R. Hill, Mathematics Dept, Temple University
%      Philadelphia, Pa. 19122
top='                    UNIT BALL DEMO in 3-SPACE';
intro=...
['A demonstration of the shape of the set of all vectors in 3-space   ';
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
   st=['UNIT BALL Demo in 3-space  norm = infinity'];
else
   st=['UNIT BALL Demo in 3-space  norm = ' num2str(m)];
end
figure,set(gcf,'units','normal','position',[0 0 1 1])
lim=[1 -1];z=[0 0];
plot3(lim,z,z,'b',z,lim,z,'b',z,z,lim,'b')
view(-30,5),axis(axis),hold on,grid,title(st),M=zeros(3,2);
for ii=1:n
    v=rand(3,1);t=fix(10*rand);s=fix(10*rand);r=fix(10*rand);
    v=v.*[(-1)^t (-1)^r (-1)^s]';v=v/norm(v,m);M(:,2)=v;
    plot3(M(1,:),M(2,:),M(3,:),'y','erasemode','none'),drawnow
end
plot3(lim,z,z,'b','erasemode','none'),plot3(z,lim,z,'b','erasemode','none')
plot3(z,z,lim,'b','erasemode','none'),plot3(0,0,0,'r+','erasemode','none')
plot3([-1 -1],[-1 -1],[1 -1],'--r','erasemode','none')
plot3([-1 -1],[1 -1],[1 1],'--r','erasemode','none')
plot3([-1 1],[-1 -1],[1 1],'--r','erasemode','none')
pause(2)
text(.6,.05,'Press ENTER to Continue.','erasemode','none',...
'units','normalized')
pause
hold off
close(gcf)
clc,disp('UBALL3 is over!')
