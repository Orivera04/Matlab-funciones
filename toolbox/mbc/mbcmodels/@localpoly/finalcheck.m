function [B,Wc,OK]= finalcheck(poly,B,DATA,Wc,OK);
% POLYNOM/FINALCHECK

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:40:23 $

% post-optimisation processing
% this is necessary to ensure that a maximum (or min) exists.

Ns= size(DATA,3);
dType= DatumType(poly);
if isempty(Wc)
   Wc= cell(1,Ns);
end
np= size(B,1);

for i=1:Ns
   if OK(i)
      d= DATA{i};
      Xs= d(:,1:end-1);
      Ys= d(:,end);
      
      poly= setstatus(poly,1:np-2,3);
      % make sure datum is at zero
      poly= update(poly,B(:,i),0);
      
      Change= 0;
      
      tp=0;
      switch dType
      case 1  
         % max tp datum
         DatumHat=NaN;
         [dum,tp]= max(poly);
         DatumOk= ~(isempty(tp) | ~isreal(tp) | length(tp)>1);
         % no maximum | complex maxima | more than one maxima
         redorder=0;
         while ~DatumOk & order(poly)>2 
            % reduce order
            % poly= update(poly,ones(order(poly),1),0);
            redorder= redorder+1;
            poly= setstatus(poly,redorder,2);
            [poly,ok]= leastsq(poly,Xs,Ys,Wc{i});
            [dum,tp]= max(poly);
            DatumOk= ~(isempty(tp) | ~isreal(tp) | length(tp)>1);
            Change= 1;
         end
         if ~DatumOk;
            OK(i)= false;
         end
      case 2  
         % min tp   
         [dum,tp]= min(poly);
         DatumOk= ~(isempty(tp) | ~isreal(tp) | length(tp)>1);
         % no maximum | complex maxima | more than one maxima
         redorder=0;
         while ~DatumOk & order(poly)>2 
            % reduce order
            redorder= redorder+1;
            poly= setstatus(poly,redorder,2);
            [poly,ok]= leastsq(poly,Xs,Ys,Wc{i});
            [dum,tp]= min(poly);
            DatumOk= ~(isempty(tp) | ~isreal(tp) | length(tp)>1);
            Change= 1;
         end
         if ~DatumOk;
            OK(i)= false;
         end
      end
   end
   
   if Change   
      p= double(poly);
      % p= [zeros(size(B,1)-length(p),1); p];
      B(:,i)= p;
      if ~isempty(Wc{i})
         poly= update(poly,p);
         yhat= EvalModel(poly,Xs);
         Wc{i}= choltinv(covmodel(poly),yhat,Xs);
      end
   end
end

