function ps= update(ps,p,dat);
% localpspline/UPDATE update localpspline parameters (and datum)
%
% ps= update(ps,p,dat);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:41 $


p= p(:);

if nargin<3
   switch DatumType(ps)
   case {1,2}
      % knot is at datum
      ps.knot=0;
      ps= datum(ps,p(1));
   case 3
      ps.knot = p(1)-datum(ps);
   otherwise
      ps.knot= p(1);
      % ps= datum(ps,0);
   end
else
   if ~isempty(dat)
      ps.knot = p(1)-dat;
      ps = datum(ps,dat);
   else
		if DatumType(ps)
			ps.knot = p(1)-datum(ps);
		else
			ps.knot = p(1);
		end
   end
end

%phi= p(qs.order(1)+1:-1:3);
%plo= p(end:-1:qs.order(1)+2);
ps.polyhigh  = [p(ps.order(1)+1:-1:3)  ; 0 ;  p(2)];
ps.polylow   = [p(end:-1:ps.order(1)+2); 0 ; p(2)];
