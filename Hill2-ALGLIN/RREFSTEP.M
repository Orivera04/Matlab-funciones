function rrefstep(A)                    %last updated 3/21/00
%RREFSTEP Reduced Row Echelon form of matrix A is computed step-by-step.
%         At each step a message is displayed which describes the action
%         to be taken. You may either perform the action and see the result
%         or request an explanation of why the action is to be taken.
%         This routine is for small matrices and is to be used for 
%         developing skills in obtaining the reduced row echelon form
%         of a matrix. Rational or real display format can be chosen.
%
%            Use in the form  ==>    rrefstep(A)      <==
%
%            Requires routine utristep
%
%            See also rrefquik and rrefview
%
%       By: David R. Hill, Math Dept, Temple University
%           Philadelphia, Pa. 19122
%           Email: hill@math.temple.edu

%NOTES: Strategy is to get upper triangular form, make the pivots 1, and
%       then eliminate above the pivots.
%       Routine utristep is called to get the upper triangular form.
%       After we get the upper triangular form we check for 'small'
%       entries, abs(entry)<= 100eps & set them to zero to wipe out
%       floating point residue. This is also done after each row operation.
%  3/21/00   Put in code to show multipliers as rational when rational
%            display option is chosen. Used rat command to get numerators
%            & denominators.

%STRINGS
timeval=2;  %setting time delay
s0=' ';
s1='<><> Reduction to REDUCED ROW ECHELON Form STEP-by-STEP <><>';
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

head='Reduction to REDUCED ROW ECHELON FORM';
mess1='Zero it out to obtain';
mess3='Divide the pivot row by the pivot element in ';
ob='to obtain';

%Storing original matrix for later use
%
Aorig=A;

%
warning off

%introduction
clc,disp(s1),disp(s0),disp(s2)
swcode=0;         %setting print swcode for real display initially
if (swcode),format rational,disp(A),format,else,disp(A),end
disp(s0),disp('We start by determining an Upper triangular form.')
disp(s0),disp(s6)
pause,clc
[m,n]=size(A);

A=utristep(A,swcode,0);
%Take the upper triangular form and set any small values to zero.
%By small we mean abs(entry)<=100*eps
%This clears left overs from floating point elimination in utristep
%
for k=1:m
   for j=1:n
       if abs(A(k,j))<= 100*eps,A(k,j)=0;end
   end
end

%START diagonal & upper triangular part of elimination
clc,disp('The UPPER triangular form:')
disp('in rational form:')
format rational,disp(A),format
disp('in decimal form:'),disp(A)
disp(s9)
pause
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
    sig='N';
    while sig=='N'
       clc,mess=['Making the pivot in row ' num2str(prow(k)) ' equal to 1'];
       disp(mess),disp('in matrix'),disp(s0)
       if (swcode),format rational,disp(A),format,else,disp(A),end
       disp(unlin(1:length(mess))),disp(s0),disp(s5)
       ch=input(s8);
       if ch==0, return,end
       if ch==3,swcode=1;end
       if ch==4,swcode=0;end
       if ch==2
          if swcode==1
               [nspec,dspec]=rat(A(prow(k),pcol(k)));
               ex=['EXPLANATION: Multiply row ' num2str(prow(k)) ' by '];
               ex=[ex '( ' num2str(dspec) ' / ' num2str(nspec) ' ).' ];
               disp(ex),disp(s0),disp(s9),pause,ch=1;
            else
               ex=['EXPLANATION: Multiply row ' num2str(prow(k)) ' by 1/']; 
               ex=[ex num2str(A(prow(k),pcol(k))) '.'];
               disp(ex),disp(s0),disp(s9),pause,ch=1;
          end
       end
       if ch==1,sig='Y';end
       if (ch~=1 & ch~=2 & ch~=3 & ch~=4)
          disp(s10),disp(s0),disp(s9),pause
       end
    end %while not a proper choice or chose explain; ie sig='N'
    disp(s0),disp('We obtain:'),pause(1),disp(s0)
    A(prow(k),:)=(1/A(prow(k),pcol(k)))*A(prow(k),:); %making the pivot = 1
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
       sig='N';
       while sig=='N'
       clc,mess=['Eliminating above the pivot in column ' num2str(pcol(k)) ' of matrix'];
       disp(mess),disp(s0)
       if (swcode),format rational,disp(A),format,else,disp(A),end
       disp(['Making entry (' num2str(prow(j)) ',' num2str(pcol(k)) ') zero.'])
        disp(s0)
       disp(unlin(1:length(mess))),disp(s0),disp(s5)
       ch=input(s8);
       if ch==0, return,end
       if ch==3,swcode=1;end
       if ch==4,swcode=0;end
       if ch==2
            if swcode==1
               [nspec,dspec]=rat(-A(prow(j),pcol(k)));
               ex=['EXPLANATION: Use row operation (' num2str(nspec) ' / ' num2str(dspec) ')'];
               ex=[ex ' * Row ' num2str(prow(k)) ];
               exa=['             added to Row ' num2str(prow(j))];
               ex1=['             to get a zero in the (' int2str(prow(j)) ','];
               ex1=[ex1 int2str(pcol(k)) ') element.'];
               disp(ex),disp(exa),disp(ex1),disp(s0),disp(s9),pause,ch=1;
            else
               ex=['EXPLANATION: Use row operation ' ];
               ex=[ex  num2str(-A(prow(j),pcol(k)))];   %<<<<<<<<<<<
               ex=[ex ' * Row ' num2str(prow(k)) ' added to Row ' num2str(prow(j))];
               ex1=['             to get a zero in the (' int2str(prow(j)) ','];
               ex1=[ex1 int2str(pcol(k)) ') element.'];
               disp(ex),disp(ex1),disp(s0),disp(s9),pause,ch=1;
            end
       end
       if ch==1,sig='Y';end
       if (ch~=1 & ch~=2 & ch~=3 & ch~=4)
          disp(s10),disp(s0),disp(s9),pause
       end
    end %while not a proper choice or chose explain; ie sig='N'
          
        A(prow(j),:)=-A(prow(j),pcol(k))*A(prow(k),:)+A(prow(j),:);
        for kk=1:m  %scanning for small entries
            for jj=1:n
                if abs(A(kk,jj))<= 100*eps,A(kk,jj)=0;end
            end
        end
        disp(s0),disp('We obtain:'),pause(2),disp(s0)
        if (swcode),format rational,disp(A),format,else,disp(A),end
        pause(timeval)
    end
    pause(1)
end
clc
disp('The RREF of matrix '),disp(s0)
if (swcode),format rational,disp(Aorig),format,else,disp(Aorig),end
disp(s0)
disp('is'),disp(s0)
if (swcode),format rational,disp(A),format,else,disp(A),end
disp('Routine RREFSTEP is over!')
warning on