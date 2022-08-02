function NewV = extrapolate_values(V,mask,varargin)
%EXTRAPOLATE_VALUES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:50:06 $

% T = EXTRAPOLATE_VALUES(T,mask) in which we extrapolate from a partially defined 
% set of values to generate the entire values field. V is the marix to extrapolate from
% and mask should a matrix of 0's and 1's the same size as the values field with the 1's 
% signifying that the value in this position is to be trusted.. Varargin{1} should be the 
% X breakpoints, varargin{2} should be the y breakpoints. Varargin{3} should be used to 
% specify an algorithm if something more than the default systems is wanted.
%
% Four basic cases are dealt with:
%
% 1. Only one point specified, in which case we set the output to a constant matrix with this value.
%
% 2. Colinear data is given, in which case we will produce a surface obtained by translating this line 
%    along a vector perpendicular to the direction of the line and the z axis.
%
% 3. Three non colinear points are given, in which case they define a plane and we use this to provide 
%    our values.
%
% 4. We are given a grid of data, in whch case we interpolate and extrapolate from this grid.
%
% Anything else is considered a general case and we proceed by identifing the 'core' region - the convex
% hull that encloses all our good points, fill this out by populating it with the values that a mesh of springs
% would settle on if given the partial data, and then extrapolate out of this region to the boundaries.
%  

% To work then. First do a compatibilty check.

S = size(V);

IndC = [1:S(2)]'; % index of columns.
IndR = [1:S(1)]'; % ditto rows.

BPx = IndC; % Set up dummy breakpoint vectors. To be replaced if varargin is nonempty.
BPy = IndR;
alg = 0;

if ~isequal(S,size(mask))
    error('Just what are you playing at? Mask should be same size as the table.')
elseif isequal(mask,zeros(size(mask)))
    error('Come on, give me something to go on here.');
elseif ~isempty(varargin)
    if length(varargin{1}) ~= S(2)
        error('X vector wrong size.');
    else
        BPx = varargin{1}; % x-breakpoints
    end
    if length(varargin) > 1
        if length(varargin{1}) ~= S(2)
            error('X vector wrong size.');
        else
            BPy = varargin{2}; % x-breakpoints
        end 
        if length(varargin) > 2
            alg = varargin{3};
        end
    end
end

% First up, what if we only have 1 trust worthy point - then initialise then set the matrix to this number.
% Second what if we have two points?
if sum(mask(:))==1
    val = V(mask(:,:)==1);
    NewV = val*ones(size(V));
    return
end

% Now to handle the colinear case when all the trust worthy data is on a line
linearflag = 1; % we assume the data is linear, and then hit it with some tests to see if this is true
[J,I] = find(mask);
dI = BPx(I(end))-BPx(I(1));
dJ = BPy(J(end))-BPy(J(1));
for i = 1:length(I)
    if dJ*(BPx(I(i))-BPx(I(1)))-dI*(BPy(J(i))-BPy(J(1))) ~= 0 % test to see if ith point is on the line joining first 
        % and last
        linearflag = 0;
    end
end

if linearflag % Colinear data
    % For colinear data we will translate the line defined by the data in a direction normal to both the line
    % and the z axis to generate a surface. In practice what this means is that we will have a coordinate s 
    % which represents distance along the line, we generate an s value for every point in the matrix, and then
    % we use extrinterp to fill out the table.
    goodV = diag(V(J,I)); % Trustworthy values.
    X1 = [BPx(I(1));BPy(J(1));0];
    X2 = [BPx(I(2));BPy(J(2));1];
    % plane is of the form Ax+By+Cz = d, where z gives us our s coordinate, 0 at X1, and 1 at X2;
    dX = X1-X2;
    A = -dX(1)*dX(3); B = -dX(2)*dX(3); C = dX(1)^2+dX(2)^2; D = [A B C]*X1;
    % generate X and Y matrices
    [X,Y] = meshgrid(BPx,BPy);
    s = (D-A*X-B*Y)/C; % This gives us the s coordinates 
    sgood = diag(s(J,I)); % coordinates of good values.
    NewV = eval(cgmathsobject,'extinterp1',sgood,goodV,s);
    return
end

% We are going to implement two more methods for special cases, and then produce a general routine.
% the hope is that on fine tuning the general routine will collapse into the special cases.

