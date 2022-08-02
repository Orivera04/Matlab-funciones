function A = utristep(A,swcode,pivcode)          %last updated 3/14/00
%UTRISTEP Upper triangular form of matrix A is computed step-by-step.
%         At each step a message is displayed which describes the action
%         to be taken. You may either perform the action and see the result
%         or request an explanation of why the action is to be taken.
%         This routine is for small matrices and is to be used for 
%         developing skills in obtaining the upper triangular form
%         of a matrix. Rational or real display format can be chosen,
%         as well as an option for forcing the pivots to be 1.
%
%         Use in the form  ===>   utristep(A)      <===
%
%         See also utriquik and utriview.
%
%   By: David R. Hill
%       Math. Dept., Temple University, Philadelphia, Pa. 19122 
%       Email: hill@math.temple.edu

%NOTES: Modification of rrefstep to upper triangular form.   10/13/97
%       For MATLAB 5 had to change word switch to swcode.
%       Added pivot menu.
%  10/29/97  Put in input parameters swcode & pcode so that this routine
%            could be called from rrefquik to do the elimination to upper
%            triangular form. Deliberately did not document this in help.
%  10/31/97  Put in scan for small values to zero out any residue
%            from floating point arithmetic.
%  3/14/00   Put in code to show multipliers as rational when rational
%            display option is chosen. Used rat command to get numerators
%            & denominators.
%  3/14/00   Trapped input for returns so MATLAB 5 doesn't display error
%            message on compares with empty.

%set up string messages
s0=' ';
s1='      <><><><> Upper Triangular Form STEP-BY-STEP <><><><>';
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
pivmenu=['       <<Pivot OPTIONS >>             ';
         '                                      ';
         '   1. Force the pivots to be 1.       ';
         '                                      ';
         '   2. Use the original pivot values.  ';
         '                                      ';
         '   0. Quit                            '];

[m,n] = size(A);

% Compute the default tolerance if none was provided.
tol = max([m,n])*eps*norm(A,'inf');

%introduction
clc,disp(s1),disp(s0),disp(s2)
if nargin==1
   swcode=0;         %setting print swcode for real display initially
else
   s5=s5(1:2,:);
end
if (swcode),format rational,disp(A),format,else,disp(A),end
sig='N'; %setting up loop for menu selection
if nargin>1,sig='Y';end
while sig=='N'
   disp(s0),disp(s0),disp(pivmenu),disp(s0)
   pch=input(s8);
   if isempty(pch),pch=99;end
   if pch==0,return,end
   if pch==1,pivcode=1;sig='Y';end
   if pch==2,pivcode=0;sig='Y';end
   if pch~=1 & pch~=2
      disp(s10),disp(s9),pause
   end
end

disp(s0),disp(s6),pause,clc

