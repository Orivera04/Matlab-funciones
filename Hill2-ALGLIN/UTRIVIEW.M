function A = utriview(A,swcode,pcode)                %last updated 10/31/97
%UTRIVIEW    Finds an upper triangular form of matrix A showing 
%            the steps in the form of a movie. All steps are performed 
%            automatically. The pivots are chosen as the first nonzero
%            value from the eligible entries. An option for rational
%            display is available as is an option for forcing the pivots
%            to be 1.
%
%            Use in the form  ==>    utriview(A)      <==
%
%            See also utriquik and utristep
%
%       By: David R. Hill, Math Dept, Temple University
%           Philadelphia, Pa. 19122
%           Email: hill@math.temple.edu

%NOTES: Modification of rrefview to upper triangular form.   10/13/97
%       For MATLAB 5 had to change word switch to swcode.
%       Added pivot menu.
%  10/29/97  Put in input parameters swcode & pcode so that this routine
%            could be called from rrefview to do the elimination to upper
%            triangular form. Deliberately did not document this in help.
%  10/31/97  Put in scan for small entries to set to zero residue
%            from floating point calculations

%STRINGS
s0=' ';
s1='      <><><><> Reduction to Upper Triangular Form Viewed as a Movie <><><><>';
s8='     Your choice ==>  ';
s9='  Press Enter to continue  ';
s10='Improper choice-- try again.';
menu=['       <<Display OPTIONS >>        ';
      '                                   ';
      '   1. Use rational display mode.   ';
      '                                   ';
      '   2. Use real display mode.       ';
      '                                   ';
      '   0. Quit                         '];
pivmenu=['       <<Pivot OPTIONS >>             ';
         '                                      ';
         '   1. Force the pivots to be 1.       ';
         '                                      ';
         '   2. Use the original pivot values.  ';
         '                                      ';
         '   0. Quit                            '];


head='Reduction to UPPER Triangular Form - Using the First Nonzero Pivot Strategy';
mess1='Zero it out to obtain';
mess3='Divide the pivot row by the pivot element in ';
ob='to obtain';
sig='N'; %setting up loop for menu selection
if nargin>1,sig='Y';end
while sig=='N'
   clc,disp(s1),disp(s0),disp(menu),disp(s0)
   ch=input(s8);
   if ch==0,return,end
   if ch==1,swcode=1;sig='Y';end
   if ch==2,swcode=0;sig='Y';end
   if ch~=1 & ch~=2
      disp(s10),disp(s9),pause
   end
end
sig='N'; %setting up loop for menu selection
if nargin>2,sig='Y';end
while sig=='N'
   disp(s0),disp(s0),disp(pivmenu),disp(s0)
   pch=input(s8);
   if pch==0,return,end
   if pch==1,pcode=1;sig='Y';end
   if pch==2,pcode=0;sig='Y';end
   if pch~=1 & pch~=2
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
            if (swcode),format rational,disp(A),format,else,disp(A),end
            disp(s0),disp(mess1),disp(s0)
            A(i:m,j) = zeros(m-i+1,1);
            if (swcode),format rational,disp(A),format,else,disp(A),end,pause(timeval)
         end
         j=j+1;
      end
   end
   if skip~='Y'
      if i ~= k  % Interchange i-th and k-th rows.
         clc,disp(head),disp(s0)
         disp(['Interchange rows ' int2str(i) ' and ' int2str(k) ' in'])
         disp(s0)
         if (swcode),format rational,disp(A),format,else,disp(A),end
         disp(ob),disp(s0)
         A([i k],j:n) = A([k i],j:n);
         for kk=1:m  %scanning for small entries
             for jj=1:n
                 if abs(A(kk,jj))<= 100*eps,A(kk,jj)=0;end
             end
         end
         if (swcode),format rational,disp(A),format,else,disp(A),end,pause(timeval)
      end
      if pcode==1
         % Divide the pivot row by the pivot element if not = 1
         if A(i,j)~=1
            clc,disp(head),disp(s0)
            disp(['Pivot element = A(' int2str(i) ',' int2str(j) ')'])
            disp(mess3),disp(s0)
            if (swcode),format rational,disp(A),format,else,disp(A),end
            disp(ob),disp(s0)
            A(i,j:n) = A(i,j:n)/A(i,j);
            for kk=1:m  %scanning for small entries
                for jj=1:n
                    if abs(A(kk,jj))<= 100*eps,A(kk,jj)=0;end
                end
            end
            if (swcode),format rational,disp(A),format
               else,disp(A),end,pause(timeval)
         end
      end
      % Subtract multiples of the pivot row from all the other rows.
      for k = [i+1:m]
         if A(k,j)~=0
            clc,disp(head),disp(s0)
            disp(['Eliminate entry A(' int2str(k) ',' int2str(j) ') in'])
            disp(s0)
            if (swcode),format rational,disp(A),format,else,disp(A),end
            disp(ob),disp(s0)
            A(k,j:n) = A(k,j:n) - A(k,j)/A(i,j)*A(i,j:n);
            for kk=1:m  %scanning for small entries
                for jj=1:n
                    if abs(A(kk,jj))<= 100*eps,A(kk,jj)=0;end
                end
            end
            if (swcode),format rational,disp(A),format
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
if nargin==1
   disp('UTRIVIEW is over!')
end
