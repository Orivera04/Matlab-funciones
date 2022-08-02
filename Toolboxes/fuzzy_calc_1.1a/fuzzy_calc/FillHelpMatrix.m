function solution=FillHelpMatrix(A,B);
% function solution=FillHelpMatrix(A,B);
% Fill the Help matrix for FLSE A*X=B
% solution is a structured variable with fields:
% .exists - if 1, "solution exists", the system is consistent 
% .hlp - contains the help matrix
% .ind - index vector
% .Xgr - greatest solution of the system
% .coef- S,E,G coefficient matrix
% .contr - contraditory equations, if the system is not consistent
% .A   - rearranged matrix Ainput
% .B   - rearranged matrix Binput
% .Ainput - input matrix A
% .Binput - input matrix B
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

global Rows Cols mrk
% Ind Xgr hlp,  -> delete also  "mrk" from here  
Rows=length(B);
Cols=length(A(1,:));
 [A1,B1]=sortmat(A,B);
[Coef]=FillTypeMatrix(A1,B1);

%for i=1:Rows; Ind(i)=0; end;
Ind=zeros(1,Rows);
%for j=1:Cols; Xgr(j)=1; end;
Xgr=ones(1,Cols);

hlp=zeros(Rows,Cols);

for j=1:Cols
    LastG=LastG_coef(Coef,j);
    FirstE=FirstE_coef(Coef,j);
    if ~LastG.exist
        if FirstE.exist
            [hlp,Ind]=WorkIfE(Coef,B1,j,FirstE.row,hlp,Ind);
            %ok=WorkIfE(Coef,B1,j,FirstE.row);
        end;
    else 
        [hlp,Ind,Xgr]=WorkIfG(Coef,B1,j,LastG.row,hlp,Ind,Xgr);
        %ok=WorkIfG(Coef,B1,j,LastG.row);
    end;
end;

contradic_eq_nr=[0]; 
%if ~CheckInd(Ind)
if ~all(Ind)
    
    disp('The system is inconsistent');
    disp('The contradictory equations are:');
    solition.exist=0;
    k=0;
    for i=1:Rows
        if Ind(i)==0;
            k=k+1;
            contradic_eq_nr(k)=i;
            stri=['equation nr.' num2str(i)];
            disp(stri);
        end
    end
    solution.exist=0;
    solution.ind=Ind;
    solution.hlp=hlp;
    solution.Xgr=Xgr;
    solution.coef=Coef;
    solution.mrk=mrk;
    solution.contr=contradic_eq_nr;
    solution.A=A1;
    solution.B=B1;
    solution.Ainput=A;
    solution.Binput=B;
    return
else
    solution.exist=1;
    solution.ind=Ind;
    solution.hlp=hlp;
    solution.Xgr=Xgr;
    solution.coef=Coef;
    solution.mrk=mrk;
    solution.contr=contradic_eq_nr;
    solution.A=A1;
    solution.B=B1;
    solution.Ainput=A;
    solution.Binput=B;
end;

function [Coef]=FillTypeMatrix(A,B);
global Rows Cols;
for i=1:Rows;              %      Rows
    for j=1:Cols;     %      Cols
        if A(i,j)>B(i)
            Coef(i,j)='G';
        elseif A(i,j)==B(i)
            Coef(i,j)='E';
        else Coef(i,j)='S';
        end;
    end;
end;

function LastG=LastG_coef(CoefMatrix,InColumn);
global Rows Cols;
LastG.exist=0;
LastG.row=Rows;

while (~LastG.exist)&(LastG.row>=1);
    if CoefMatrix(LastG.row,InColumn)=='G';
        LastG.exist=1;
    else 
        LastG.row=LastG.row-1;
    end
end    

function FirstE=FirstE_coef(CoefMatrix,InColumn);
global Rows Cols;
FirstE.exist=0;
FirstE.row=1;
while (~FirstE.exist)&(FirstE.row<=Rows);
    if CoefMatrix(FirstE.row,InColumn)=='E'
        FirstE.exist=1;
    else 
        FirstE.row=FirstE.row+1;
    end
end    

function [hlp,Ind]=WorkIfE(CoefMatrix,B1,InColumn,RowWithE,hlp,Ind);
% -------------------------------------------------------------------
global Rows Cols;

for i=RowWithE:Rows;
    if CoefMatrix(i,InColumn)=='E'
        hlp(i,InColumn)=B1(i);
        Ind(i)=Ind(i)+1;
    end;
end;



function [hlp,Ind,Xgr]=WorkIfG(CoefMatrix,B1,InColumn,RowWithG,hlp,Ind,Xgr);
% -------------------------------------------------------------------
global Rows Cols  
Xgr(InColumn)=B1(RowWithG);
for i=RowWithG:-1:1
    %if ((CoefMatrix(i,InColumn)=='G')&(B1(RowWithG)==B1(i)))   % 22 April 2005 Upgrade:    RowWithG + 1
    %    hlp(i,InColumn)=B1(RowWithG);
    %    Ind(i)=Ind(i)+1;
    %end
    if (((CoefMatrix(i,InColumn)=='E')|(CoefMatrix(i,InColumn)=='G'))&(B1(RowWithG)==B1(i)))
        hlp(i,InColumn)=B1(RowWithG);
        Ind(i)=Ind(i)+1;
    end
end;
for i=RowWithG:1:Rows
    if CoefMatrix(i,InColumn)=='E'
        hlp(i,InColumn)=B1(i);
        Ind(i)=Ind(i)+1;
    end;
end;


