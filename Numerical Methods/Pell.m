% Pell.m by David Terr, 7-29-04
% Given integers d, s, and n with d and n positive and d nonsquare, return the smallest solution [x y]
% to the modified Pell's equation: x^2 - d*y^2 = (-1)^s. There is always a
% solution for even s (equiv. to s=0) but there may not be one for odd s (equiv. to s=1).

% Warning: This may not work if d is too large.


function p = Pell(d,s,n)

% Error checking
if ( imag(d) ~= 0 || d ~= floor(d) || d < 0 || floor(sqrt(d)) == sqrt(d) ) 
    error('First argument must be a nonsquare positive integer.');
    return;
end

% Error checking
if ( s ~= floor(s) ) 
    error('Second argument must be an integer.');
    return;
end

% Initialization
p = zeros(n,2);
smod2 = mod(s,2);
q = qcf(d,0,1,1);
q1 = q{1};
q2 = q{2};

s1 = size(q1);
s2 = size(q2);
size1 = s1(1);
size2 = s2(1);

if size2 > 1
    x1 = q2(size2-1,2);
    y1 = q2(size2-1,3);
else
    x1 = q1(size1,2);
    y1 = q1(size1,3);
end

% Compute fundamental solution if one exists.
if mod(size2,2) == 1
    if smod2 == 0
        x = x1^2 + d*y1^2;
        y = 2*x1*y1;
    else
        x = x1;
        y = y1;
    end
else  
    if smod2 == 1
        ['There are no solutions to the equation x^2 - ', num2str(d),' y^2 = -1.']
        p = [];
        return;
    else
        x = x1;
        y = y1;
    end
end

p(1,1) = x;
p(1,2) = y;

% Compute additional solutions.
x0 = x;
y0 = y;

for k = 2:n
    for r = 0:smod2
        x1 = x*x0 + d*y*y0;
        y1 = y*x0 + x*y0;
        x = x1;
        y = y1;
        p(k,1) = x;
        p(k,2) = y;
    end
end
    
