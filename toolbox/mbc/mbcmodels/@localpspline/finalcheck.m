function [B,Wc,OK]= finalcheck(ps,B,DATA,Wc,OK)
%FINALCHECK
%
%  [B,Wc,OK] = FINALCHECK(ps,B,DATA,Wc,OK)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:41:09 $

% post-optimisation processing
% this is necessary to ensure that a maximum (or min) exists.

% DATA must be adjusted for datum before this routine
ps= datum(ps,0);
Ns= size(DATA,3);

% need to go back to quatratic if min/max is not defined
p0= localpoly([1 1 1]);

dType= DatumType(ps);
for i=1:Ns
   if OK(i)
      ps= update(ps,B(:,i));
      d= DATA{i};
      Xs= d(:,1:end-1);
      Ys= d(:,end);
      yhat= eval(ps,Xs-datum(ps));
      Wc{i}= choltinv(covmodel(ps),yhat);
      
      Change= 0;
      switch dType
      case 1
         % Maximum Datum (reset knot to 0)
         % check it is a maximum
         [maxPS,tp]= max(ps);
         if isempty(tp) ; 
            % Make localpspline symmetric
            
            % fit quadratic polynom 
            % *** want to call polynom/leastsq not localmod/leastsq
            [p,OKp]= leastsq(p0,Xs,Ys,Wc{i});
            
            [maxPS,tp]= max(p);
            % there has to be a maximum here as this was an initial check
            % can changing weights change this?
            
            % convert polynom to localpspline
				if ~isempty(tp)
					c= double(p);
					psparams= [tp,maxPS,c(1) zeros(1,ps.order(1)-2) ...
							c(1) zeros(1,ps.order(2)-2)]';
				else
					psparams= NaN;
					OK(i)= false;
				end
				Change= 1;
            
            
         end
         
         
      case 2
         % Minimum Datum (reset knot to 0)
         % check it is a minimum
         [minPS,tp]= min(ps);
         if isempty(tp); 
            
            % fit quadratic polynom 
            [p,OKp]= leastsq(p0,Xs,Ys,Wc{i});
            [minPS,tp]= min(p);
				c=double(p);
				if ~isempty(tp)
					psparams= [tp,minPS,c(1) zeros(1,ps.order(1)-2) ...
						c(1) zeros(1,ps.order(2)-2)]';
				else
					psparams= NaN;
					OK(i)= false;
				end
            
            Change= 1;
            
         end
         
      end  % switch
      
      if Change 
         % need to update B,J,YHAT,res etc
         B(:,i)= psparams;
         if ~isempty(Wc{i}) && OK(i)
            ps= update(ps,psparams);
            yhat= EvalModel(ps,Xs);
            Wc{i}= choltinv(covmodel(ps),yhat,Xs);
         end
      end
   end
end  % for i

