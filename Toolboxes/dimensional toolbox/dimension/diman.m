function piset = diman(RL,BaseVars,D)
% DIMAN
%  PISET = DIMAN(RL,BV,D,DNames) calculates the dimensional analysis 
%  for the relevance list RL with the base vars BV (cell array 
%  of strings). The optional parameter D is assumed an identitiy 
%  matrix if not given. DIMAN returns a structure PISET containing the 
%  submatrices A, B, C, and D as well as the order ORDER of the
%  variables from RL in the submatrix [B A]

% Steffen Brueckner, 2002-02-06

% first check the number of input arguments
msg = nargchk(2,3,nargin);
if msg
    error(msg);
    break;
end

% create the submatrices according to choosen BaseVars
[A,B,order] = createab(RL,BaseVars);

% check if BaseVars are chosen appropriately
if ~checkdm(A,B)
    error('Base variables are not chosen appropriately');
    break;
end

% form the dimensional matrix
BA = formdm(A,B);

% determine the rank of the dimensional matrix
r = rank(BA);

if nargin < 3
    % if not given assume submatrix D as identity matrix
    % of right size
    D = eye(size(B,2)); % number of columns in B
else
    % check if D is of right size, else throw error
    if (size(D,1) ~= size(D,2)) | (size(D,2) ~= size(B,2))
        error('D submatrix incompatible with number of variables/base vars');
    end
end

% check if number of base vars equals the rank of the dimensional matrix
if length(BaseVars) ~= r
    error('Number of base vars must be equal to the rank of the dimensional matrix; Select other base variables');
    break;
end

% check if submatrix A is of the same rank as the dimensional matrix
if rank(A) ~= r
    error('Rank of submatrix A must be equal to rank of the dimensional matrix; Select other base variables');
end

% Calculate the submatrix C (DO IT!)
C = -D * (inv(A) * B)';

piset.A = A;
piset.B = B;
piset.C = C;
piset.D = D;
piset.order = order;
n = {RL.Name};
piset.Name  = n(order);