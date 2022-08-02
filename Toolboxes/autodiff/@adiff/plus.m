function c = plus(a,b)
% PLUS implements a+b, where either a or b is an adiff object.
% If both a & b are adiff objects, it is assumed that they refer
% to the same set of independent variables.

switch [class(a),class(b)]
   
case 'adiffdouble'
   c = adiff(a.x+b, a.dx, a.root);
   
case 'doubleadiff'
   c = adiff(b.x+a, b.dx, b.root);
   
case 'adiffadiff'
   checkroot(a,b);
   if size(a.dx,1)~=size(b.dx,1)
      if size(a.dx,1)==1
         a.dx = repmat(a.dx,size(b.dx,1),1);
      elseif size(b.dx,1)==1
         b.dx = repmat(b.dx,size(a.dx,1),1);
      end
   end
   c = adiff( a.x+b.x,a.dx+b.dx, a.root);
   
otherwise
   error(['Can''t add ',class(a),' and ',class(b)]);
   
end

