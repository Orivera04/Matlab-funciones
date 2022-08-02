function NewV = extrapolate_values_RBF(V, mask, varargin)
%EXTRAPOLATE_VALUES_RBF
%
%  T = EXTRAPOLATE_VALUES_RBF(T, mask, BPx, BPy) extrapolates from a
%  partially defined set of values to generate the entire values field. V
%  is the matrix to extrapolate from and mask should a logical matrix the
%  same size as the values field with the true elements signifying that the
%  value in this position is to be trusted. BPx is the X breakpoints, BPy
%  is the y breakpoints.
%
%  Four basic cases are dealt with:
%
%  1. Only one point specified, in which case we set the output to a
%     constant matrix with this value.
%
%  2. Colinear data is given, in which case we will produce a surface
%     obtained by translating this line along a vector perpendicular to the
%     direction of the line and the z axis.
%
%  3. Three non colinear points are given, in which case they define a
%     plane and we use this to provide our values.
%
%  4. More than 3 points are interpolated and extrapolated using an RBF
%     interpolant model.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.4 $  $Date: 2004/02/09 06:50:07 $

S = size(V);

% Row and column indices
IndC = (1:S(2))';
IndR = (1:S(1))';

% Set up dummy breakpoint vectors. To be replaced if varargin is nonempty.
BPx = IndC; 
BPy = IndR;

if ~islogical(mask)
    error('mbc:extrapolate_values_RBF:InvalidArgument', ...
        'Extrapolation mask must be a logical matrix.');
elseif ~isequal(S,size(mask))
    error('mbc:extrapolate_values_RBF:InvalidArgument', ...
        'Extrapolation mask must be the same size as the table.');
elseif ~any(mask(:))
    error('mbc:extrapolate_values_RBF:InvalidArgument', ...
        'Mask has no cells marked.');
elseif ~isempty(varargin)
    if length(varargin{1}) ~= S(2)
        error('mbc:extrapolate_values_RBF:InvalidArgument', ...
            'Length of X vector must match the number of columns in the table.');
    else
        BPx = varargin{1};
    end
    if length(varargin) > 1
        if length(varargin{2}) ~= S(1)
            error('mbc:extrapolate_values_RBF:InvalidArgument', ...
                'Length of Y vector must match the number of rows in the table.');
        else
            BPy = varargin{2};
        end
    end
end

% Find X and Y indices for points in the mask: this is used in various
% places later on.
[J,I] = find(mask);

% First up, what if we only have 1 trust worthy point - then initialise the
% matrix to this number.
if length(J)==1
    val = V(mask(:,:)==1);
    NewV = val*ones(size(V));
    return
end

% Now to handle the colinear case when all the trust worthy data is on a
% line.  We assume the data is linear, and then hit it with some tests to
% see if this is true
linearflag = true;
if length(I)>2

    % Map BPx and BPy down to [-1,1] for the sake of comparison to avoid problems with thousands being
    % compared with thousanths and hence more round off error.
    mxBPX = max(BPx(:)); mnBPX = min(BPx(:));
    if mxBPX == mnBPX
        error('mbc:extrapolate_values_RBF:InvalidArgument', ...
            'X Breakpoints are all the same.');
        return
    end
    mxBPY = max(BPy(:)); mnBPY = min(BPy(:));
    if mxBPY == mnBPY
        error('mbc:extrapolate_values_RBF:InvalidArgument', ...
            'Y Breakpoints are all the same.');
        return
    end
    mBPx = (BPx-mnBPX)/(mxBPX-mnBPX);
    mBPy = (BPy-mnBPY)/(mxBPY-mnBPY);
    
    startI = mBPx(I(1));
    startJ = mBPy(J(1));
    K = (mBPx(I(end)) - startI) / (mBPy(J(end)) - startJ);
    
    for i = 2:(length(I)-1)
        if abs((mBPx(I(i)) - startI) - K*(mBPy(J(i)) - startJ)) > 100*eps
            %test to see if ith point is on the line joining first
            % and last (Account for machine error)
            linearflag = false;
            break
        end
    end
end

if linearflag % Colinear data
    % For colinear data we will translate the line defined by the data in a direction normal to both the line
    % and the z axis to generate a surface. In practice what this means is that we will have a coordinate s
    % which represents distance along the line, we generate an s value for every point in the matrix, and then
    % we use extrinterp to fill out the table.
    goodV = V(mask);
    X1 = [BPx(I(1));BPy(J(1));0];
    X2 = [BPx(I(2));BPy(J(2));1];
    % plane is of the form Ax+By+Cz = d, where z gives us our s coordinate, 0 at X1, and 1 at X2;
    dX = X1-X2;
    A = -dX(1)*dX(3); B = -dX(2)*dX(3); C = dX(1)^2+dX(2)^2; D = [A B C]*X1;
    % generate X and Y matrices
    [X,Y] = meshgrid(BPx,BPy);
    s = (D-A*X-B*Y)/C; % This gives us the s coordinates
    sgood = s(mask);
    NewV = eval(cgmathsobject,'extinterp1',sgood,goodV,s);
    return
end


% Now to handle the coplanar case when there are 3 points that are not on a
% line
if length(J) == 3
    Zval = [V(J(1),I(1)) V(J(2),I(2)) V(J(3),I(3))];
    Xmat = [BPx(I(1)) BPy(J(1)) 1; BPx(I(2)) BPy(J(2)) 1; BPx(I(3)) BPy(J(3)) 1]';
    A = Zval/Xmat;
    [x,y] = meshgrid(BPx,BPy);
    NewV = A(1)*x+A(2)*y+A(3);
    return
end


% And now we try an RBF method

% Scale BPx and BPy to fit in [0,1]
scaled_x = (BPx-BPx(1))/(BPx(end)-BPx(1));
scaled_y = (BPy-BPy(1))/(BPy(end)-BPy(1));

[xgrid,ygrid] = meshgrid(scaled_x,scaled_y);

goodIndex = find(mask);
N = length(goodIndex);
X = [xgrid(goodIndex)'; ygrid(goodIndex)'];

R = zeros(N);
Y = X' * X;
vect = diag(Y);
for n = 1:N
    R(:,n) = vect + vect(n);
end
R = R - 2*Y;

RBFmatrix = [0.5 * R .* log(R+eps), ones(N,1),  X'; [ones(1,N); X], zeros(3)];
Vec = [V(goodIndex); zeros(3,1)];
Lambda = RBFmatrix\Vec;

N1 = prod(size(xgrid));
rho = zeros(N1, N+3);
for n = 1:N
    col = ((xgrid(:) - xgrid(goodIndex(n))).^2 + (ygrid(:) - ygrid(goodIndex(n))).^2);
    rho(:, n) = 0.5 * col .* log(col + eps);
end
rho(:, N+1) = 1;
rho(:, N+2) = xgrid(:);
rho(:, N+3) = ygrid(:);
NewV = reshape(rho*Lambda,size(xgrid));

% Ensure that the masked cells retain their original values
NewV(mask) = V(mask);