if sum(mask(:)) == 3
    % now we have three non-colinear points, so they define a plane, we use this plane to generate the
    % surface.
    X1 = [BPx(I(1));BPy(J(1));V(J(1),I(1))];
    X2 = [BPx(I(2));BPy(J(2));V(J(2),I(2))];
    X3 = [BPx(I(3));BPy(J(3));V(J(3),I(3))];
    % Believe it or not, the following monster computes the plane.
    [x,y] = meshgrid(BPx,BPy);
    NewV = (-(-X1(3)*X2(2)+X1(3)*X3(2)+X2(3)*X1(2)-X2(3)*X3(2)-X3(3)*X1(2)+...
        X3(3)*X2(2))/(X1(1)*X2(2)-X1(1)*X3(2)-X2(1)*X1(2)+X2(1)*X3(2)+...
        X3(1)*X1(2)-X3(1)*X2(2)))*x+((-X1(3)*X2(1)+X1(3)*X3(1)+X2(3)*X1(1)-X2(3)*X3(1)-X3(3)*X1(1)+X3(3)*X2(1))/...
        (X1(1)*X2(2)-X1(1)*X3(2)-X2(1)*X1(2)+X2(1)*X3(2)+X3(1)*X1(2)-X3(1)*X2(2)))*y+...
        ((X1(3)*X2(1)*X3(2)-X1(3)*X3(1)*X2(2)-X2(3)*X1(1)*X3(2)+X2(3)*X3(1)*X1(2)+...
        X3(3)*X1(1)*X2(2)-X3(3)*X2(1)*X1(2))/(X1(1)*X2(2)-X1(1)*X3(2)-X2(1)*X1(2)+X2(1)*X3(2)+X3(1)*X1(2)-X3(1)*X2(2)));
    return
end

% Next special case, we have gridded data, so use this to fill the core of the table and then extrapolate out.
uI = unique(I); uJ = unique(J); [gI,gJ] = meshgrid(uI,uJ);

