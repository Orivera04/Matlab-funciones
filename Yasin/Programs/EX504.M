% A program of type script
% Program name is ex504.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex504' in the command window.
%
%  A program for explaining the operation of the ' Switch ' statements.
%   
%  This prigram returns different values of b, depending on the value of   
 %  the input 'a'
%   The following statement asks you to input ' a '
a=input('What is the value of a ')
% 
switch a
case 1
    b=2
case 2
    b=5
case  3
    b=6
otherwise
    disp('not valid input ')
end
