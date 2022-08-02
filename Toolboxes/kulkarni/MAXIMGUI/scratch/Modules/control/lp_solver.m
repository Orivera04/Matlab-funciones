function x=lp_composite(A,b,c,objective)
% SOLVES AN EQUALITY LP WITH NON-NEGATIVE VARIABLES.
% INPUT:  A = coefficient matrix
%         b = right-hand-side
%         c = objective coefficients
%         objective = 'min' or 'max'
%
% OUTPUT: x = solution values
%         z = objective function value
%         y = dual variables
%         

global m n z x y col_label row_label col_type row_type   
global Tm Tn TA Tb Tc Tc1 Trow_label Tcol_label Trow_type Tcol_type negvar negrow j_reg j_unr j_slack basis Binv 
global status piv_col Unbdd


% set tolerance
epsilon=1.e-10;

% set/check dimensions
[m,n] = size(A);
if length(b)~=m | length(c)~=n
   fprintf('Parameter dimensions are not consistent\n')
   return
end

if ~strcmp(objective,'max') & ~strcmp(objective,'min')
   fprintf('objective not ''min'' or ''max'' (or not specified)\n')
   return
end

%
%   INITIALIZE EQUALITY MATRIX FOR PIVOTING
%
TA=[];
Tb=[];
Tc=[];
Tm=m;
TA(:,1:n)=A;
Tb = b;
Tc(1:n)=c;
Trow_type=3*ones(m,1);
Tcol_type=ones(1,n);
j_reg=n;

% ADD SLACKS
j_slack = n;
for i=1:m
   if Trow_type(i)==1
      j_slack=j_slack+1;
      TA(i,j_slack)=1;
      Tc(j_slack)=0;
   elseif Trow_type(i)==2
      j_slack=j_slack+1;
      TA(i,j_slack)=-1;
      Tc(j_slack)=0;
   end
end


% DUPLICATE COLUMNS FOR UNRESTRICTED VARIABLES, NEGATE COLUMNS FOR NEGATIVE VARIABLES 
negvar=zeros(j_slack,1);
j_unr=j_slack;
for j=1:n
   if Tcol_type(j)==2
      j_unr=j_unr+1;
      TA(:,j_unr)=-A(:,j);
      Tc(j_unr)=-c(j);
      negvar(j)=j_unr;
      negvar(j_unr)=j;
   elseif Tcol_type(j)==3
      TA(:,j)=-A(:,j);
      Tc(j)=-c(j);
      negvar(j)=j;
   end
end

% CHANGE NEGATIVE R.H.S.
for i=1:m
   if b(i)<0
      negrow(i)=1;
      TA(i,:)=-TA(i,:);
      Tb(i)=-Tb(i);
   else
      negrow(i)=0;
   end
end

% CHANGE Tc FOR MIN 

if objective == 'min'
   Tc=-Tc;
end

% ADD ARTIIFICIALS
   TA(:,j_unr+1:j_unr+m)=eye(m);
   Tc(j_unr+1:j_unr+m)=0;
   Tn=j_unr+m;
   negvar(Tn)=0;

% SET BASIS

   basis=[Tn-m+1:Tn];

status = 'start ';
%
%
%
%  THE SIMPLEX METHOD
%
%
Binv=inv(TA(:,basis));

% Tc1 represents the current objective (real or artificial) when simplex ends

Tc1=zeros(1,Tn);
Tc1(Tn-Tm+1:Tn)=-1;
status='infeas';
j_piv=Tn;


% START THE SIMPLEX METHOD

while 1 
   % tableau(A,b,c,objective)
   % COMPUTE REDUCED COSTS, DETERMINE PIVOT COLUMN
   
   temp=(Tc1-Tc1(basis)*Binv*TA)';
   [max_val piv_col] = max(temp(1:j_piv));
   % check if reduced costs are all <=0
   if max_val <= epsilon
      if status=='infeas'
         if Tc1(basis)*Binv*Tb<-epsilon 
            % LP infeasible
            tableau(A,b,c,objective)
            break
         else
            % feasible basis reached
            
            % first get rid of any spurious artificial variables
            for piv_row=1:Tm
               if basis(piv_row)>j_unr
                  for piv_col=1:j_unr
                     column=Binv*TA(:,piv_col);
                     if abs(column(piv_row))>=epsilon
                        pivot(piv_row,piv_col,column)
                        break
                     end
                  end
               end
            end
            
            % now put in actual obj. fn.
            status='nwfeas';
            Tc1=Tc;
            j_piv=Tn-Tm;
            % This restricts pivots to first Tn-m columns
         end
      else
         status='optiml';
         tableau(A,b,c,objective);
         break
      end   
   end
   
   
   % DETERMINE PIVOT ROW
   
   if status=='nwfeas'
      % go back and determine pivot column
      status='feas  ';
   else
      
      max_val=Inf;
      column = Binv*TA(:,piv_col);
      rhs = Binv*Tb;
      
      for i=1:Tm
         if column(i)>epsilon & rhs(i)/column(i)<max_val
            max_val = rhs(i)/column(i);
            piv_row = i;
         end
      end
      
      if max_val == Inf
         status='unbdd ';
         tableau(A,b,c,objective);
         break
      end
      
      % PERFORM PIVOT
      pivot(piv_row,piv_col,column);
      
   end
