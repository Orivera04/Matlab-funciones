function C=DrawProduct(iA,iB,p)
%DrawProduct(A,B,p): draw a product.
% A,B: multivectors from which to form the product.
% p: string declaring type of product.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

clf;
A = GAZ(iA);
B = GAZ(iB);

if strcmp(p,'inner')
  C = inner(A,B);
elseif strcmp(p, 'wedge')
  C = A^B;
elseif strcmp(p, 'geometric')
  C = A*B;
elseif strcmp(p, 'spinor')
  C = inverse(A)*B*A;
end

set(gcf,'Name',p);

if GAisa(A,'multivector') | GAisa(B,'multivector')
    subplot(1,3,1);
    draw(A);
    if isa(A,'double') | GAisa(A,'double')
      a = [0 0 0 0 0 0];
      axis('equal')
    else
      a = axis;
    end
    subplot(1,3,2);
    draw(B);
    if isa(B,'double') | GAisa(B,'double')
      b = [0 0 0 0 0 0];
      axis('equal')
    else
      b = axis;
    end
    subplot(1,3,3);
    draw(C);
    if isa(C,'double') | GAisa(C,'double')
      c = [0 0 0 0 0 0];
      axis('equal')
    else
      c = axis;
    end
    for i=1:2:5
      d(i) = min([a(i),b(i),c(i)]);
      d(i+1) = max([a(i+1),b(i+1),c(i+1)]);
    end
    subplot(1,3,1);axis(d);
    subplot(1,3,2);axis(d);
    subplot(1,3,3);axis(d);
else
    subplot(1,2,1);
    draw(A,'b');
    draw(B,'g');
    if isa(A,'double') & GAisa(B,'double')
      a = [0 0 0 0 0 0];
      axis('equal')
    else
      a = axis;
    end
    subplot(1,2,2);
    draw(C,'r');
    if isa(C,'double') | GAisa(C,'double')
      b = [0 0 0 0 0 0];
      axis('equal')
    else
      b = axis;
    end
    for i=1:2:5
      d(i) = min([a(i),b(i)]);
      d(i+1) = max([a(i+1),b(i+1)]);
    end
    subplot(1,2,1);axis(d);
    subplot(1,2,2);axis(d);
end
