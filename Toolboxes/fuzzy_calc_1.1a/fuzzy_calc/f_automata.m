% Example for behavior matrix and equaivlene of states
% of finite fuzzy machines
%
% The inital data are from [Mordeson and Malik (2002)], see Refernces in the Book.
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.


Mx1y1=[0.00 0.75 0.50
0.75 0.00 0.50
0.00 0.00 0.00];

Mx1y2=[0.00 0.00 0.00
       0.00 0.00 0.00
       0.25 0.25 0.00];
   
Mx2y1=[0.00 0.00 0.625
       0.00 0.00 0.625
       0.00 0.00 0.00];
   
Mx2y2=[0.00 0.375 0.0
       0.375 0.00 0.0
       0.125 0.125 0.00];
       
       
pause            

T11=max(Mx1y1,[],2)
T12=max(Mx1y2,[],2)
T21=max(Mx2y1,[],2)
T22=max(Mx2y2,[],2)
T0=ones(3,1)

fillhelpmatrix(T0,T11)
% The system is inconsistent

T=[T0,T11]
   
fillhelpmatrix(T,T12)
%The system is inconsistent

TT=[T0,T11,T12]

fillhelpmatrix(TT,T21)
%The system is consistent

T22=max(Mx2y2,[],2)

fillhelpmatrix(TT,T22)
%The system is consistent


M1111=fuzzy_maxmin(Mx 1,Mx1y1)

T1111=max(M1111,[],2)

fillhelpmatrix(TT,T1111)
%The system is consistent