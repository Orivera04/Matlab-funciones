function rfA=rowech(A)                    %last updated 1/21/94
%ROWECH   Practice forming the reduced row echelon form of matrix A.
%         The user chooses row operations to transform A to reduced
%         row echelon form. Hints, help, and checks are available.
%         Intermediate steps can be checked for
%             ** leading 1's
%             ** if a leading 1 is in a column of the proper form
%             ** rows with leading 1's form a staircase downward
%                to the right
%             ** zero rows appear last
%        A total check for correctness is also available.
%
%        Use in the form   ==>  rowech(A)  <==
%
%         By: David R. Hill, Math Dept, Temple University
%             Philadelphia, Pa.  19122

[m,n]=size(A);
oldA=A;
%Set up strings to be used as messages.
s0='     ';
s1='Enter first row number.  ';
s2='Enter second row number.  ';
s3='Enter multiplier.  ';
s4='Enter nonzero multiplier.  ';
s5='Enter row number.  ';
s6='Enter number of row that changes.  ';
s7='Last row operation "undone". ';
s8='   ***** Practice Computing Reduced Row Echelon Form *****';
s9='         The current matrix is:';
s10='     ENTER your choice ===> ';
s11='Press  ENTER  to continue';
s12='*****  -->  ROWECH is over. Your final matrix is:';
s13='** Improper row number! **';
s14='Interchange Complete.';
s15='Row Multiplication Complete.';
s16='Replacement by Linear Combination Complete.';
s17='     Checks for Reduced Row Echelon Form';
s18='There is a nonzero row which does not have a leading 1.';
s19='A column with a leading 1 is not a column of an identity';
s19=[s19 ' matrix.'];
s20='There is a nonzero row without a leading 1.';
s21='The rows with leading 1''s are not in staircase form.';
s22='The rows with leading 1''s are in staircase form.';
s23='The columns with leading 1''s are columns of an identity';
s23=[s23 ' matrix.'];
menu=['          OPTIONS                                     ';
      ' 1  Interchange two rows.                             ';
      ' 2  Multiply a row by a nonzero scalar.               ';
      ' 3  Replace a row by linear combination of            ';
      '             itself with another row.                 ';
      ' 4  CHECKS.                                           ';
      '-1  "Undo" previous row operation.                    ';
      ' 7  Definition   8  Starting Hints.   9  General Help.';
      ' 0  Quit ROWECH!                                      '];
def=['     A matrix is in Reduced Row Echelon Form if     ';
     '                                                    ';
     ' 1. All zero rows, if any, come last.               ';
     '                                                    ';
     ' 2. The first entry of a nonzero row is a 1.        ';
     '    (This is called a leading 1 of the row.)        ';    
     '                                                    ';
     ' 3. In each nonzero row, the leading 1 appears      ';
     '    to the right of the leading 1 in preceding rows.';
     '                                                    ';
     ' 4. Any column in which a leading 1 appears has     ';
     '    zeros in every other entry.                     ';
     '                                                    ';
     '                                                    ';
     '            Press   ENTER   to continue.            '];    
hlp1=['          Suggested FIRST Steps                     ';
      '                                                    ';
      '*** Move any zero rows to the bottom.               ';
      '                                                    ';
      '*** If a 1 appears in the first column, interchange ';
      '    rows to move it to the (1,1)-entry.             ';
      '                                                    ';
      '*** If no 1 appears in the first column, multiply a ';
      '    row by a scalar to produce 1. Then, interchange ';
      '    rows to move it to the (1,1)-entry.             ';
      '                                                    ';
      '*** Use linear combinations of row 1 with other rows';
      '    to "zero out" the entries below the (1,1)-entry.';
      '                                                    ';
      '                                                    ';
      '             Press   ENTER   to continue.           '];
hlp2=['                 General Steps to Use               ';
      '                                                    ';
      '===> Move any zero rows to the bottom.              ';
      '                                                    ';
      '===> Use linear combinations of rows to produce     ';
     '      zeros above and below leading 1''s.            ';
      '                                                    ';
      '===> Arrange the order of the rows so that leading  ';
     '      1''s form a staircase downward to the right.   ';
      '                                                    ';
      '                                                    ';
      '               Press   ENTER   to continue.         '];
intro=['Practice forming the reduced row echelon form of       ';
       'matrix A.                                              ';
       '                                                       ';
       'The user chooses row operations to reduce A to reduced ';
       'row echelon form. Help and checks are available.       ';
       'Intermediate steps can be checked for                  ';
      '   ** leading 1''s                                      ';
       '   ** if a leading 1 is in a column of the proper form ';
      '   ** rows with leading 1''s form a staircase downward  ';
       '      to the right                                     ';
       '   ** zero rows appear last.                           ';
      'A total check for correctness is also available.       '];
ckmenu=['          OPTIONS                                    ';
        '                                                     ';
        ' 1  Do nonzero rows have a leading 1?                ';
       ' 2  Do columns with leading 1''s have the proper form?';
        ' 3  Are the nonzero rows in staircase form?          ';
        ' 4  Are zero rows at the bottom?                     ';
        ' 5  Is A in Reduced Row Echelon Form?                ';
        '                                                     ';
        ' 0  Return to main menu.                             '];
