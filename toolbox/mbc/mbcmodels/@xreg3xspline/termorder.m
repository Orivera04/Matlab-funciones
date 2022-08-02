function [NewOrder,numorder,orderlabels]= termorder(m)
% xreg3xspline/EVAL evaluate xreg3xspline model
%
% y= eval(m,x)
% This code is vectorised and expects an nxm matrix where n is the number of data 
% points and m is the number of factors. The algorithm used in this function uses 
% PHI functions and a nested form for the cubic.
%
% This is normally called from MODEL/SUBSREF rather than called directly.
% MODEL/SUBSREF does all model transformations.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:44:25 $



   
% Calculate PHI functions for first variable

Ns = length(m.knots)+m.poly_order+1;
N  = order(m.cubic);

ord= ones(size(m,1),1);


ord(1:Ns)=0;
i3 = 1 + Ns;
for i=1:N(1)
   if m.interact>=1
      % Xi * PHI terms
      ord(i3:i3+Ns-1)=1;
      i3 = i3 + Ns;
   else
      % X(i+1) * [1 X1 X1^2] Terms
      ord(i3:i3+2)=[3 6 6]';
      i3 = i3 + 3;
   end
   for j=i:N(2)
      if m.interact>=2
         % X(i+1) * X(j+1) * PHI terms
         ord(i3:i3+Ns-1)=2;
         i3 = i3 + Ns;
      else
         % X(i+1) * X(j+1) * [1 X1]  Terms
         ord(i3:i3+1)=[4 6]';
         i3 = i3 + 2;
      end
      for k=j:N(3)
         % X(i+1) * X(j+1) * X(k+1) terms
         ord(i3)=5;
         i3 = i3 + 1;
      end
   end
end

NewOrder= [find(ord==0) ; find(ord==1) ; find(ord==2) 
   find(ord==3)  ; find(ord==4) ; find(ord==5)
   find(ord==6)];


if nargout>1
   % include number of terms of each order
   for n=0:6
      numorder(n+1)=sum(ord==n);
   end
   orderlabels={'B-splines','B-spline interactions (1)','B-spline interactions (2)',...
         'Linear terms','Second order terms','Third order terms',...
         'Spline factor terms'};
   orderlabels=orderlabels(numorder~=0);
   numorder(numorder==0)=[];
end
