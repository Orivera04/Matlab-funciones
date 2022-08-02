function A = rrefstep(A)                      %last updated 1/21/94
%RREFSTEP Reduced row echelon form of matrix A is computed step-by-step.
%         At each step a message is displayed which describes the action
%         to be taken. You may either perform the action and see the result
%         or request an explanation of why the action is to be taken.
%         This routine is for small matrices and is to be used for 
%         developing skills in obtaining the reduced row echelon form
%         of a matrix. Rational or real display format can be chosen.
%
%         Use in the form  ===>   rrefstep(A)      <===
%
%         See also rref and reduce.
%   By: David R. Hill
%       Math. Dept., Temple University, Philadelphia, Pa. 19122 

switch=0;         %setting print switch for real display initially
%set up string messages
s0=' ';
s1='      <><><><> Reduced Row Echelon Form STEP-BY-STEP <><><><>';
s2='Your original matrix is:';
s3='The current matrix is:';
s4='Operation performed: ';
s5=...
['  1. PERFORM this step.                     <3> Turn on rational display. ';
 '  2. EXPLAIN this step then PERFORM it.     <4> Turn off rational display.';
 '                                                                          ';
 '  0. Quit                                                                 '];
s6='Press enter to begin ROW REDUCTION  ';
s7='Resulting matrix is:';
s8='     Your choice ==>  ';
s9='  Press Enter to continue  ';
s10='Improper choice-- try again.';
s11='  Press Enter to continue the ROW REDUCTION  ';
unlin='____________________________________________________________________';
unlin=[unlin '____________________________________'];
      %defining underline
[m,n] = size(A);

% Compute the default tolerance if none was provided.
tol = max([m,n])*eps*norm(A,'inf');

%introduction
clc,disp(s1),disp(s0),disp(s2),
if (switch),format rational,disp(A),format,else,disp(A),end
disp(s0),disp(s6),pause,clc

