function tab=lpstep(A)                            %last updated 5/3/96
%LPSTEP    A step-by-step solver for small standard linear programming
%          problems. At each stage you are asked to determine the pivot.
%          Incorrect responses initiate a set of questions to aid in
%          pivot selection. The screens reflect the problem form
%          developed in Introductory Linear Algebra with Applications by
%          B. Kolman.
%
%          This routine solves the standard linear programming problem
%          using the Simplex Method with slack variables.  To form the
%          initial tableau A the coefficients of the constraints are
%          entered into the rows where the equations are of the form
%                 a1x1 + a2X2 + a3X3 + ... + anXn = Cm
%          and the bottom row consists of the objective function written
%          in the form
%                 z1X1 + z2X2 + z3X3 + ... + znXn = 0.
%          Then, as long as there is at least one negative entry in the
%          last row, LPSTEP will find an optimal solution. If the
%          tableau A is not supplied as an argument, the user will be
%          prompted to enter it or may select a demo. 
%          
%          Recommendation: Set the screen font to a fixed width font
%                          so columns will align well.
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
%          Use in the form   ==>  lpstep(A) or lpstep  <==
%
%  By: David R. Hill, MATH Department, Temple University
%      Philadelphia, Pa., 19122        Email: hill@math.temple.edu
%      aided by Lisa Deckter, TEMPLE UNIVERSITY
clc
thead=['          SIMPLEX METHOD FOR LINEAR PROGRAMMING'];
ret='Press enter to continue.';
s3='Press enter to go on.';
s1=['Enter your initial tableau as a matrix entry by entry,';
    'included between brackets [...]                       '];
s0=' ';
arrow='--> ';
sp2='  ';
ksp=3; %this set the spacing between columns for use in mat2strh.m
y='y';Y='Y';n='n';N='N'; 
directions=['   Do you want directions? (Y/N)';
            '                                '];
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
%START
if nargin ~= 1
   gdchoice='N';
   while gdchoice=='N'
     clc,disp(thead)
      disp(s0),disp(chmenu),disp(s0)
      ch=input('Enter your choice ==> ');
      if ch==1
         disp(sp2),disp(sp2)
         gdans='N';
         while gdans=='N'
            disp(directions),answer=input(arrow);
            if answer==N | answer==n | answer==Y | answer==y
               gdans='Y';
            end
         end %while
         if answer==Y | answer==y
            help lpstep
            disp(ret),pause
            clc,disp(thead),disp(s0)
         end
         disp(s1);
         %disp('Enter the initial tableau matrix:')
         A=input('==> ');
         gdchoice='Y';
      end
      if ch==0, return,end
      if ch==2
         A = [2 1 1 0 0 50;1 2 0 1 0 70;-8 -10 0 0 1 0];
         gdchoice='Y';
         clc
         disp(demo1),disp(demo2),disp(s3),pause
         disp(demo3)
         disp('Press enter to begin solution of this example.'),pause
      end
   end %of while
end
matrix = A;

for i=1:20,for j=1:25,spaces(i,j)=' ';end,end  %set up blanks

%if nargin==0
%   type_input='true ';
%else
%   type_input='false';   
%end
%clc,disp(thead),disp(sp2)
%if type_input=='true '
%   s1=['Enter your initial tableau as a matrix entry by entry,';
%       'included between brackets [...]                       '];
%   disp(s1),disp(sp2)
%   matrix=input(arrow);disp(sp2),disp('*** WAIT: processing. ***')
%   pause(2)
%else
%   matrix = A;
%end
[m,ns]=size(matrix);tab=matrix;
% Head the columns with variable names
for a=1:ns-1
   top(a)=a;
end
% Set up labels for initial basic variables
for j=1:m-1
   side(m-j)=(ns-2)-(j-1);
end
%set up labels for columns of tableau
vlabel=[];
for i=1:ns-2
   if i <= 9
      vlabel(i,:)=[' x' int2str(i)];
   else
      vlabel(i,:)=['x' int2str(i)];
   end  %assumes fewer than 99 variables