end
function pivot(piv_row,piv_col,column)

global Tm Binv basis

eta = eye(Tm);
eta(:,piv_row)=-column/column(piv_row);
eta(piv_row,piv_row) = 1/column(piv_row);
Binv=eta*Binv;
basis(piv_row)=piv_col;


function tableau(A,b,c,objective)

  % PRODUCES TABLEAU INFORMATION FOR CURRENT basis BY REINVERTING.  
% INCLUDES DUAL, REDUCED COSTS, AND RANGING INFORMATION.  
% DUAL IS CORRECT FOR EITHER FORM, AND REPRESENTS (INCREASE IN OBJ FN)/(INCREASE IN R.H.S).  

global m n z x y col_label row_label col_type row_type   
global Tm Tn TA Tb Tc Tc1 Trow_label Tcol_label Trow_type Tcol_type negvar negrow j_reg j_unr j_slack basis Binv 
global status piv_col Unbdd epsilon

% SET BASIS MATRIX  

M=TA(:,basis);
CB=Tc1(:,basis);

% COMPUTE ASSOCIATED TABLEAU VALUES 
Binv=inv(M);
Abar=M\TA;
Bbar=M\Tb;
y=CB/M;
cR=y*TA-Tc1;
z=y*Tb;
Tx(Tn,1)=0;
Tx(basis)=Bbar;
Unbdd=zeros(Tn,1);
if status=='unbdd '
   Unbdd(basis)=-Abar(:,piv_col);
   if negvar(piv_col)~=0 & negvar(piv_col)<=j_reg
      Unbdd(negvar(piv_col))=-1;
   else
      Unbdd(piv_col)=1;
   end
end

% adjust for min, negated rows, negative variables

if objective=='min' 
   y=-y;
   z=-z;
end

for i=1:Tm
   if negrow(i) 
      y(i)=-y(i);
   end
   if negvar(basis(i))~=0 & negvar(basis(i))<=j_reg
      Tx(negvar(basis(i)))=-Tx(basis(i));
      Unbdd(negvar(basis(i)))=-Unbdd(basis(i));
   end
end

x=Tx(1:j_reg);
Unbdd=Unbdd(1:j_reg);

% PRINT INFORMATION ABOUT ARTIFICIAL VARIABLES

for i=1:Tm
   if basis(i)>j_unr
      if Tx(basis(i))>epsilon
         sprintf('constraint %d still violated by amount %4.1f',basis(i)-j_unr,Tx(basis(i)))
      else
         sprintf('(row %d is redundant)',basis(i)-j_unr)
      end
   end
end
%  PRINT TABLEAU INFORMATION

%fprintf('***********************START PASSED INFORMATION*************************');
%fprintf('\n\nBASIS\n\n');
%fprintf('%d ',basis);
M;
Binv;
%fprintf('\n\nFINAL ARTIFICIAL TABLEAU\n\n');
%[[Abar Bbar]; cR z]

switch status
   
case 'optiml'
 %  fprintf('\n\nLinear Program is optimal\n\n');
 %  fprintf('optimal solution\n');
   x;
 %  fprintf('objective\n');
   z;
 %  fprintf('dual variables\n');
   y;
case 'infeas'
 %  fprintf('\n\nLinear Program is infeasible\n\n');
 %  fprintf('surrogate constraint row multipliers\n');
 %  y;
case 'unbdd '
 %  fprintf('\n\nLinear Program is unbounded\n\n');
 %  fprintf('final solution\n');
 %  x;
 %  fprintf('unbounded direction \n');
 %  Unbdd(1:j_reg);
end