% Loop over the entire matrix.
i = 1;j = 1;k = 0;
while (i <= m) & (j <= n)
   %set up screen
   clc,disp(s1),disp(s0),disp(s3)
   if (switch),format rational,disp(A),format,else,disp(A),end
   disp(s0)

   % Find value and index of largest element in the remainder of column j.
   [p,k] = max(abs(A(i:m,j))); k = k+i-1;
   if (p <= tol)
      % The column is negligible, zero it out.
     mess=['Column ' int2str(j) ' is negligible, no pivot can found.'];
     if i>1
        mess=['Column ' int2str(j) ' is negligible below row ' int2str(i-1)];
        mess=[mess '; no pivot can found.'];
     end
     A(i:m,j) = zeros(m-i+1,1);
     disp(mess),disp(unlin(1:length(mess))),disp(s0),disp(s9),pause
     j = j + 1;
  else
      if A(i,j)==1
         sig='N';
         while sig=='N'
         mess=['Use row ' int2str(i) ' as the pivot row.'];
         disp(mess),disp(unlin(1:length(mess))),disp(s0),disp(s5)
         ch=input(s8);
         if ch==0, return,end
         if ch==3,switch=1;end
         if ch==4,switch=0;end
         if ch==2
            ex=['EXPLANATION: Since A(' num2str(i) ',' num2str(j) ') = 1']; 
            ex=[ex ' we use row ' num2str(i) ' as the pivot row.'];
            disp(ex),disp(s0),disp(s9),pause,ch=1;
         end
         if ch==1,sig='Y';end
         if (ch~=1 & ch~=2 & ch~=3 & ch~=4)
            disp(s10),disp(s0),disp(s9),pause
         end
         clc,disp(s1),disp(s0),disp(s3)
         if (switch),format rational,disp(A),format,else,disp(A),end
         disp(s0)        
         end %while not a proper choice or chose explain; ie sig='N'
      elseif abs(A(i,j))>tol
         sig='N';
         while sig=='N'
         mess=['Use row ' int2str(i) ' as the pivot row.'];
         mess1=['We do a row operation to get a 1 into the '];
         mess1=[mess1 '(' int2str(i) ',' int2str(j) ') position.'];
         disp(mess),disp(mess1),disp(unlin(1:length(mess1))),disp(s0),disp(s5)
         ch=input(s8);
         if ch==0, return,end
         if ch==3,switch=1;end
         if ch==4,switch=0;end
         if ch==2
            ex=['EXPLANATION: Since A(' num2str(i) ',' num2str(j) ')']; 
            ex=[ex ' is not 1 we use row operation'];
            ex1=['             (1/' num2str(A(i,j)) ') * Row ' num2str(i)];
            ex1=[ex1 ' to get a 1.'];
            disp(ex),disp(ex1),disp(s0),disp(s9),pause,ch=1;
         end
         if ch==1,sig='Y';A(i,j:n) = A(i,j:n)/A(i,j);end
         if (ch~=1 & ch~=2 & ch~=3 & ch~=4)
            disp(s10),disp(s0),disp(s9),pause
         end
         clc,disp(s1),disp(s0),disp(s3)
         if (switch),format rational,disp(A),format,else,disp(A),end
         disp(s0)
         end %while not a proper choice or chose explain; ie sig='N'
      elseif abs(A(i,j))<=tol
         v=find(abs(A(i:m,j))>tol);
         k=v(1)+i-1; %index of first nonzero elem. that can be next pivot
         sig='N';
         while sig=='N'
         mess=['Interchange rows ' int2str(i) ' and ' int2str(k) '.'];
         disp(mess),disp(unlin(1:length(mess))),disp(s0),disp(s5)
         ch=input(s8);
         if ch==0, return,end
         if ch==3,switch=1;end
         if ch==4,switch=0;end
         if ch==2
            ex=['EXPLANATION: Since A(' num2str(i) ',' num2str(j) ') = 0']; 
            ex=[ex ' we find the first nonzero element below it and '];
            ex1=['             interchange rows to establish the pivot row.'];
            disp(ex),disp(ex1),disp(s0),disp(s9),pause,ch=1;
         end
         if ch==1,sig='Y';
            A([i k],j:n) = A([k i],j:n); %swap rows i and k
         end
         if (ch~=1 & ch~=2 & ch~=3 & ch~=4)
            disp(s10),disp(s0),disp(s9),pause
         end
         clc,disp(s1),disp(s0),disp(s3)
         if (switch),format rational,disp(A),format,else,disp(A),end
         disp(s0)
         end %while not a proper choice or chose explain; ie sig='N'
      if A(i,j)==1
         sig='N';
         while sig=='N'
         mess=['Use row ' int2str(i) ' as the pivot row.'];
         disp(mess),disp(unlin(1:length(mess))),disp(s0),disp(s5)
         ch=input(s8);
         if ch==0, return,end
         if ch==3,switch=1;end
         if ch==4,switch=0;end
         if ch==2
            ex=['EXPLANATION: Since A(' num2str(i) ',' num2str(j) ') = 1']; 
            ex=[ex ' we use row ' num2str(i) ' as the pivot row.'];
            disp(ex),disp(s0),disp(s9),pause,ch=1;
         end
         if ch==1,sig='Y';end
         if (ch~=1 & ch~=2 & ch~=3 & ch~=4)
            disp(s10),disp(s0),disp(s9),pause
         end
         clc,disp(s1),disp(s0),disp(s3)
         if (switch),format rational,disp(A),format,else,disp(A),end
         disp(s0)
         end %while not a proper choice or chose explain; ie sig='N'
      elseif abs(A(i,j))>tol
         sig='N';
         while sig=='N'
         mess=['Use row ' int2str(i) ' as the pivot row.'];
         mess1=['We do a row operation to get a 1 into the '];
         mess1=[mess1 '(' int2str(i) ',' int2str(j) ') position.'];
         disp(mess),disp(mess1),disp(unlin(1:length(mess1)))
         disp(s0),disp(s5),ch=input(s8);
         if ch==0, return,end
         if ch==3,switch=1;end
         if ch==4,switch=0;end
         if ch==2
            ex=['EXPLANATION: Since A(' num2str(i) ',' num2str(j) ')']; 
            ex=[ex ' is not 1 we use row operation'];
            ex1=['             (1/' num2str(A(i,j)) ') * Row ' num2str(i)];
            ex1=[ex1 ' to get a 1.'];
            disp(ex),disp(ex1),disp(s0),disp(s9),pause,ch=1;
         end
         if ch==1,sig='Y';A(i,j:n) = A(i,j:n)/A(i,j);end
         if (ch~=1 & ch~=2 & ch~=3 & ch~=4)
            disp(s10),disp(s0),disp(s9),pause
         end
         clc,disp(s1),disp(s0),disp(s3)
         if (switch),format rational,disp(A),format,else,disp(A),end
         disp(s0)
         end %while not a proper choice or chose explain; ie sig='N'
      end %inner loop A(i,j)=1

      end % outer loop A(i,j)=1

      %to get here we have a 1 in the pivot position
      % Subtract multiples of the pivot row from all the other rows.
      for k = [1:i-1 i+1:m]
         sig='N';
         if abs(A(k,j))<=tol,sig='Y';end  %skips elimination if zero 
         while sig=='N'
         mess=['Eliminate the (' int2str(k) ',' int2str(j) ') element.'];
         disp(mess),disp(unlin(1:length(mess))),disp(s0),disp(s5)
         ch=input(s8);
         if ch==0, return,end
         if ch==3,switch=1;end
         if ch==4,switch=0;end
         if ch==2
            ex=['EXPLANATION: Use row operation ' num2str(-A(k,j))];
            ex=[ex ' * Row ' num2str(i) ' added to Row ' num2str(k)];
            ex1=['             to get a zero in the (' int2str(k) ','];
            ex1=[ex1 int2str(j) ') element.'];
            disp(ex),disp(ex1),disp(s0),disp(s9),pause,ch=1;
         end
         if ch==1,sig='Y';A(k,j:n) = A(k,j:n) - A(k,j)*A(i,j:n);end
         if (ch~=1 & ch~=2 & ch~=3 & ch~=4)
            disp(s10),disp(s0),disp(s9),pause
         end
         clc,disp(s1),disp(s0),disp(s3)
         if (switch),format rational,disp(A),format,else,disp(A),end
         disp(s0)
         end %while not a proper choice or chose explain; ie sig='N'
      end %of row ops for column j
      mess=['Elimination complete in column ' num2str(j) '.'];
      disp(mess),disp(unlin(1:length(mess))),disp(s0),disp(s11),pause
      i = i + 1;j = j + 1; %increment row & column counters
  end
end %while

% ending messages
clc,disp(s1),disp(s0),disp(s3)
if (switch),format rational,disp(A),format,else,disp(A),end
disp(s0)
mess=['This is the Reduced Row Echelon Form.'];
disp(mess),disp(s0),disp('RREF Step-by-Step is over!')
