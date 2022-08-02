function [y,p]= reconstruct(m,Yrf,x,dat);
% LOCALTRUNCPS/RECONSTRUCT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:43:11 $

dG= delG(m)';
f= get(m,'features');
rfindex= [f.index];
nlin= sum(~[f.IsLinear]);
nk= length(m.knots);
if nlin==0 | nlin==nk
   p= Yrf/dG;
else
   p=Yrf;
end


% make sure knots are sorted and coded
if ~allLinearRF(m)
   for i=1:nk
      % linear reconstruction has scaled knots
      ind= find(rfindex==i);
      if ~isempty(ind)
         % natural knots are  not linear
         p(:,i)= code(m,Yrf(:,ind));
      end
   end
end
p(:,1:nk)= sort(p(:,1:nk),2);

y= zeros(size(Yrf,1),1);
if size(p,1)==size(x,1)
   for i= 1:size(y,1) 
      if nlin>nk
         % function value rfs
         m.knots= p(i,1:nk);
         dG= delG(EvalDelG(m));
         pi= Yrf(i,:)/dG';
         p(i,:) = [p(i,1:nk) pi(nk+1:end)];
      end
      L= update(m,p(i,:));

      y(i) = eval(L,x(i) ) ;
   end
else
   if nlin>nk
      % have to set knots
      m.knots= p(1,1:nk);
      dG= delG(EvalDelG(m));
      pi= Yrf/dG';
      p= [p(1,1:nk) pi(nk+1:end)];
   end
   L= update(m,p(1,:));
   y = eval(L,x ) ;
end