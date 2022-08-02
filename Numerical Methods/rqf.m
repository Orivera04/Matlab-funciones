
% rqf.m by David Terr, Raytheon, 11-17-04

% Reduce a quadratic form, given as a length-3 row vector. 
% Return reduced form and 2x2 matrix which generates it from initial form.

% Reference: H. Cohen, "A Course in Computational Algebraic Number Theory",
%               Springer-Verlag, Vol. 138 (1993), p. 238 (Algorithm 5.4.2)
%               for the imaginary case and pp. 257-8 for the real case.

function f1 = rqf(f)

% Initialization
f1 = cell([1 2]);
M = zeros(2);
M(1,1) = 1;
M(2,2) = 1;

% Make sure input has the right size.
if ( size(f) ~= [1 3] )
    error('Input needs to be a row vector of length 3.');
    return;
end

a = f(1);
b = f(2);
c = f(3);

D = b^2 - 4*a*c; % discriminant

% Reduce form.

if D > 0    % real case
    sqrtd = sqrt(D);
    tried = 0;
    absc = abs(c);
    llim = abs(sqrtd - 2*absc);
    
    while ~tried || b < llim || b > sqrtd       % form is not reduced yet
        tried = 1;
    
        if absc > sqrtd
            t = round(-b/(2*absc));
        else
            t = round((-b-sqrtd+absc)/(2*absc));
        end
    
        t1 = t * absc / c;
        r = -b - 2*c*t1;
        M = M * [0 -1; 1 -t1];
        
        a = c;
        b = r;
        c = (r^2 - D)/(4*c);
        absc = abs(c);
        llim = abs(sqrtd - 2*absc);
    end
    
else        % imaginary case
    
    % Make sure leading coefficient is positive.
    if a < 0
        a = -a;
        b = -b;
        c = -c;
    end

    while b == -a || abs(b) > a || a > c || ( a == c && b < 0 )
    
        if b == -a || abs(b) > a    % rho
        
            if abs(b) > a 
                r = round(b/(2*a));
            else
                r = -1;
            end
        
            b2 = b - 2*r*a;
            c = c - r*b + r^2*a;
            b = b2;
            M = M * [1 -r; 0 1];
        
        else    % sigma
            a2 = c;
            b2 = -b;
            c = a;
            b = b2;
            a = a2;
            M = M * [0 -1; 1 0];
        end
        
    end
    
end

f1{1} = [a b c];
f1{2} = M;
