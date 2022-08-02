% A program of type script
% Program name is ex505.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex505' in the command window.
%
%  A program for calculating the value of the current in a switchable circuit
%  This prigram returns the value of the current ' I ' , depending on the
% position of the switch S.
V=12;
% The following statement asks you to input the position of the switch ' S '
S=input('What is the the position of the switch ? ');
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
otherwise
    disp('Not Valid Switch position ')
end
I= V/R
