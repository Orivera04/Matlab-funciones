% A program of type script
% Program name is ex503.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex503' in the command window.
%
%   A program for returning the grade as a function of the mark.
% 
%   The following statement asks you to input the mark
mark=input('What is the mark? ' ) ;
if mark>=90&mark<=100
    disp('grade = A')
elseif mark>=85&mark<90
    disp('grade = B+ ')
elseif mark>=80&mark<85
    disp('grade=B' )
elseif mark>=70&mark<80
    disp('grade=C+ ' )
elseif mark>=60&mark<70
    disp('grade = C' )
elseif mark>=55&mark<60
    disp('grade = D+ ') 
elseif mark>=50&mark<55
    disp('grade = D  ')
elseif mark>=0&mark<50
    disp('grade=F ')
else
   disp('not valid mark')
end
