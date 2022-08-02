function x=code(m,x,factnum);
% XREGMODEL/CODE perform coding transformation on model [Min,Max] -> [-1,1]
%
% x= code(m,x)
% x= code(m,x,factornum) codes all the values in x using the coding for
% the factor specified.  Several factor numbers may be specified, so long 
% as there are the same number of columns in x.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:51:30 $



if isempty(x)
   return
end

if ~isempty(m.code) 
   if nargin<3
      factnum=1:size(x,2);
   else
      % set up a full x matrix with the specified columns filled;
      nf=nfactors(m);
      if length(factnum)~=size(x,2) | length(m.code)~= nf
         error('The number of factors and the size of x do not match!');
      end
      if any(factnum>nf | factnum<1)
         error('The number of factors and the size of x do not match!');
      end
      smallx=x;
      x=zeros(size(smallx,1),nf);
      x(:,factnum)=smallx;
   end
   % New code structure 
   for i=factnum;
      c= m.code(i);
      if isfinite(c.range)
         % c.range is set to Inf if coding is 1:1
         if isempty(c.g)
            % no nonlinear transformation
            x(:,i)= (x(:,i) - c.mid)/(c.max-c.min)*c.range;
         else
            % g is an inline object
            x(:,i)= (c.g(x(:,i)) - c.mid)/(c.max-c.min)*c.range;
         end
      else
         if ~isempty(c.g)
            % allow a transform
            x(:,i)= c.g(x(:,i));
         end
         if isfinite(c.mid)
            x(:,i)= x(:,i)-c.mid;
         end
      end
   end
   if nargin>2
      % extract just the columns that were passed in
      x=x(:,factnum);
   end 
end



