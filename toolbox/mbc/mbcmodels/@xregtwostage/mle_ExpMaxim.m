function TS= mle_ExpMaxim(TS,Xs,Ys,W0s,ProgTable,isNested,TolFun)
% XREGTWOSTAGE/MLE_EXPMAXIM Expectation-Maximization for MLE
% 
%  Global two-stage mle using expectation maximization algorithm for maximum
%  likelihood estimation. Estimates of global parameters and covariance are
%  obtained. A form of Aitken acceleration is implemented to speed
%  convergence. Regularization parameters from the global models are
%  ignored.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.6.4.2 $  $Date: 2004/02/09 07:59:52 $


global status

D= unstruct(TS.covmodel);
if isNested
   b= Ball(TS);
   yhat= Xs*b;

	lam= 0; 
   % used to do modified MLE accounting for ridge parameter: lam = RidgeMatrix(TS);
   % this had issues for large lambda which need more investigation
else
	lam=0;
   b=[];
   yhat= Xs;
end
b=Ball(TS);


Nf= size(D,2);
Ns= length(Ys)/Nf;
Is= repmat(speye(Nf),Ns,1);

Dnorm= norm(D);
Bnorm= norm(b);
count=0;

if ~isempty(ProgTable)
	ah= ProgTable{1};
	delete(get(ah,'children'))
   set(get(ah,'title'),'string','logL vs Iteration');
end

Bcost=0;
U= logical( triu(ones(size(D))) );
Theta= zeros(sum(U(:)),0);

% main loop
status=0;
cost = Inf;
logL= -Inf;
Progress=[];
AikUpdate= 0;
while cost>TolFun & count<1000 & ~status
   
   OldCost= logL;
   
   Dold= D;
   
   
   % make blk diag matrix of d's
   Ds= spblkdiag(repmat(D,[1,1,Ns]));
   if ~AikUpdate
      Wci= choltinv(TS.covmodel,W0s);
   end
   
   
   % Expectation step
   Bi= yhat + Ds*(Wci'*(Wci*(Ys-yhat)));
      
      
   % Maximisation Step
   if isNested
      % Part 1: update parameters 
      Bold= b;
      Dc= chol(D);
 		s= diag(Dc);
		if max(s)/min(s)>1e8
			% rescale for badly conditioned problems
			s= diag(1./s);
			Dc= Dc*s;
			Wc= spblkdiag( repmat((s*inv(Dc))',[1,1,Ns]) );
		else
			Wc= spblkdiag(repmat( inv(Dc)',[1,1,Ns] ));
		end
		
		b= xreglsq(Wc*Xs,Wc*Bi,lam);
      
      yhat= Xs*b;
      
      Bcost= norm(Bold-b)/Bnorm;
   end
   
   % update covariance estimate
   ci = reshape(Bi-yhat,Nf,Ns);
   dw= (Wci*Is)*D;
   D  = D + (ci*ci' - dw'*dw)/Ns;
   
	deig= (eig(D));
	k=1;
	while min(deig)<2*eps*max(deig) & k< 10
      % keep D +ve definite
      dmax= 2*eps*max(deig);
      D= D+ dmax*eye(size(D));
		deig= (eig(D));
		k=k+1;
   end
	
   wr= Wci*(Ys-yhat);
   logL= sum(log(diag(Wci))) - sum(wr.*wr)/2;
   
   if AikUpdate & logL<OldCost
      % aitken didn't improved logL so jump back to previous iteration
      D= DnonAik;
      cost= Inf;
   else
      ca= covupdate(TS.covmodel,D);
      Theta= [double(ca) Theta];
      ustr= 'EM Update';
      AikUpdate= 0;
      if count > size(Theta,1) 
         dth= Theta(:,1:end-1)-Theta(:,2:end);
         if count > size(Theta,1) & cond(dth(:,2:end))<1e8
            Jlam= dth(:,1:end-1)/dth(:,2:end);
            th= Theta(:,2)  + (eye(size(Theta,1))-Jlam)\dth(:,1);
            howStr= sprintf('Jacobian');
         else
            dok= dth(:,2)~=0;
            if any(dok)
               lambda= sum(dth(dok,1)./dth(dok,2))/sum(dok);
            else
               lambda= 0.001;
            end
            % lambda= min(max(lambda,0.001),0.999);
            th= Theta(:,2)  + (1-lambda)\dth(:,1);
            howStr= sprintf('Lambda= %5.3f',lambda);
         end
         % delete last column
         Theta(:,end)= [];
         
         ca= update(ca,th);
         Da= unstruct(ca);
         Wci= choltinv(ca,W0s);
         wr= Wci*(Ys-yhat);
         logLa= sum(log(diag(Wci))) - sum(wr.*wr)/2;
         if logLa>logL
            AikUpdate= 1;
            DnonAik= D;
            D= Da;
         end
      end
      % cost for convergence
      cost= abs((logL-OldCost)); % norm(Dold-D)/Dnorm + Bcost;
      dstr= sprintf('|B|=%10.4g, |D|=%10.4g, logL=%10.4g ',norm(b),norm(D),logL);
      
      count= count+1;
      Progress= [Progress;logL];
      if ~isempty(ProgTable)
         % show progress
         plot(1:count,Progress,'parent',ah);
         set(get(ah,'title'),'string','logL vs Iteration');
         set(ProgTable{2},'string',dstr);
         % i_Progress(prh,[count,cost,norm(D),norm(b)],Dnorm,Bnorm);
      end
      drawnow
   end
   
   % update covmodel
   TS.covmodel= covupdate(TS.covmodel,D);
   
end % while loop

if ~isempty(b)
   TS= mleparams(TS,b);
end



function b=Ball(TS)
b=[];
for i=1:length(TS.Global)
   b= [b;linparameters(TS.Global{i})];
end


% ---------------------------------------------------
% Display progress information in a table object
% ---------------------------------------------------
function i_Progress(prh,mat,Dnorm,Bnorm); 

X= get(prh(1),'xdata');
D= get(prh(1),'ydata');
B= get(prh(2),'ydata');

X= [X mat(1)];
D= [D mat(3)/Dnorm];
B= [B mat(4)/Bnorm];

set(prh(1),'xdata',X,'ydata',D);
set(prh(2),'xdata',X,'ydata',B);

drawnow
