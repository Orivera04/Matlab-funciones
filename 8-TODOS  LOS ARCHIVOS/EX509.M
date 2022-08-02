% A program of type script
% Program name is ex509.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex509' in the command window.

S=input('what is the position of the switch  ');
if S==0
     R=inf;
 elseif S==1
     R= 40;
 elseif S==2
     R=30;
 elseif S==3
     R=20;
 elseif S==4
     R=10;
 elseif S==5
     R=0;
 else
     disp('Not Valid Position')
     break
 end
 C=12/R