if isequal(I,gI(:)) & isequal(J,gJ(:)) % gridded data
    goodV = V(uJ,uI);
    NewV = extinterp2(BPx(uI),BPy(uJ),goodV,BPx',BPy);
    return
end

% Now generic case, we have more than three non colinear points, and they aren't in a grid.
% One possibility is to use griddata to fill up the interior and then some extrapolation method
% to expand out. I don't like this for the following reason. If you have four values of [0 0 0 1] at the corners of 
% a 3 by 3 square then griddata will give as an answer one of the following:
%   [ 0  0  0]     [ 0  0  0]
%   [ 0  0 .5]  or [ 0 .5 .5]
%   [ 0 .5  1]     [ 0 .5  1]
% Either way it seems wrong that the centre is not the average of the corners. Another problem is that having 
% implemented a routine for a grid of points it seems wrong that the addition of a extra point would then lead
% to a worse fit.

% What follows is an attempt to provide a decent way of solving this little problem. We are going to try to fill out the
% centre with the 'energy minimiser' based on the given grid and trustworthy values.

% Wish me luck.

goodV = diag(V(J,I));

IntV = griddata(BPx(I),BPy(J),goodV,BPx',BPy);

temp = zeros(size(V));
temp(~isnan(IntV)) = 1; % positions of interior points

temp_vec = find(temp); % corresponding elements of 'nice'
known_vec = mask(temp_vec);
index_vec = [1:length(temp_vec)]'; 

% now scale BPx and BPy to fit in [0,1]

scaled_x = (BPx-BPx(1))/(BPx(end)-BPx(1));
scaled_y = (BPy-BPy(1))/(BPy(end)-BPy(1));

dx = diff(scaled_x);
dy = diff(scaled_y);

M = []; % We are going to log here which of a points four neighbours are in convex hull
% and then form a dynamics matrix that will help us to determine the solution to the minimisation problem.
values_vec = [];

for i = 1:length(temp_vec)
    if known_vec(i) == 1 % Known so store it as such
        newrow = zeros(1,length(temp_vec));
        newrow(i) = 1;
        values_vec = [values_vec ; V(temp_vec(i))];
    else
        values_vec = [values_vec ; 0];
        newrow = zeros(1,length(temp_vec));
        % Now find out which neighbours are inside the good zone and populate new row with this information
        index = temp_vec(i);
        i_ind = index - S(1)*floor((index-1)/S(1));
        j_ind = (index-i_ind)/S(1)+1; % we are looking at a point with indices (i_ind,j_ind) in V.
        % Is left neighbour in good set?
        if j_ind ~= 1
            if temp(i_ind,j_ind-1) == 1 % it's in our hull
                neighbour_index = S(1)*(j_ind-2)+i_ind;
                index_in_temp_vec = index_vec(temp_vec == neighbour_index);
                temp_row = zeros(size(newrow));
                temp_row([index_in_temp_vec, i]) = 1/dx(j_ind-1)*[-1 1]; % -1/dx is a spring stiffness - short spirngs are 
                % stiffer in this routine
                newrow = newrow + temp_row;
            end
        end
        % Is right neighbour in good set?
        if j_ind ~= S(2)
            if temp(i_ind,j_ind+1) == 1 % it's in our hull
                neighbour_index = S(1)*(j_ind)+i_ind;
                index_in_temp_vec = index_vec(temp_vec == neighbour_index);
                temp_row = zeros(size(newrow));
                temp_row([index_in_temp_vec, i]) = 1/dx(j_ind)*[-1 1]; % -1/dx is a spring stiffness - short spirngs are 
                % stiffer in this routine
                newrow = newrow + temp_row;
            end
        end
        % Is upper neighbour in good set?
        if i_ind ~= 1
            if temp(i_ind-1,j_ind) == 1 % it's in our hull
                neighbour_index = S(1)*(j_ind-1)+i_ind-1;
                index_in_temp_vec = index_vec(temp_vec == neighbour_index);
                temp_row = zeros(size(newrow));
                temp_row([index_in_temp_vec, i]) = 1/dy(i_ind-1)*[-1 1]; % -1/dy is a spring stiffness - short spirngs are 
                % stiffer in this routine
                newrow = newrow + temp_row;
            end
        end
        % Is lower neighbour in good set?
        if i_ind ~= S(1)
            if temp(i_ind+1,j_ind) == 1 % it's in our hull
                neighbour_index = S(1)*(j_ind-1)+i_ind+1;
                index_in_temp_vec = index_vec(temp_vec == neighbour_index);
                temp_row = zeros(size(newrow));
                temp_row([index_in_temp_vec, i]) = 1/dy(i_ind)*[-1 1]; % -1/dx is a spring stiffness - short springs are 
                % stiffer in this routine
                newrow = newrow + temp_row;
            end
        end
    end
    M = [M;newrow];
end

IntV = zeros(size(V));
IntV(temp_vec) = inv(M)*values_vec;

% By now we've filled a convex subset of our original matrix, now we need to go round the boundary 
% and fill up the other points. To do this, we consider each point in turn and see if we have enough information 
% to give it a reasonable value, if so we fill it, if not we leave it for a bit. After going through once we update our 
% matrix and start over again until we are done.

intmask = zeros(size(V));
intmask(find(temp)) = 1; % positions we are happy with.
nextmask = intmask; % we'll use this to update the positions we're happy with.
nextV = IntV; % Store for updated values.
dx = diff(BPx);
dy = diff(BPy);

while ~all(intmask(:)) % keep going until we're happy with everything 
    for i = 1:S(1)
        for j = 1:S(2) % I know, a nested for loop, but I think clarity (for my sake if noone else's) demands it
            if intmask(i,j) == 0 %work needs to be done
                % the criteria we update on are as follows - if it is surrounded by three full elements in a corner
                % configuration, if it has two elements either above it or below it or to one side. In these cases
                % we'll do a simple linear extrapolation and if we have more than one possiblity, then average the
                % answers.
                % So patterns we're looking for are:
                %  
                %  * * .    *
                %  * x . or * or * * x or some variant thereof
                %           x
                %
                % first check the corners lower right
                newval = [];
                if i ~= S(1) 
                    if j ~= S(2)
                        if isequal([intmask(i+1,j);intmask(i,j+1);intmask(i+1,j+1)],[1;1;1])
                            newval = [newval ; IntV(i+1,j)+IntV(i,j+1)-IntV(i+1,j+1)];
                        end
                        if j ~= 1 % lower left
                            if isequal([intmask(i+1,j);intmask(i,j-1);intmask(i+1,j-1)],[1;1;1])
                                newval = [newval ; IntV(i+1,j)+IntV(i,j-1)-IntV(i+1,j-1)];
                            end
                        end
                    end
                    if i ~= 1
                        if j ~= S(2) % upper right
                            if isequal([intmask(i-1,j);intmask(i,j+1);intmask(i-1,j+1)],[1;1;1])
                                newval = [newval ; IntV(i-1,j)+IntV(i,j+1)-IntV(i-1,j+1)];
                            end
                        end
                        if j ~= 1 % upper left
                            if isequal([intmask(i-1,j);intmask(i,j-1);intmask(i-1,j-1)],[1;1;1])
                                newval = [newval ; IntV(i-1,j)+IntV(i,j-1)-IntV(i-1,j-1)];
                            end
                        end
                    end
                    % now test to see if we're next to two consecutive elements
                end
                if j > 2
                    if isequal([intmask(i,j-1) ; intmask(i,j-2)],[1;1])
                        newval = [newval ; IntV(i,j-1)+(IntV(i,j-1)-IntV(i,j-2))*dx(j-1)/dx(j-2)];
                    end
                end
                if j < S(2)-2
                    if isequal([intmask(i,j+1) ; intmask(i,j+2)],[1;1])
                        newval = [newval ; IntV(i,j+1)+(IntV(i,j+1)-IntV(i,j+2))*dx(j+1)/dx(j+2)];
                    end
                end         
                if i > 2
                    if isequal([intmask(i-1,j) ; intmask(i-2,j)],[1;1])
                        newval = [newval ; IntV(i-1,j)+(IntV(i-1,j)-IntV(i-2,j))*dy(i-1)/dy(i-2)];
                    end
                end         
                if i < S(1)-2
                    if isequal([intmask(i+1,j) ; intmask(i+2,j)],[1;1])
                        newval = [newval ; IntV(i+1,j)+(IntV(i+1,j)-IntV(i+2,j))*dy(i+1)/dy(i+2)];
                    end
                end         
                if ~isempty(newval)
                    nextV(i,j) = sum(newval)/length(newval);
                    nextmask(i,j) = 1;
                end
            end
            
        end 
    end
    intmask = nextmask;
    IntV = nextV; % update stores with what we've just done.
end

NewV = IntV;

return
