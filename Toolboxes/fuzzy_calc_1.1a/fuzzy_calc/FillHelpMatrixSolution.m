function solution=FillHelpMatrixSolution(A,B);
% function solution=FillHelpMatrixSolution(A,B);
% Without fill the Help matrix for FLSE A*X=B
% solution is a structured variable with fields:
% .exists - if 1, "solution exists", the system is consistent 
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

global Rows Cols
% Ind Xgr hlp,  -> delete also  "mrk" from here  
Rows=length(B);
Cols=length(A(1,:));
[A1,B1]=sortmat(A,B);
[Coef]=FillTypeMatrix(A1,B1);

Ind=zeros(1,Rows);

for j=1:Cols
    LastG=LastG_coef(Coef,j);
    FirstE=FirstE_coef(Coef,j);
    if ~LastG.exist
        if FirstE.exist
            [Ind]=WorkIfE(Coef,B1,j,FirstE.row,Ind);
            %ok=WorkIfE(Coef,B1,j,FirstE.row);
        end;
    else 
        [Ind]=WorkIfG(Coef,B1,j,LastG.row,Ind);
        %ok=WorkIfG(Coef,B1,j,LastG.row);
    end;
end;

contradic_eq_nr=[0]; 
if ~all(Ind)
    solution.exist=0;
else
    solution.exist=1;
end;

function [Coef]=FillTypeMatrix(A,B);
global Rows Cols;
for i=1:Rows;         %      Rows
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

function [Ind]=WorkIfE(CoefMatrix,B1,InColumn,RowWithE,Ind);
% -------------------------------------------------------------------
global Rows Cols;

for i=RowWithE:Rows;
    if CoefMatrix(i,InColumn)=='E'
        Ind(i)=Ind(i)+1;
    end;
end;



function [Ind]=WorkIfG(CoefMatrix,B1,InColumn,RowWithG,Ind);
% -------------------------------------------------------------------
global Rows Cols  
for i=RowWithG:-1:1
    if ((CoefMatrix(i,InColumn)=='G')&(B1(RowWithG)==B1(i)))
        Ind(i)=Ind(i)+1;
    end
    if (((CoefMatrix(i,InColumn)=='E')|(CoefMatrix(i,InColumn)=='G'))&(B1(RowWithG)==B1(i)))
        Ind(i)=Ind(i)+1;
    end
end;
for i=RowWithG:1:Rows
    if CoefMatrix(i,InColumn)=='E'
        Ind(i)=Ind(i)+1;
    end;
end;