
% QCF.m by David Terr, Raytheon Inc., 7-19-04

% QCF(d,u,v) returns the continued fraction expansion of x=(u+sqrt(d))/v 
% for integers d, u, and v, with d and v positive and d nonsquare. 
% Two cells are returned, the first with the preperiod and
% the second with the period.


% Modified on 7-29-04: 

% This file was formerly called QuadraticContinuedFraction.m
% but I shortened the name to QCF.m. Each cell now has 5 columns. As before, the first
% cell corresponds to the preperiod and the second to the period. The first
% column of each cell contains the continued fraction coefficients. The
% second and third columns contain the numerators and denominators of the
% rational convergents respectively. The fourth and fifth columns are u(k) and v(k) 
% respecively, where the recripicol of the remainder at each step has the
% form x(k) = (u(k)+sqrt(d))/v(k). I also added a fourth argument (quiet) to
% QCF. When set to 1, nothing gets printed before the result is returned.


% Warning: You may not want to read the following unless you know some
% algebraic number theory!

% If u=0 and v=1, the quadratic continued
% fraction corresponds to sqrt(d), in which case the next to last
% coefficients of p(k) and q(k) (second and third coefficients in next to
% last row of qcf{2}) are the coefficients a and b respectively
% of the fundamental unit u = a + b*sqrt(d) of the number ring Z[sqrt(d)].
% For instance, the fundamental unit of Q(sqrt(19)) is 170 + 39*sqrt(19).
% Similarly, for d of the form 4*k+1, the fundamental unit of the number field Q(sqrt(d)) is
% u = (a1 + b1*sqrt(d))/2, where a1 and b1 are the second and third
% coefficients in the row preceding the first 4 in the fifth column of
% qcf{2}, or in the last row of qcf{1} if the first 4 occurs in the first
% row of qcf{2}. For instance, the fundamental unit of the number field Q(sqrt(61)) is
% (39 + 5*sqrt(61))/2, while the fundamental unit of Z[sqrt(61)] is
% 29718 + 3805*sqrt(61). If the length of the period of the continued
% fraction is even, (a,b) is the first solution (x,y) to the Pell's equation
% x^2 - d*y^2 = 1; otherwise it is the first solution to the 
% equation x^2 - d*y^2 = -1.

function qc = QCF(d,u,v,quiet)

qc = cell([1 2]);

% Error checking
if ( imag(d) ~= 0 || imag(u) ~= 0 || imag(v) ~= 0 ) 
    error('All arguments must be real.');
    return;
end

if ( d ~= floor(d) || u ~= floor(u) || v ~= floor(v) )
    error('All arguments must be integers.');
    return;
end

if ( floor(sqrt(d)) == sqrt(d) )
    qcf{1}=cfrac(u+sqrt(d)/v,100);
    qcf{2}=[];
    return;
end

if ( d<0 )
    error('First argument must be positive.');
    return;
end

if ( v<0 )
    error('Third argument must be positive.');
    return;
end

% Initialize parameters
g = gcd( d - u^2, v );
C = v / g;
k = 1;
D = C^2 * d;
p1 = 1;
p2 = 0;
q1 = 0;
q2 = 1;
u(1) = C * u;
v(1) = C * v;
done = 0;

while ~done
    U0 = u(k);
    V0 = v(k);
    a(k) = floor( ( U0 + sqrt(D) ) / V0 );
    ak = a(k);
    p(k) = ak*p1 + p2;
    q(k) = ak*q1 + q2;
    p2 = p1;
    q2 = q1;
    p1 = p(k);
    q1 = q(k);
    U = a(k) * V0 - U0;
    V = ( D - U^2 ) / V0;
    res(k,1)=a(k);
    res(k,2)=p(k);
    res(k,3)=q(k);
    res(k,4)=u(k);
    res(k,5)=v(k);
    
    % Look for a match with previously computed values of u(k) and v(k)
    s = 1;
    
    while s <= k && ~done
        if U == u(s)
            if V == v(s)    % match found
                done = 1;
            end
        end
        
        s = s + 1;  
    end
    
    if ~done                % no match found
        k = k + 1;
        u(k) = U;
        v(k) = V;
    end
end

app = a(1:s-2);
ap = a(s-1:k);              
qc{1} = res(1:s-2,:);      % preperiod
qc{2} = res(s-1:k,:);      % period

if ~quiet
    ['Preperiod: ', num2str(app)]
    ['Period: ', num2str(ap)]
end