clc   % present introduction
disp(s8),disp(s0),disp(intro),disp(s0),disp(s11)
pause
clc    % present definition of RREF
disp(s8),disp(s0),disp(def)
pause
mess=s8;
rfA=rref(A); %compute reduced row echelon form
while 1
  clc
  disp(mess),disp(s9),A,disp(menu)
  ch=input(s10);
  if ch==-1
    A=oldA;mess=s7;
  end
  if ch==0
    clc
    disp(s12),disp(s0),A,AEQ=A;
    break
  end
  if ch==1
    sig='Y';
    j=input(s1);k=input(s2);
    aj=abs(fix(j));ak=abs(fix(k));
    if j~=aj | j>m | k~=ak | k>m
      disp(s13),disp(s11)
      pause
      sig='N';mess=s0;
    end
    if sig=='Y'
      oldA=A;temp=A(j,:);A(j,:)=A(k,:);A(k,:)=temp;mess=s14;
    end
  end
  if ch==2
    sig='Y';
    k=input(s3);
    while (k==0)
      k=input(s4);
    end
    j=input(s5);
    aj=abs(fix(j));
    if j~=aj | j>m
      disp(s13),disp(s11),pause
      sig='N';mess=s0;
    end
    if sig=='Y'
      oldA=A;A(j,:)=k*A(j,:);mess=s15;
    end
  end
  if ch==3
    sig='Y';
    t=input(s3);k=input(s1);j=input(s6);
    aj=abs(fix(j));ak=abs(fix(k));
    if j~=aj | j>m | k~=ak | k>m
      disp(s13),disp(s11),pause
      sig='N';mess=s0;
    end
    if sig=='Y'
      oldA=A;
      A(j,:)=t*A(k,:)+A(j,:);mess=s16;
    end
  end
  if ch==7
     clc
     disp(def),pause,mess=s0;
  end
  if ch==8
     clc
     disp(hlp1),pause,mess=s0;
  end
  if ch==9
     clc
     disp(hlp2),pause,mess=s0;
  end
  if ch==4  %checks that are available
     chk=1;
     while chk~=0
        clc
        disp(s17),disp(s9),A,disp(ckmenu)
        chk=input(s10);
        if chk==1 | chk==2 | chk==3 | chk==4 | chk==5
           if chk==1
              z=sum(abs(A'));z=find(z==0);
              ldone='Y';
              for k=1:m
                 if(length(find(z==k))==0) %if zero check
                    ld=find(A(k,:)~=0);   %  for leading 1
                    if abs(A(k,ld(1))-1)>10*eps
                       disp(s18),disp(s0),disp(s11),pause
                       ldone='N';
                       break
                    end
                  end
              end
              if ldone=='Y' 
                 disp('Each nonzero row has a leading 1.')
                 disp(s0),disp(s11),pause
              end
           end
           if chk==2
              z=sum(abs(A'));
              z=find(z==0);
              ldone='Y'; badcol='N';
              for k=1:m
                 if(length(find(z==k))==0) %if zero check
                    ld=find(A(k,:)~=0);   %  for leading 1
                    if abs(A(k,ld(1))-1)>10*eps
                       ldone='N';
                    else
                       for j=1:m
                          if j~=k  %skip row with leading 1
                             if A(j,ld(1))~=0
                                badcol='Y'; %set to say not
                                break       % a column of I
                             end
                           end
                       end
                    end
                  end
              end
              if badcol=='Y',disp(s19),else,disp(s23),end
              if ldone=='N',disp(s20),end
              disp(s0),disp(s11),pause
           end
           if chk==3
              rld=[];cld=[]; %initialize row & col # vectors for
              z=sum(abs(A'));  %the location of leading 1's
              z=find(z==0);
              ldone='Y'; 
              for k=1:m
                 if(length(find(z==k))==0) %if zero check
                    ld=find(A(k,:)~=0);   %  for leading 1
                    if abs(A(k,ld(1))-1)>10*eps
                       ldone='N'; %telling there is a nonzero
                    else          %row that does not have a
                       rld=[rld k];  %leading 1
                       cld=[cld ld(1)];
                    end
                  end
              end
              scld=sort(cld);
              if sum(abs(scld-cld))~=0
                 disp(s21)
              else
                 disp(s22)
              end
              if ldone=='N',disp(s20),end
              disp(s0),disp(s11),pause
           end
           if chk==4
              z=sum(abs(A'));z=find(z==0);
              if length(z)==0
                 disp('There are no zero rows present.')
                 disp(s0),disp(s11),pause
              else
                 outorder='N';l=length(z);
                 t=m;
                 for k=l:-1:1
                    if z(k)~=t
                       disp('A zero row is not at the bottom.')
                       outorder='Y';disp(s0),disp(s11),pause
                       break
                    end
                    t=t-1;
                 end
                 if outorder=='N'
                    disp('All zero rows appear last.')
                    disp(s0),disp(s11),pause
                 end
              end
           end
           if chk==5
              if sum(sum(abs(A-rfA)))<=10*eps
                 disp('Matrix A is in Reduced Row Echelon Form.')
                 disp(s0),disp(s11),pause
              else
                 clc
                 disp('A is not in Reduced Row Echelon Form.')
                 pause(2),disp(s9),A
                 disp('The Reduced Row Echelon Form is:')
                 rfA  %display rref(A)
                 disp(s11),pause
              end
           end
        end
     mess=s0;
     end  % of while not to return to main menu
  end 
end %of while 1
