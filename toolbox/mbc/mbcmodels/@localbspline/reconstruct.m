function [y,p]= reconstruct(m,Yrf,x,dat);
% LOCALBSPLINE/RECONSTRUCT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:38:21 $

dG= delG(m)';

f= get(m,'features');
rfindex= [f.index];
nlin= sum(~[f.IsLinear]);
nk= get(m.xreg3xspline,'numknots');
if nlin==0 | nlin>nk
   p= Yrf/dG;
else
   p=Yrf;
end

% make sure knots are sorted and coded
if ~allLinearRF(m)
   % natural knots are  not linear
   for i=1:nk
      % linear reconstruction has scaled knots
      ind= find(rfindex==i);
      if ~isempty(ind)
         %parameters are in coded values
         p(:,i)= code(m,Yrf(:,ind));
      end
   end
end
p(:,1:nk)= sort(p(:,1:nk),2);
% make sure knots are inbetween limits
Tgt=gettarget(m,1);
TOL= sqrt(eps)*max(abs(Tgt));
p(:,1:nk)= max(p(:,1:nk),Tgt(1)+TOL);
p(:,1:nk)= min(p(:,1:nk),Tgt(2)-TOL);





if size(p,1)==size(x,1)
   y= zeros(size(Yrf,1),1);
   for i= 1:size(y,1) 
      if nlin>nk
         m= set(m,'knots',p(i,1:nk));
         dG= delG(EvalDelG(m));
         pi= Yrf(i,:)/dG';
         p(i,:)= [p(i,1:nk) pi(nk+1:end)];
      end
      L= update(m,p(i,:));
      y(i) = eval(L,x(i) ) ;
   end
else
   if nlin>nk
      % have to set knots
      m= set(m,'knots',p(1,1:nk));
      dG= delG(EvalDelG(m));
      pi= Yrf/dG';
      p= [p(1,1:nk) pi(nk+1:end)];
   end
   L= update(m,p);
   y = eval(L,x ) ;
end