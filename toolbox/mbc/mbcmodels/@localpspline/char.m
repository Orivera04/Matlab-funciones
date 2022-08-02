function c=char(qs,TeX)
% QUADSPLINE/CHAR char converter

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:40:58 $




if nargin==1
   TeX=1;
end

s= get(qs,'symbol');
var=s{1};
if TeX
   var= detex(var);
end

varp=['(',s{1},'-k)'];

plo= localpoly(qs.polylow,[],[]);
phi= localpoly(qs.polyhigh,[],[]);

cq1=['  ',char(plo,0,varp)];
cq2=['  ',char(phi,0,varp)];
c2 = ['   if ',var,' <= k'
      '   if ',var,' >  k'];
c3= [' where k = ',sprintf('%.3g',qs.knot+datum(qs))];


c=[ char({cq1 ;cq2}) c2];
c= [c [blanks(size(c3,2)-size(c,2)) ; blanks(size(c3,2)-size(c,2))]
   [c3 blanks(size(c,2)-size(c3,2))]];
   
