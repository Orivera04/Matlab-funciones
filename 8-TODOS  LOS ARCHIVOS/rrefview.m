function A = rrefview(A)                             %last updated 1/21/94
%RREFVIEW    Finds the reduced row echelon form of matrix A showing 
%            the steps in the form of a movie. All steps are performed 
%            automatically. The pivots are chosen as the first nonzero
%            value from the eligible entries. An option for rational
%            display is available.
%
%            Use in the form  ==>    rrefview(A)      <==
%
%       By: David R. Hill, Math Dept, Temple University
%           Philadelphia, Pa. 19122


s0=' ';
s1='      <><><><> Reduced Row Echelon Viewed as a Movie <><><><>';
s8='     Your choice ==>  ';
s9='  Press Enter to continue  ';
s10='Improper choice-- try again.';
menu=['   1. Use rational display mode.   ';
      '   2. Use real display mode.       ';
      '                                   ';
      '   0. Quit                         '];
head='Reduced Row Echelon Form - Using the First Nonzero Pivot Strategy';
mess1='Zero it out to obtain';
mess3='Divide the pivot row by the pivot element in ';
ob='to obtain';
sig='N'; %setting up loop for menu selection
while sig=='N'
   clc,disp(s1),disp(s0),disp(menu)
   ch=input(s8);
   if ch==0,return,end
   if ch==1,switch=1;sig='Y';end
   if ch==2,switch=0;sig='Y';end
   if ch~=1 & ch~=2
      disp(s10),disp(s9),pause
   end
end
timeval=4;  %setting time delay
[m,n] = size(A);tol = max([m,n])*eps*norm(A,'inf');
clc,i = 1;j = 1;k = 0; %Loop over the entire matrix.
while (i <= m) & (j <= n)
   k=i;skip='N';
   if (abs(A(i,j)) <= tol)
      p = max(abs(A(i:m,j))); 
      if p > tol  %search for first nonzero pivot
         kval=find(abs(A(i:m,j)) > tol);k=kval(1)+i-1;
      else  % The column is negligible, zero it out if not in last row
            %and not already zero.
         skip='Y';
         if (i~=m) & any(abs(A(i:m,j))~=0)
            clc,disp(head),disp(s0)
            str=['Column ' int2str(j) ' below A(' int2str(i-1) ','];
            str=[str int2str(j) ') is negligible in '];
            disp(str)
            if (switch),format rational,disp(A),format,else,disp(A),end
            disp(s0),disp(mess1),disp(s0)
            A(i:m,j) = zeros(m-i+1,1);
            if (switch),format rational,disp(A),format,else,disp(A),end,pause(timeval)
         end
         j=j+1;
      end
   end
   if skip~='Y'
      if i ~= k  % Interchange i-th and k-th rows.
         clc,disp(head),disp(s0)
         disp(['Interchange rows ' int2str(i) ' and ' int2str(k) ' in'])
         disp(s0)
         if (switch),format rational,disp(A),format,else,disp(A),end
         disp(ob),disp(s0)
         A([i k],j:n) = A([k i],j:n);
         if (switch),format rational,disp(A),format,else,disp(A),end,pause(timeval)
      end
      % Divide the pivot row by the pivot element if not = 1
      if A(i,j)~=1
         clc,disp(head),disp(s0)
         disp(['Pivot element = A(' int2str(i) ',' int2str(j) ')'])
         disp(mess3),disp(s0)
         if (switch),format rational,disp(A),format,else,disp(A),end
         disp(ob),disp(s0)
         A(i,j:n) = A(i,j:n)/A(i,j);
         if (switch),format rational,disp(A),format
            else,disp(A),end,pause(timeval)
      end
      % Subtract multiples of the pivot row from all the other rows.
      for k = [1:i-1 i+1:m]
         if A(k,j)~=0
            clc,disp(head),disp(s0)
            disp(['Eliminate entry A(' int2str(k) ',' int2str(j) ') in'])
            disp(s0)
            if (switch),format rational,disp(A),format,else,disp(A),end
            disp(ob),disp(s0)
            A(k,j:n) = A(k,j:n) - A(k,j)*A(i,j:n);
            if (switch),format rational,disp(A),format
               else,disp(A),end,pause(timeval)
         else
            str=['Entry A(' int2str(k) ',' int2str(j) ') is zero.'];
            str=[str ' No elimination is required.'];
            disp(str),pause(timeval)
         end
      end
      i = i + 1;j = j + 1;
   end
end
disp('RREFVIEW is over!')
