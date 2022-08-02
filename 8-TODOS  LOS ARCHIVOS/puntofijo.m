function [k,p,errabs,P] = puntofijo(g,p0,tol,maxiter)
%programa para resolver ecuaciones usando punto fijo
P(1) = p0;
for k=2:maxiter;
    P(k) = feval(@g,P(k-1));
    errabs = abs(P(k)-P(k-1));
    errelat = errabs/(abs(P(k)+eps));
    p = P(k);
    if (errabs < tol) | (errelat < tol),break; end
end
if k == maxiter
    disp('superado el maximo No. de iteraciones')
end
P = P';