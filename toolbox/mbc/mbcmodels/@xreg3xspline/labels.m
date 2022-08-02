function L=labels(m,TeX,reord)
% xreg3xspline/LABELS Term Labels for xreg3xspline model
%
% L=labels(m)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:43:30 $



if nargin<2
   TeX= 1;
end

% Number of PHI terms
Ns = length(m.knots) + m.poly_order + 1;
% cubic order
N  = order(m.cubic);

% Label for spline variable
labs= get(m,'symbol');
Ls= labs{m.splinevar};
labs(m.splinevar)=[];

m.cubic=set(m.cubic,'symbol',labs);
L3= labels(m.cubic,TeX,0);

% Make labels for B-Spline terms. This uses TeX expressions
% to make pretty labels for graphical display  (\phi_i).
PHI = [];
if TeX
   for i=1:Ns
      PHI = [PHI ; {sprintf('\\phi_{%d}',i)} ];
   end
else
   for i=1:Ns
      PHI = [PHI ; {sprintf('Phi_%d',i)} ];
   end
end

pos=1;  % Index to cubic label
L = PHI;
for j=1:N(1)
   pos=pos + 1;
   if m.interact>=1
      % Xi * PHI terms
      L = [L ; i_LabelMult(PHI,L3{pos}) ];
   else
      % Xi * [1 X1 X1^2] terms 
      L = [L ; L3(pos); {[Ls,'*',L3{pos}]; [Ls,'^2*',L3{pos}]}];
   end
   for k=j:N(2)
      pos=pos + 1;
      if m.interact>=2
         % Xi * Xj * PHI terms
         L = [L ; i_LabelMult(PHI,L3{pos}) ];
      else
         % Xi * Xj * [1 X1] terms 
         L = [L ; L3(pos) ; {[Ls,'*',L3{pos}]}];
      end
      for i=k:N(3)
         % Xi * Xj * Xk  terms 
         pos=pos+1;
         L = [L ; L3(pos)];
      end
   end
end

if nargin<3 | ( nargin>2 & reord)
	L= L(termorder(m));
end

%----------------------------------------------------------------
% subfunction i_LabelMult
%----------------------------------------------------------------
function L=i_LabelMult(PHI,L3);
% Produces all phi_i*L3 terms

L= cell(size(PHI));
for i=1:length(PHI)
   L{i} = [PHI{i},'*',L3];
end