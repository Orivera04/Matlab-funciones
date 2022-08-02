% A program of type script
% Program name is ex506.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex506' in the command window.
%
%   A program for calculating the value of the current in a switchable   
%  circuit, with improvement by "break" statement.
%   This prigram returns the value of the current ' I ' , depending on the  
 %  position of the switch S.
%
V=12;
%
%  the following statement asks you to input the position of the switch ' S '
S=input('What is the the position of the switch');
switch S
case 0
    R=inf
case 1
    R=40
case  2
    R=30
case 3
    R=20
case 4
    R=10
case 5
    R=0
    disp('Short circuit, Fuse will blow ')
    break
otherwise
    disp('Not Valid Switch position' )
    break
end
I= V/R


