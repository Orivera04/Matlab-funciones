function uball                                       %last updated 1/22/94
%UBALL  Unit balls in 2-space or 3-space for vector norms.
%  
%       A demonstration of the shape of the set of all vectors in 2-space
%       or 3-space whose norm is less than or equal to 1. Input consists of
%       selecting 2-space or 3-space, the number of trials, and the norm
%       to be used. For instance the 1, 2, 3, ... norms. To use the infinity
%       norm enter inf as the input for the norm.
%       EXPERIMENT!
%
%       Use in the form  ==> uball  <==
%
%       Requires uball2 and uball3 m-files.
%
%  By: David R. Hill, Mathematics Dept, Temple University
%      Philadelphia, Pa. 19122
s0=' ';
sig='N';
while sig=='N'
   clc
   disp(s0),disp(s0)
   disp('              Demonstration of the Shape of Unit Balls')
   disp(s0),disp(s0),disp(s0)
   disp('   Select 2-space or 3-space for this demonstration.')
   k=input('    ===>  dimension =  ');
   if k==2 | k==3
      sig='Y';
   else
      disp('Only 2-space or 3-space is available. -- Try again.')
      disp('Press ENTER.'),pause
   end
end
if k==2
   uball2
else
   uball3
end


