function testMULTIPROD
% TESTMULTIPROD  Testing function MULTIPROD

format compact;

% Initial size of matrices
% (Q = R required, unless Q or R or both are 1)
p=6; q=3;
r=3; s=4;

% 0 singletons
    check ([p q   r s]);

% 1 singleton
      check ([1 q   r s]);
    % check ([p 1   r s]); % Not allowed
    % check ([p q   1 s]); % Not allowed
      check ([p q   r 1]);

% 2 singletons
      check ([1 1   r s]);
      check ([p q   1 1]);
      check ([1 q   r 1]); % inner product
      check ([p 1   1 s]); % outer product
    % check ([1 q   1 s]); % Not allowed
    % check ([p 1   r 1]); % Not allowed

% 3 singletons
    check ([1 1   1 s]);
    check ([1 1   r 1]);
    check ([1 q   1 1]);
    check ([p 1   1 1]);

% 4 singletons
    check ([1 1   1 1]);

% EMPTY MATRICES    
%-------------------------------------------

% 0 singletons
    check ([0 q   r s]);
    check ([p q   r 0]);
    check ([p 0   0 s]);
    check ([0 0   0 s]);
    check ([p 0   0 0]);
    check ([0 0   0 0]);

% 1 singleton
      check ([1 q   r 0]);
      check ([1 0   0 s]);
      check ([1 0   0 0]);
    % check ([p 1   r s]); % Not allowed
    % check ([p q   1 s]); % Not allowed
      check ([0 q   r 1]);
      check ([p 0   0 1]);
      check ([0 0   0 1]);

% 2 singletons
      check ([1 1   0 s]);
      check ([1 1   r 0]);
      check ([1 1   0 0]);

      check ([0 q   1 1]);
      check ([p 0   1 1]);
      check ([0 0   1 1]);

      check ([1 0   0 1]); % inner product
      check ([0 1   1 s]); % outer product
      check ([p 1   1 0]); % outer product
      check ([0 1   1 0]); % outer product
    % check ([1 q   1 s]); % Not allowed
    % check ([p 1   r 1]); % Not allowed

% 3 singletons
    check ([1 1   1 0]);
    check ([1 1   0 1]);
    check ([1 0   1 1]);
    check ([0 1   1 1]);



%--------------------------------------------------------------------------
function check(sizes);

% 4D
for d1 = 1:5
    for d2 = 1:2 
        a0 = rand( sizes([1 2]) ); 
        b0 = rand( sizes([3 4]) ); 
        c0 = a0 * b0;

        a1(d1, d2,  :,  :) = a0;
        b1(d1, d2,  :,  :) = b0;
        c1(d1, d2,  :,  :) = c0;

        a2(d1,  :,  :, d2) = a0;
        b2(d1,  :,  :, d2) = b0;
        c2(d1,  :,  :, d2) = c0;

        a3( :,  :, d1, d2) = a0;
        b3( :,  :, d1, d2) = b0;
        c3( :,  :, d1, d2) = c0;
    end
end
checkallsyntaxes(a1,b1,c1, [3 4]);
checkallsyntaxes(a2,b2,c2, [2 3]);
checkallsyntaxes(a3,b3,c3, [1 2]);

clear *1
clear *2

% 3D
for d1 = 1:5
        a0 = rand( sizes([1 2]) ); 
        b0 = rand( sizes([3 4]) ); 
        c0 = a0 * b0;

        a1(d1,  :,  :) = a0;
        b1(d1,  :,  :) = b0;
        c1(d1,  :,  :) = c0;

        a2( :,  :, d1) = a0;
        b2( :,  :, d1) = b0;
        c2( :,  :, d1) = c0;
end
checkallsyntaxes(a1,b1,c1, [2 3]);
checkallsyntaxes(a2,b2,c2, [1 2]);

clear *1

% 2D
a1 = rand( sizes([1 2]) ); 
b1 = rand( sizes([3 4]) ); 
c1 = a1 * b1;
checkallsyntaxes(a1,b1,c1, [1 2]);

%--------------------------------------------------------------------------
function checkallsyntaxes(a,b,c, rcA)

d1 = rcA(1);
d2 = rcA(2);
 p = size(a, d1);
 q = size(a, d2);
 r = size(b, d1);
 s = size(b, d2);

scalarsinA = false;
scalarsinB = false;
if isequal([p q], [1 1]), scalarsinA = true; end
if isequal([r s], [1 1]), scalarsinB = true; end

c1xs  = c;
c2a   = c;
c2b   = c;
c3a   = c;
c3b   = c;
c4a   = c;
c4b   = c;
c4cdl = c;
c4cds = c;

% Syntax 1 (Matrices by Matrices)
checklog = 'Checked syntaxes: 1-long, 1-short';    
c1l  = MULTIPROD(a,b, rcA, rcA); % Mat by Mat long syntax
c1s  = MULTIPROD(a,b, rcA); %      Mat by Mat short syntax
if d1==1
    checklog = [checklog, ', 1-xs'];    
    c1xs  = MULTIPROD(a,b); % Mat by Mat extra-short syntax
