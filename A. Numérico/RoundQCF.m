
% RoundQCF.m by David Terr, Raytheon Inc., 7-19-04

% RoundQCF(d,u,v,quiet) returns the round continued fraction
% expansion of x=(u+sqrt(d))/v for Gaussian integers d and u and integer v, with d nonsquare. 
% Round continued fractions are analogous to simple continued fractions except that the
% remainder at each step is rounded to the nearest integer instead of taking the floor. 
% Half-integers are rounded to the nearest integer with least absolute value. 
% The fourth argument quiet may be 0 or 1. If quiet is 0, the preperiod and
% period are printed out before the program terminates.

% Two cells are returned, the first with the preperiod and the second with the period.

% Modified on 7-29-04: Each cell now has 5 columns. As before, the first
% cell corresponds to the preperiod and the second to the period. The first
% column of each cell contains the round continued fraction coefficients. The
% second and third columns contain the numerators and denominators of the
% round rational convergents respectively. The fourth and fifth columns are u(k) and v(k) 
% respecively, where the recripicol of the remainder at each step has the
% form x(k) = (u(k)+sqrt(d))/v(k). 

% For a longwinded discussion of the relevance of all this, see the
% documentation at the top of QCF.m.

% Related files: QCF.m, cfrac.m, and roundcfrac.m


function qcf = RoundQCF(d,u,v,quiet)

qcf = cell([1 2]);

% Error checking
if ( d ~= myround(d) || u ~= myround(u) || v ~= myround(v) ) 
    error('All arguments must be Gaussian integers.');
    return;
end

if ( floor(sqrt(d)) == sqrt(d) )
    qcf{1} = roundcfrac(u+sqrt(d)/v,100);
    qcf{2}=[];
    return;
end

if ( imag(v) ~= 0 || v == 0 )
    error('Third argument must be a nonzero integer.');
    return;
end

% Initialize parameters
g = gcd( round(abs(d - u^2)), v );
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
    a(k) = myround( ( U0 + sqrt(D) ) / V0 );
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
qcf{1} = res(1:s-2,:);      % preperiod
qcf{2} = res(s-1:k,:);      % period

if ~quiet
    ['Preperiod: ', num2str(app)]
    ['Period: ', num2str(ap)]
end

function mr = myround( x )

mr = round( x );

if ( x - floor( x ) == 0.5 )
    if ( x > 0 ) 
        mr = mr - 1;
    else
        mr = mr + 1;
    end
end


function cr = complexround( x )

cr = myround( real(x) ) + i * myround( imag(x) );