end
      dismat=mat2strh(matrix,ksp);
      sz=(length(dismat(1,:))-ns*ksp)/ns; %size of an entry in dismat
      toplabel=[]; %build label for top of tableau
      for i = 1:ns-2
         toplabel=[toplabel blanks(ksp+sz-3) vlabel(i,:)];
      end
      toplabel=[toplabel blanks(ksp+sz-3) '  z' blanks(ksp+sz)];
      %toplabel contains a string for labeling the columns of the tableau
      dismat=[toplabel;dismat]; %attach toplabels
      clc,disp(thead),disp(sp2)
      disp('The INITIAL tableau is:'),disp(sp2)
      disp(dismat),disp(sp2)
first_pass='true ';
% Dummy while loop
loop='never_end';
while loop=='never_end'
   % Find the most negative entry in the objective row and its
   % location
   negcol=1;
   negob=matrix(m,1);
   for i=2:ns-2
      if matrix(m,i)<negob 
         negob=matrix(m,i);
         negcol=i;
      end
   end
   if first_pass=='true '
      disp(sp2),disp(ret),pause
      bvar=[]; %generate labels of basic variables
      for j=1:m-1
         if side(j) <= 9
            bvar(j,:)=[' x' int2str(side(j))];
         else
            bvar(j,:)=['x' int2str(side(j))];
         end
      end 
      dismat1=[]; %attach basic variable labels
      dismat1(1,:)=[blanks(5) dismat(1,:)];
      for j=2:m
         dismat1(j,:)=[bvar(j-1,:) blanks(2) dismat(j,:)];
      end
      dismat1(m+1,:)=[blanks(5) dismat(m+1,:)];
      dismat=dismat1;
      clc,disp(thead),disp(sp2)
      disp('The initial tableau with the BASIC VARIABLES labeled is:')
      disp(dismat),disp(sp2)
   end
      first_pass='false';
      disp('The current solution is:')
      for j=2:m
         disp([bvar(j-1,:) ' = ' num2str(matrix(j-1,ns))])
      end
      disp(['with z = ' num2str(matrix(m,ns))])
      gdch='N';
      while gdch=='N'
         disp('Is this an optimal solution?  (Y/N)')
         ch=input(arrow);
         if ch==N | ch==n | ch==Y | ch==y
            gdch='Y';
         end
      end %while   
      if negob>=0
         if (ch==y | ch==Y)
            disp('CORRECT.'),pause(2)
         else
            disp('INCORRECT.')
            disp('The objective row has no negative entries.'),pause(2)
         end
         disp('Press enter to see the final tableau and the solution.') 
         pause
         disp(dismat),disp(sp2),tab=matrix;
         for c=1:m-1
            s3=['x' int2str(side(c)) ' = ' num2str(matrix(c,ns))];
            disp(s3)
         end
         s4=['The optimal value of z is ' num2str(matrix(m,ns))];
         disp(s4),disp(sp2)
         disp('All other variables = 0')
         disp(sp2),disp(sp2),disp('The routine is over.')
         return %to keyboard
      else
         if (ch==y | ch==Y)
            disp('INCORRECT.')
            disp('There are negative entries in the objective row.')
            pause(2)
         else
            disp('CORRECT.'),pause(2)
         end
         disp(ret),pause
      end
   % Test for nonneg. entries in piv. col. above the object. row
   neg_ent_fnd='false';
   for j=1:m-1
      if matrix(j,negcol)>0
         neg_ent_fnd='true ';
      end
   end
   if neg_ent_fnd=='false'
      disp('The problem has no finite optimum.');
      return
   end
  % Find the theta ratios
   for j=1:m-1
      if matrix(j,negcol)>0
         theta(j)=matrix(j,ns)/matrix(j,negcol);
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
   newside=side;
   newside(smallestrow)=negcol; %determmine new basic variable
   % Find the pivot
   pivot=matrix(smallestrow,negcol);
   % See if student can figure out the pivot value himself
   if first_pass=='false'
      clc,disp(thead),disp('The tableau is:'),disp(dismat),disp(sp2)
   end
   stch='Enter your choice for the pivot value; either the exact';
   stch=[stch ' numerical value or '];
   stch1=['                      matrix(i,j)                      ';
          'where i = row number and j = column number.            '];
   disp(stch),disp(stch1)
   stu_pivot=input(arrow);
   if stu_pivot==pivot
      disp('That is correct.'),pause(2)
   else
      s8=['That is incorrect. Use the following steps to find the pivot.'];
      disp(s8),disp(sp2),disp(ret),pause
      clc,disp(thead),disp(sp2),disp(dismat),disp(sp2)
      s8a='Enter the number of the column that is most negative in the ';
      s8a=[s8a 'objective row.'];
      disp(s8a)
      stu_negcol=input(arrow);
      if stu_negcol==negcol
         disp('That is correct.'),pause(2)
      else
         s9=['That is incorrect.  The correct value is:   '];
         s9=[s9  num2str(negcol)];
         disp(s9),disp(sp2),pause(2)
      end
      disp('The theta ratios are:')
      %Setting up table of theta ratios to display.
      cnt=[1:m-1];tshow=spaces;
      for j=1:m-1,temp=[int2str(cnt(j)) '    ' num2str(theta(j))];
         tshow(j,1:length(temp))=temp;
      end
      disp(tshow(1:m-1,:)),disp(sp2)
      s5=['Enter the number of the smallest positive theta ratio.'];
      disp(s5)
      stu_smallesttheta=input(arrow);
      while fix(abs(stu_smallesttheta))~=stu_smallesttheta | ...
            stu_smallesttheta > m-1 | stu_smallesttheta == 0
         disp(['Choice must be between 1 and ' int2str(m-1) '.'])
         disp(sp2),disp('The theta ratios are:'),disp(sp2)
         disp(tshow(1:m-1,:)),disp(sp2)
         stu_smallesttheta=input('TRY AGAIN!');
      end
      if theta(stu_smallesttheta)==smallesttheta
         disp('That is correct.'),pause(2)
      else
         s6=['That is incorrect.  The correct value '];
         s6=[s6 'is ' num2str(smallesttheta)];
         disp(s6),disp(sp2),pause(2)
      end
      disp(['Thus the pivot is ' num2str(pivot)]),disp(sp2),disp(ret)
      pause,disp(sp2)
   end
   disp('Performing "pivotal eliminations".'),disp(sp2)
   disp('Calculating!'),disp(sp2),pause(2)
   % Perform pivotal eliminations 
   matrix(smallestrow,:)=matrix(smallestrow,:)/pivot;
   for jj=1:m
      if jj~=smallestrow
         entry=matrix(jj,negcol);
         matrix(jj,:)=-entry*matrix(smallestrow,:)+matrix(jj,:);
         matrix(jj,negcol)=0;
      end
   end
   side=newside; %label new basic variables
   % Set up labeling-- this takes a while
   disp('Setting up row and column labels *** Please wait!'),pause(2)
   dismat=mat2strh(matrix,ksp);
   sz=(length(dismat(1,:))-ns*ksp)/ns; %size of an entry is dismat
   toplabel=[]; %build label for top of tableau
   for i = 1:ns-2
      toplabel=[toplabel blanks(ksp+sz-3) vlabel(i,:)];
   end
   toplabel=[toplabel blanks(ksp+sz-3) '  z' blanks(ksp+sz)];
   %toplabel contains a string for labeling the columns of the tableau
   dismat=[toplabel;dismat]; %attach toplabels
   bvar=[]; %generate labels of basic variables
   for j=1:m-1
      if side(j) <= 9
         bvar(j,:)=[' x' int2str(side(j))];
      else
         bvar(j,:)=['x' int2str(side(j))];
      end
   end
   dismat1=[]; %attach basic variable labels
   dismat1(1,:)=[blanks(5) dismat(1,:)];
   for j=2:m
      dismat1(j,:)=[bvar(j-1,:) blanks(2) dismat(j,:)];
   end
   dismat1(m+1,:)=[blanks(5) dismat(m+1,:)];
   dismat=dismat1;
   clc,disp(thead),disp(sp2)
   s10=['The tableau is:'];disp(sp2)
   disp(s10),disp(sp2)
   disp(dismat),disp(sp2) %display tableau
end

