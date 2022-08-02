function [b] = sollu (L, U, P, Q, b)
warnstat(1) = warning('query','MATLAB:singularMatrix');
warnstat(2) = warning('query','MATLAB:nearlySingularMatrix');
warnoff = warnstat;
warnoff(1).state = 'off';
warnoff(2).state = 'off';
warning(warnoff);
    if issparse(L)
%       [L,U,P,Q] = lu(A);            
       b = Q * (U \ (L \ (P * b)));      
    else
%       [L,U,P] = lu(A);      
       b = U \ (L \ (P * b));
    end 
    warning(warnstat);
% if (~(n == 1))
%     nm1 = n - 1;
%     for k = 1:nm1
%         kp1 = k + 1;
%         m = ip(k);
%         t = b(m);
%         b(m) = b(k);
%         b(k) = t;
%         for i = kp1:n
%             b(i) = b(i) + a(i,k)*t;
%         end
%     end
%     for kb = 1:nm1
%         km1 = n - kb;
%         k = km1 + 1;
%         b(k) = b(k)/a(k,k);
%         t = -b(k);
%         for i = 1:km1
%           b(i) = b(i) + a(i,k)*t;
%         end
%     end
%     b(1) = b(1)/a(1,1);
%     return;
% else
%       b(1) = b(1)/a(1,1);
% end