% Loop over the entire matrix.
i = 1;j = 1;k = 0;
while (i <= m) & (j <= n)
   %set up screen
   clc,disp(s1),disp(s0),disp(s3)
   if (swcode),format rational,disp(A),format,else,disp(A),end
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
         if isempty(ch),ch=99;end
         if ch==0, return,end
         if ch==3,swcode=1;end
         if ch==4,swcode=0;end
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
         if (swcode),format rational,disp(A),format,else,disp(A),end
         disp(s0)        
         end %while not a proper choice or chose explain; ie sig='N'
      elseif abs(A(i,j))>tol
         if pivcode==1        %<<<<<<<<<<<<<
         sig='N';
         while sig=='N'
         mess=['Use row ' int2str(i) ' as the pivot row.'];    
         mess1=['We do a row operation to get a 1 into the '];
         mess1=[mess1 '(' int2str(i) ',' int2str(j) ') position.'];
         disp(mess),disp(mess1),disp(unlin(1:length(mess1))),disp(s0),disp(s5)
         ch=input(s8);
         if isempty(ch),ch=99;end
         if ch==0, return,end
         if ch==3,swcode=1;end
         if ch==4,swcode=0;end
         if ch==2
            if swcode==1
               [nspec,dspec]=rat(A(i,j));
               if dspec~=1
                  ex=['EXPLANATION: Since A(' num2str(i) ',' num2str(j) ')']; 
                  ex=[ex ' is not 1 we use row operation'];
                  ex1=['             (1/(' num2str(nspec) ' / ' num2str(dspec) ')) * Row ' num2str(i)];
                  ex1=[ex1 ' to get a 1.'];
               else
                  ex=['EXPLANATION: Since A(' num2str(i) ',' num2str(j) ')']; 
                  ex=[ex ' is not 1 we use row operation'];
                  ex1=['             (1/(' num2str(nspec) ')) * Row ' num2str(i)];
                  ex1=[ex1 ' to get a 1.'];
               end   
            else
               ex=['EXPLANATION: Since A(' num2str(i) ',' num2str(j) ')']; 
               ex=[ex ' is not 1 we use row operation'];
               ex1=['             (1/' num2str(A(i,j)) ') * Row ' num2str(i)];
               ex1=[ex1 ' to get a 1.'];
            end
            disp(ex),disp(ex1),disp(s0),disp(s9),pause,ch=1;
         end
         if ch==1,sig='Y';A(i,j:n) = A(i,j:n)/A(i,j);end
         for kk=1:m  %scanning for small entries
             for jj=1:n
                 if abs(A(kk,jj))<= 100*eps,A(kk,jj)=0;end
             end
         end
         if (ch~=1 & ch~=2 & ch~=3 & ch~=4)
            disp(s10),disp(s0),disp(s9),pause
         end
         clc,disp(s1),disp(s0),disp(s3)
         if (swcode),format rational,disp(A),format,else,disp(A),end
         disp(s0)
         end %while not a proper choice or chose explain; ie sig='N'
         end %pivcode loop    <<<<<<<<<<<<
      elseif abs(A(i,j))<=tol
         v=find(abs(A(i:m,j))>tol);
         k=v(1)+i-1; %index of first nonzero elem. that can be next pivot
         sig='N';
         while sig=='N'
         mess=['Interchange rows ' int2str(i) ' and ' int2str(k) '.'];
         disp(mess),disp(unlin(1:length(mess))),disp(s0),disp(s5)
         ch=input(s8);
         if isempty(ch),ch=99;end
         if ch==0, return,end
         if ch==3,swcode=1;end
         if ch==4,swcode=0;end
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
         if (swcode),format rational,disp(A),format,else,disp(A),end
         disp(s0)
         end %while not a proper choice or chose explain; ie sig='N'
      if A(i,j)==1
         sig='N';
         while sig=='N'
         mess=['Use row ' int2str(i) ' as the pivot row.'];
         disp(mess),disp(unlin(1:length(mess))),disp(s0),disp(s5)
         ch=input(s8);
         if isempty(ch),ch=99;end
         if ch==0, return,end
         if ch==3,swcode=1;end
         if ch==4,swcode=0;end
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
         if (swcode),format rational,disp(A),format,else,disp(A),end
         disp(s0)
         end %while not a proper choice or chose explain; ie sig='N'
      elseif abs(A(i,j))>tol
         if pivcode==1    %<<<<<<<<<<<
         sig='N';
         while sig=='N'
         mess=['Use row ' int2str(i) ' as the pivot row.'];
         mess1=['We do a row operation to get a 1 into the '];
         mess1=[mess1 '(' int2str(i) ',' int2str(j) ') position.'];
         disp(mess),disp(mess1),disp(unlin(1:length(mess1)))
         disp(s0),disp(s5),ch=input(s8);
         if isempty(ch),ch=99;end
         if ch==0, return,end
         if ch==3,swcode=1;end
         if ch==4,swcode=0;end
         if ch==2
            if swcode==1
               [nspec,dspec]=rat(A(i,j));
               if dspec~=1
                  ex=['EXPLANATION: Since A(' num2str(i) ',' num2str(j) ')']; 
                  ex=[ex ' is not 1 we use row operation'];
                  ex1=['             (1/(' num2str(nspec) ' / ' num2str(dspec) ')) * Row ' num2str(i)];
                  ex1=[ex1 ' to get a 1.'];
               else
                  ex=['EXPLANATION: Since A(' num2str(i) ',' num2str(j) ')']; 
                  ex=[ex ' is not 1 we use row operation'];
                  ex1=['             (1/(' num2str(nspec) ')) * Row ' num2str(i)];
                  ex1=[ex1 ' to get a 1.'];
               end   
            else
               ex=['EXPLANATION: Since A(' num2str(i) ',' num2str(j) ')']; 
               ex=[ex ' is not 1 we use row operation'];
               ex1=['             (1/' num2str(A(i,j)) ') * Row ' num2str(i)];
               ex1=[ex1 ' to get a 1.'];
            end
            disp(ex),disp(ex1),disp(s0),disp(s9),pause,ch=1;
         end
         if ch==1,sig='Y';A(i,j:n) = A(i,j:n)/A(i,j);end
         for kk=1:m  %scanning for small entries
             for jj=1:n
                 if abs(A(kk,jj))<= 100*eps,A(kk,jj)=0;end
             end
         end
         if (ch~=1 & ch~=2 & ch~=3 & ch~=4)
            disp(s10),disp(s0),disp(s9),pause
         end
         clc,disp(s1),disp(s0),disp(s3)
         if (swcode),format rational,disp(A),format,else,disp(A),end
         disp(s0)
         end %while not a proper choice or chose explain; ie sig='N'
         end %pivcode   <<<<<<<<
      end %inner loop A(i,j)=1

      end % outer loop A(i,j)=1

      %to get here we have a 1 or a nonzero value in the pivot position
      % Subtract multiples of the pivot row from the rows below.
      for k = [i+1:m]
         sig='N';
         if abs(A(k,j))<=tol,sig='Y';end  %skips elimination if zero 
         while sig=='N'
         mess=['Eliminate the (' int2str(k) ',' int2str(j) ') element.'];
         disp(mess),disp(unlin(1:length(mess))),disp(s0),disp(s5)
         ch=input(s8);
         if isempty(ch),ch=99;end
         if ch==0, return,end
         if ch==3,swcode=1;end
         if ch==4,swcode=0;end
         if ch==2
            if swcode==1
               [nspecn,dspecn]=rat(-A(k,j));
               [nspecd,dspecd]=rat(A(i,j));               
               if dspecn~=1 & dspecd~=1
                  ex=['EXPLANATION: Use row operation (' num2str(nspecn) ' / ' num2str(dspecn) ')'];
                  ex=[ex ' / (' num2str(nspecd) ' / ' num2str(dspecd) ')'];
                  ex=[ex ' * Row ' num2str(i) ];
                  exa=['             added to Row ' num2str(k)];
                  ex1=['             to get a zero in the (' int2str(k) ','];
                  ex1=[ex1 int2str(j) ') element.'];
               end  
               if dspecn~=1 & dspecd==1
                  ex=['EXPLANATION: Use row operation (' num2str(nspecn) ' / ' num2str(dspecn) ')'];
                  ex=[ex ' / (' num2str(nspecd) ')'];
                  ex=[ex ' * Row ' num2str(i) ];
                  exa=['             added to Row ' num2str(k)];
                  ex1=['             to get a zero in the (' int2str(k) ','];
                  ex1=[ex1 int2str(j) ') element.'];
               end  
               if dspecn==1 & dspecd~=1
                  ex=['EXPLANATION: Use row operation (' num2str(nspecn) ')'];
                  ex=[ex ' / (' num2str(nspecd) ' / ' num2str(dspecd) ')'];
                  ex=[ex ' * Row ' num2str(i) ];
                  exa=['             added to Row ' num2str(k)];
                  ex1=['             to get a zero in the (' int2str(k) ','];
                  ex1=[ex1 int2str(j) ') element.'];
               end  
               if dspecn==1 & dspecd==1
                  ex=['EXPLANATION: Use row operation (' num2str(nspecn) ')'];
                  ex=[ex ' / (' num2str(nspecd) ')'];
                  ex=[ex ' * Row ' num2str(i) ];
                  exa=['             added to Row ' num2str(k)];
                  ex1=['             to get a zero in the (' int2str(k) ','];
                  ex1=[ex1 int2str(j) ') element.'];
               end              
            else
               ex=['EXPLANATION: Use row operation ' num2str(-A(k,j))];
               ex=[ex ' / ' num2str(A(i,j))];   %<<<<<<<<<<<
               ex=[ex ' * Row ' num2str(i) ];
               exa=['             added to Row ' num2str(k)];
               ex1=['             to get a zero in the (' int2str(k) ','];
               ex1=[ex1 int2str(j) ') element.'];
            end
            disp(ex),disp(exa),disp(ex1),disp(s0),disp(s9),pause,ch=1;
         end
         if ch==1,sig='Y';A(k,j:n) = A(k,j:n) - A(k,j)/A(i,j)*A(i,j:n);end    %<<<<<<<<
         for kk=1:m  %scanning for small entries
             for jj=1:n
                 if abs(A(kk,jj))<= 100*eps,A(kk,jj)=0;end
             end
         end
         if (ch~=1 & ch~=2 & ch~=3 & ch~=4)
            disp(s10),disp(s0),disp(s9),pause
         end
         clc,disp(s1),disp(s0),disp(s3)
         if (swcode),format rational,disp(A),format,else,disp(A),end
         disp(s0)
         end %while not a proper choice or chose explain; ie sig='N'
      end %of row ops for column j
      mess=['Elimination complete in column ' num2str(j) '.'];
      disp(mess),disp(unlin(1:length(mess))),disp(s0),disp(s11),pause
      i = i + 1;j = j + 1; %increment row & column counters
  end
end %while

% ending messages
if nargin==1
   clc,disp(s1),disp(s0),disp(s3)
   if (swcode),format rational,disp(A),format,else,disp(A),end
   disp(s0)
   mess=['This is the Upper Triangular Form.'];
   disp(mess),disp(s0),disp('Upper Triangular Form Step-by-Step is over!')
end
