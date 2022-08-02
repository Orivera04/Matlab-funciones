function linprog(A)                  %<<last updated  5/3/96>>
%LINPROG   Directly solves the standard linear programming problem using
%          slack variables as formulated in Introductory Linear Algebra
%          with Applications by B. Kolman. This routine is only designed
%          for small problems.
%
%          To form the initial tableau A the coefficients of the
%          constraints are entered into the rows where the equations
%          are of the form:
%                 a1x1 + a2X2 + a3X3 + ... + anXn = Cm
%          and the bottom row consists of the objective function
%          written in the form:
%                 z1X1 + z2X2 + z3X3 + ... + znXn = 0
%          Then, as long as there is at least one negative entry
%          in the last row, linprog will find the optimal
%          solution. If no argument containing the initial tableau is
%          present, the user will be prompted to enter it
%          or may select a demo. 
%
%          Recommendation: Set the screen font to a fixed width font
%                          so columns will align well.
%
%          <<requires utility mat2strh.m>>
%
%          Example:  Maximize z=8*x1 + 10*x2 
%                    subject to the restrictions    2*x1 +   x2 <= 50
%                                                     x1 + 2*x2 <= 70
%                                                     x1 >= 0, x2 >= 0
%          Introducing slack variables x3 and x4 we restate the problem.
%                    Maximize z = 8*x1 + 10*x2
%                    subject to the restrictions
%                    2*x1 +   x2 + x3      = 50
%                      x1 + 2*x2 +    + x4 = 70
%                      x1, x2, x3, x4 all >= 0
%          Forming the initial tableau with the objective row last we have
%                      x1   x2   x3   x4   z
%                      2    1    1    0    0   50
%                      1    2    0    1    0   70
%                     -8  -10    0    0    1    0
%          The preceding 3 by 6 matrix would be entered into the routine.
%
%
%  By: David R. Hill, MATH Department, Temple University
%      Philadelphia, Pa., 19122        Email: hill@math.temple.edu
%
%  Use in the form  ==> linprog(A)  or linprog  <==
s0=' ';
s1='<><><><><><>  THE SOLUTION  <><><><><><>';
s2=['Your matrix is: '];
s3='Press enter to go on.';

head=[blanks(15) 'SIMPLEX METHOD FOR LINEAR PROGRAMMING'];
menu=['Options:                       ';
      '          1  See final tableau.';
      '                               ';
      '          0  QUIT.             '];
chmenu=['Options:                          ';
        '         1. Enter initial tableau.';
        '                                  ';
        '         2. Use demo example.     ';
        '                                  ';
        '         0. QUIT.                 '];
demo1=['               Linear Programming Example';
       '                                         '];
demo2=['  Example:  Maximize z=8*x1 + 10*x2                            ';
       '            subject to the restrictions   2*x1 +   x2 <= 50    ';
       '                                            x1 + 2*x2 <= 70    ';
       '                                            x1 >= 0, x2 >= 0   ';
       '  Introducing slack variables x3 and x4 we restate the problem.';
       '            Maximize z = 8*x1 + 10*x2                          ';
       '            subject to the restrictions                        ';
       '            2*x1 +   x2 + x3      = 50                         ';
       '              x1 + 2*x2 +    + x4 = 70                         ';
       '              x1, x2, x3, x4 all >= 0                          '];
demo3=['  Forming the initial tableau with the objective row last we have';
       '                                                                 ';
       '               x1   x2   x3   x4  z                              ';
       '               2    1    1    0   0   50                         ';
       '               1    2    0    1   0   70                         ';
       '              -8  -10    0    0   1    0                         ';
       '                                                                 ';
       '  The preceding 3 by 6 matrix would be entered into the routine. '];

if nargin ~= 1
   gdchoice='N';
   while gdchoice=='N'
     clc,disp(head)
      disp(' '),disp(chmenu),disp(s0)
      ch=input('Enter your choice ==> ');
      if ch==1
         disp('Enter the initial tableau matrix:')
         A=input('==> ');
         gdchoice='Y';
      end
      if ch==0, return,end
      if ch==2
         A = [2 1 1 0 0 50;1 2 0 1 0 70;-8 -10 0 0 1 0];
         gdchoice='Y';
         clc
         disp(demo1),disp(demo2),disp(s3),pause
         disp(demo3),disp('Press enter to solve this example.'),pause
      end
   end %of while
end
matrix=A;
clc,disp(head),disp(s0),disp(s2),matrix
[m,n]=size(matrix);
% Head the columns with variable names
for a=1:n-1
   top(a)=a;
end
% Put the basic variables next to the rows
for j=1:m-1
   side(m-j)=(n-2)-(j-1);
end
first_pass='true ';
% Dummy while loop
loop='never_end';
while loop=='never_end'
   % Find the most negative entry in the objective row and its
   %   dimension
   negcol=1;
   negob=matrix(m,1);
   for i=2:n-2
      if matrix(m,i)<negob 
         negob=matrix(m,i);
         negcol=i;
      end
   end
   %  Are we done processing the matrix?
   if negob>=0
      % Is there an optimal solution?
      if first_pass=='true '
         disp('There is no negative entry in the objective row.')
         disp('This routine is over.')
         return
      end
      disp(s0),disp(s1),disp(s0)
      for c=1:m-1
         s3=['X' int2str(side(c)) ' = ' num2str(matrix(c,n))];
         disp(s3)
      end
      disp('All other variables = 0')
      s4=['The optimal value of z is ' num2str(matrix(m,n))];
      disp(s4),disp(s0)
      disp(menu),disp(s0),option=input('--> ');
      if option==1
         disp(s0),disp(matrix)
      end
      disp('Routine is over!'),return
   end
   % Test for nonneg. entries in piv. col. above the object. row
   neg_ent_fnd='false';
   for j=1:m-1
      if matrix(j,negcol)>0
         neg_ent_fnd='true ';
      end
   end
   if neg_ent_fnd=='false'
      disp('The problem has no finite optimum');
      return
   end
  % Find the theta ratios
   for j=1:m-1
      if matrix(j,negcol)>0
         theta(j)=matrix(j,n)/matrix(j,negcol);
      else
         theta(j)=0;
      end
   end
   % Find first positive theta ratio
   pos_theta_found='false';
   k=1;
   while pos_theta_found=='false'
      if theta(k)>0
         pos_theta_found='true ';
         smallesttheta=theta(1);
         smallestrow=k;
      end
      k=k+1;
   end
   % Find the smallest theta ratio that is greater than zero
   for ii=2:m-1
      if theta(ii)>0
         if theta(ii)<smallesttheta
            smallesttheta=theta(ii);
            smallestrow=ii;
         end
      end
   end
   side(smallestrow)=negcol;
   % Find the pivot
   pivot=matrix(smallestrow,negcol);
   % Perform pivotal eliminations 
   matrix(smallestrow,:)=matrix(smallestrow,:)/pivot;
   for jj=1:m
      if jj~=smallestrow
         entry=matrix(jj,negcol);
         matrix(jj,:)=-entry*matrix(smallestrow,:)+matrix(jj,:);
         matrix(jj,negcol)=0;
      end
   end
   first_pass='false';
end
