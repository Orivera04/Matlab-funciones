function rrefquik(A)                    %last updated 10/31/97
%RREFQUIK  Finds an reduced row echelon form of matrix A showing few details. 
%          All steps are performed automatically and shown in a movie form.
%          The pivots are chosen as the first nonzero value from the
%          eligible entries. An option for rational display is
%          available.
%
%            Use in the form  ==>    rrefquik(A)      <==
%
%            Requires routine utriquik
%
%            See also rrefview and rrefstep
%
%       By: David R. Hill, Math Dept, Temple University
%           Philadelphia, Pa. 19122
%           Email: hill@math.temple.edu

%NOTES: Strategy is to get upper triangular form, make the pivots 1, and
%       then eliminate above the pivots.
%       We scan for small entries after each row op & set them to zero

%STRINGS
timeval=2;  %setting time delay
s0=' ';
s1='<><> Reduction to REDUCED ROW ECHELON Form Viewed as a Movie <><>';
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


head='Reduction to REDUCED ROW ECHELON FORM';
mess1='Zero it out to obtain';
mess3='Divide the pivot row by the pivot element in ';
ob='to obtain';
sig='N'; %setting up loop for menu selection
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

[m,n]=size(A);

A=utriquik(A,swcode,0);
clc,disp('The UPPER triangular form:')
if (swcode),format rational,disp(A),format,else,disp(A),end
pause(timeval)
for k=m:-1:1
    if any(A(k,:))~=0
       mk=k;
       break
    end
end
%mk is the first row of not all zeros starting from the bottom
%the pivot rows starting at the bottom are
prow=[mk:-1:1];

%Next find first nonzero entry in each pivot row
pcol=[];
for k=mk:-1:1
    v=A(k,:);
    for j=1:n
        if v(j)~=0
           pcol=[pcol j];
           break
        end
    end
end
%pcol contains the pivot columns

%Make each pivot = to 1.
%
pause(3)
for k=1:length(prow)
    clc,disp('Making the pivots equal to 1.')
    A(prow(k),:)=(1/A(prow(k),pcol(k)))*A(prow(k),:);
    for kk=1:m  %scanning for small entries
        for jj=1:n
           if abs(A(kk,jj))<= 100*eps,A(kk,jj)=0;end
       end
    end
    if (swcode),format rational,disp(A),format,else,disp(A),end
    pause(timeval)
end

%eliminate above each pivot
pause(3)
for k = 1:length(prow)-1
    for j = k+1:length(prow)
        clc
        disp(['Eliminating above the pivot in column ' num2str(pcol(k))])
        A(prow(j),:)=-A(prow(j),pcol(k))*A(prow(k),:)+A(prow(j),:);
        for kk=1:m   %scanning for small entries
            for jj=1:n
               if abs(A(kk,jj))<= 100*eps,A(kk,jj)=0;end
            end
        end
        if (swcode),format rational,disp(A),format,else,disp(A),end
        pause(timeval)
    end
    pause(timeval)
end
clc
disp('The RREF of the matrix is:')
if (swcode),format rational,disp(A),format,else,disp(A),end
disp(s0),disp(s0)
disp('Routine RREFQUIK is over!')
