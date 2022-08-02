% Compute the Jacobi symbol (a/b), where a and b are integers with b odd and positive.
% When b=p is prime, this is equal to the Legendre symbol, which is 1 if a is a 
% quadratic residue modulo p, -1 if a is a quadratic nonresidue modulo p, and 0 if a divides p.

%  Inputs:  

%   Name            Type        Size        Comment             Default
%                                                               value
%   -----           -----       -----       ----------          -------

%   a               int         1 x 1       first argument      arbitrary
%   b               int         1 x 1       second argument     odd and
%                                           (modulus if prime)      positive

%  Outputs:  

%   Name            Type        Size        Comment             
%                                                               
%   -----           -----       -----       ----------         

%   js              float       1 x 1       Jacobi symbol    

function js = JacobiSymbol(a,b)

if b <= 0                   % b negative
    fprintf('Error: The second argument should be a positive odd number.\n');
    js = -2;
    return;
elseif mod(b,2) == 0        % b even
    fprintf('Error: The second argument should be a positive odd number.\n');
    js = -2;
    return;
elseif mod(a,b) == 0 
    js = 0;
    return;
elseif a == 1
    js = 1;
    return;
elseif a == -1
    js = (-1)^((b-1)/2);
    return;
elseif a == 2
    js = (-1)^((b^2-1)/8);
    return;
else

    % If a<0, negate it and multiply Jacobi symbol by appropriate factor
    if a < 0
        js = (-1)^((b-1)/2) * JacobiSymbol(-a,b);
        return;
    end
    
    % Reduce a mod b if necessary so that 2|a| < b
    if 2*a > b
        k = floor((2*a + b)/(2*b));
        a = a - k*b;
        js = JacobiSymbol(a,b);
        return;
    end
   
    prime_factors = factor(a);
    p = prime_factors(1);   % smallest prime factor of a
    len = length(prime_factors);
    
    if len == 1
        % Swap a and b and use quadratic reciprocity
        t = a;
        a = b;
        b = t;
        js = (-1)^((a-1)*(b-1)/4) * JacobiSymbol(a,b);
        return;
   else
        e = 1;
        done = 0;
    
        % Determine the largest integer e such that p^e divides a
        while e <= len && ~done
        
            if prime_factors(e) == p;
                e = e + 1;
            else
                done = 1;
            end
            
        end
    
        % Cast out the largest power of p^2 dividing a
        e = e - 1;
        a = a/p^(e-mod(e,2));
        e = mod(e,2);
        
        if e == 1
            js = JacobiSymbol(p,b) * JacobiSymbol(a/p,b);
            return;
        else
            js = JacobiSymbol(a,b);
            return;
        end

    end
    
end