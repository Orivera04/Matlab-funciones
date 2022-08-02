function TS= mle_ExpMaxim(TS,Xs,Ys,W0s,ProgTable)
% TWOSTAGE/MLE_EXPMAXIM Global Twostage MLE using Expectation-Maximisation Algorithm 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:54 $


global STOP


D= unstruct(TS.covmodel);
b= Ball(TS);

Nf= size(Yrf,2);
Ns= size(Yrf,1);
Is= repmat(eye(Nf),Ns,1);

Dnorm= norm(D);
Bnorm= norm(b);
cost=1;
count=0;


set(ProgTable{1},'rows.number',1,...
   'cols.number',4);
ProgTable{1}.redraw;
set(ProgTable{2},'string','Stage 1: Expectation Maximisation')
ProgTable{1}(0,:).String= {'Iteration','Delta','norm(D)','norm(B)'};
STOP=0;
while cost>1e-3 & count<1000 & ~STOP
   
   
   Bold= b;
   Dold= D;
   
   
   % make blk diag matrix of d's
   Ds= spblkdiag(repmat(D,[1,1,Ns]));
   
   % sparse diag
   %W= cov(TS.covmodel,W0s);
   Wci= choltinv(TS.covmodel,W0s);
   
   % Expectation Step
   Bi= Xs*b + Ds*Wci'*(Wci*(Ys-Xs*b));
   
   % Maximisation Step
   
   % Part 1: update parameters 
   Wc= chol(Ds)';
   b= (Wc\Xs)\(Wc\Bi);

   ci = reshape(Bi-Xs*b,Nf,Ns);
   dw= Wci*Is*D;
   D  = D + (ci*ci' - dw'*dw)/Ns;
   
   % update covmodel
   TS.covmodel= covupdate(TS.covmodel,D);
   

   % cost for convergence
   cost= norm(Dold-D)/Dnorm + norm(Bold-b)/Bnorm;
   
   count= count+1;
   
   i_Progress(ProgTable{1},[count,cost,norm(D),norm(b)]);
   
end

TS= mleparams(TS,Bmle);



function b=Ball(TS)
b=[];
for i=1:length(TS.Global)
   b= [b;parameters(TS.Global{i})];
end


% ---------------------------------------------------
% Display progress information in a table object
% ---------------------------------------------------
function i_Progress(T,mat); 
T.rows.number=T.rows.number+1;
T(end,[1]).cells.format='%3d';
T(end,[2:4]).cells.format='%0.5g';
T(end,:).horizontalalignment= 'right';

T(end,:).Values=mat;
if T.rows.number>7 % number of showable rows in the table
   T.vslider.value=T.rows.number-6;
end
drawnow
