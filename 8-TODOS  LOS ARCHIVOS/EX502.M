% A program of type script
% Program name is ex502.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex502' in the command window.
%
% This program explains the operation of the ' if ' statements.
% This program returns different values of 'b', depending on the   
% sign of the input 'a'
%
%   the following statement asks you to input ' a '
 a=input('What is the value of  a?  ');
 if a>0
    b=1
elseif a<0
    b=2
else
    b=0
end
