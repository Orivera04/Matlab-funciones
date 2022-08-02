function [zm,er] = polyroots(p)
%   *** A polymonial with Multiple roots ***
%     Solved via partial fraction expansion
%     Compute overall error of original polynomial.
%     F C Chang 12/30/08;  updated 04/29/09
       d = polyder(p);               
       g = polygcd(p,d);
       u = deconv(p,g);
       v = deconv(d,g);
       w = polyder(u);
       z = roots(u);
       m = round(abs(polyval(v,z)./polyval(w,z)));
       zm = [z,m];           % p,d,g,u,v,w,z,m,zm
       pz = polyget([m,-z,ones(length(z),1)])*p(1);
       er = norm(pz-p)/norm(p);           % pz,er
 
function g = polygcd(p,q)
%   *** GCD of a pair of polynomials ***
%     by "Monic polynomial subtraction"
%     F C Chang   04/29/09
       n = length(p)-1;  nc = max(find(p))-1;
       m = length(q)-1;  mc = max(find(q))-1;
       nz = min(n-nc,m-mc);
    if nc*mc == 0, g = [1,zeros(1,nz)]; return, end;
       p2 = [p(1:nc+1)];
       p3 = [q(1:mc+1)];
   for k = 1:nc+nc,
       p3 = [p3(min(find(abs(p3)>1.e-6)):   ...
                max(find(abs(p3)>1.e-6)))];
       p1 = [p2/p2(1)];             % k,p1,
       p2 = [p3/p3(1)];
       p3 = [p2,zeros(1,length(p1)-length(p2))]  ...
           -[p1,zeros(1,length(p2)-length(p1))];
    if norm(p3)/norm(p2) < 1.e-3,   break;  end;
   end; 
       g = [p1,zeros(1,nz)];
     
function p = polyget(A)
%  *** A poly coef vector from sub-poly factors ***
%     F C Chang    04/27/09
       p = 1;
   for i = 1:length(A(:,1)),
       q = 1;
   for j = 1:A(i,1),
       q = conv(q,A(i,max(find(A(i,:))):-1:2));
   end;
       p = conv(p,q);
   end;