end
    
if p == 1, Ad2 = delsingleton(a, d1); end % 1 x Q
if q == 1, Ad1 = delsingleton(a, d2); end % P x 1
if r == 1, Bd2 = delsingleton(b, d1); end % 1 x S
if s == 1, Bd1 = delsingleton(b, d2); end % R x 1

% REMOVING ONLY OUTER SINGLETONS IS ALWAYS POSSIBLE
% REMOVING INNER SINGLETONS IS NOT ALWAYS POSSIBLE
% NOTE: either BOTH or NONE inner dimensions can be singletons    

% Syntax 2 (removing right outer singleton)
if s == 1
    if scalarsinB % Syntax 2b (multiprod returns 2-D)
        checklog = [checklog, ', 2b'];    
                     c2b = MULTIPROD(a, Bd1, [d1 d2], [d1]);
    else % Syntax 2a
        checklog = [checklog, ', 2a'];    
        c2a = addsingleton(MULTIPROD(a, Bd1, [d1 d2], [d1]), d2);
    end
end
% Syntax 3 (removing left outer singleton)
if p == 1 
    if scalarsinA % Syntax 3b (multiprod returns 2-D)
        checklog = [checklog, ', 3b'];    
                     c3b = MULTIPROD(Ad2, b, [d1], [d1 d2]);
    else % Syntax 3a
        checklog = [checklog, ', 3a'];    
        c3a = addsingleton(MULTIPROD(Ad2, b, [d1], [d1 d2]), d1);
    end
end

% Syntax 4a - Outer product (removing BOTH inner singletons)
%             C is PxS
if all([  q r  ] == 1)
    checklog = [checklog, ', 4a'];
    c4a = MULTIPROD(Ad1, Bd2, [d1 0], [0 d1]); 
end

% Syntaxes 4b, 4c, 4d (removing BOTH outer singletons)
if all([p     s] == 1)
    % Syntax 4b - Inner product
    %             C is 1x1
    if q == r
        checklog = [checklog, ', 4b'];
        c4b = addsingleton(MULTIPROD(Ad2, Bd1, [0 d1], [d1 0]), d1);
    end

    % Syntax 4c/d
    if scalarsinA && scalarsinB, dimaddC = d1; % In both    - C = 1x1
    elseif scalarsinA,           dimaddC = d2; % Only in A  - C = Rx1
    elseif scalarsinB,           dimaddC = d1; % Only in B  - C = 1xQ
    else                         dimaddC = d1; % No scalars - C = 1x1
    end
    checklog = [checklog, ', 4c/d-long, 4c/d-short'];
    c4cdl = addsingleton(MULTIPROD(Ad2, Bd1, [d1],   [d1]  ), dimaddC);
    c4cds = addsingleton(MULTIPROD(Ad2, Bd1, [d1]          ), dimaddC);
end
    
checkresult = [ isequal(c1l, c), ...
                isequal(c1s, c) , ...
                isequal(c1xs, c) , ...
                isequal(c2a, c) , ...
                isequal(c2b, c) , ...
                isequal(c3a, c) , ...
                isequal(c3b, c) , ...
                isequal(c4a, c) , ...
                isequal(c4b, c) , ...
                isequal(c4cdl, c) , ...
                isequal(c4cds, c)];

disp ' '
disp '-------------------------------------------------------------------'
disp ' '
disp '2-D subarrays are here:'
if     isequal(rcA, [1 2]) disp '     •     •'
elseif isequal(rcA, [2 3]) disp '           •     •'
elseif isequal(rcA, [3 4]) disp '                 •     •'
end
SizeA = size(a)
SizeB = size(b)
SizeC = size(c)
disp ' '
disp (checklog)
disp ' '

if  all(checkresult)
    disp 'The multiproduct is correct :-)'
else
    disp 'One or more syntaxes return wrong multiproducts :-('
    disp ' '
    checkresult
    disp '    1l    1s   1xs    2a    2b    3a    3b    4a    4b  4cdl  4cds'
    pause
end



%--------------------------------------------------------------------------
function b = addsingleton(a, newdim)
%ADDSINGLETON   Adding a singleton dimension to an array.
%   Example:
%      A .................... is a 5x9x3 array,
%      B = ADDSINGLETON(A, 3) is a 5x9x1x3 array,

if newdim <= ndims(a)
    sizA = size(a);
    sizB = [sizA(1:newdim-1), 1, sizA(newdim:end)];
    b = reshape(a, sizB);
else 
    b = a;
end



%--------------------------------------------------------------------------
function b = delsingleton(a, dim)
%DELSINGLETON   Removing a singleton dimension from an array.
%   Example:
%      A .................... is a 5x9x1x3 array,
%      B = DELSINGLETON(A, 3) is a 5x9x3 array.

if dim < ndims(a)
    sizA = size(a);
    % Vector SIZB must have at least 2 elements
    sizB = [sizA(1:dim-1), sizA(dim+1:end), 1];
    b = reshape(a, sizB);
else 
    b = a;
end