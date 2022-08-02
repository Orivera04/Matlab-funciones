function    s_vectors=q_rotns(t_vectors, r_vector, r_angle)
%       s_vectors = q_rotns(t_vectors, r_vector, r_angle)
% Implements rotation of a vector or set of vectors (t_vectors) around a specified
% vector or set of vectors (r_vector) by the angle or angles r_angle using quaternions. 
% If rotation around a multiple set of vectors is required then the sizes
% of both sets of vectors must be the same and the number of angles must
% match the vector sets
% When multiple vectors are used the arrays are assumed to be m by 3. Other
% than checking the number of vectors (assuming m by 3 array sizes) and the
% number of angles no error checking is performed when multiple vectors are
% processed.
% Returns an empty vector if the inputs are not of the correct dimensions
% Looking from the origin of the reference vector around which the rotation
% is being made the rotation is clockwise

s_vectors = [];

% Check that the inputs are 3 vectors
if size(t_vectors, 2)~=3
    return
end
% Get the number of vectors
n_vec = size(t_vectors, 1);

if prod(size(r_vector))==3
    % Rotation around a single vector is required
    % Ensure that the vector is a unit vector
    r_vector = r_vector/sqrt(dot(r_vector, r_vector));
    
    % Create the quaternion
    rotn_vec = [cos(r_angle/2), sin(r_angle/2)*reshape(r_vector, 1, 3)];
    % Set up the conjugate
    rotn_vec_conj = rotn_vec;
    rotn_vec_conj(2:4) = -rotn_vec_conj(2:4);
    
    % Set up the quaternion to implement rotation
    t_vectors(:, 2:4) = t_vectors;
    t_vectors(:, 1) = 0;
    
    % Perform the quaternion multiplication
    s_vectors = q_mxs(q_mxs(repmat(rotn_vec, n_vec, 1), t_vectors), repmat(rotn_vec_conj, n_vec, 1));
    
    % Extract the required components
    s_vectors = s_vectors(:, 2:4);
    
    return
    
end

% Processing multiple vectors
n_r_vec = size(r_vector, 1);

if n_vec~=n_r_vec | n_vec~=length(r_angle)
    % The number of vectors is inconsistent
    return
end

% Ensure that the rotation vectors are unit vectors
r_vector = r_vector./repmat(sqrt(dot(r_vector, r_vector, 2)), 1, 3);

% Transform the rotation vectors to quaternions
rotn_vec = repmat(sin(r_angle/2), 1, 3).*r_vector;
rotn_vec = cat(2, cos(r_angle/2), rotn_vec);

% Set up the conjugates
rotn_vec_conj = rotn_vec;
rotn_vec_conj(:, 2:4) = -rotn_vec_conj(:, 2:4);

% Set up the quaternion to implement rotation
t_vectors(:, 2:4) = t_vectors;
t_vectors(:, 1) = 0;

% Perform the quaternion multiplication
s_vectors = q_mxs(q_mxs(rotn_vec, t_vectors), rotn_vec_conj);

% Extract the required components
s_vectors = s_vectors(:, 2:4);

% End of function:      q_rotns
return

function qvs = q_mxs(q, r)
% Multiplies a set of quaternion vectors q with another set r. Assumes that
% the sizes are correct

% The first element is the product of the scalar terms minus the dot product
% of the vector components

qvs = zeros(size(q, 1), 4);

% Set up the scalar term
% Use an expansion of the dot product for speed
tqvs(:,1) = q(:,1).*r(:,1)- dot(q(:,2:4), r(:,2:4), 2);
qvs(:,1) = q(:,1).*r(:,1)- sum(q(:,2:4).*r(:,2:4), 2);

% Set up the vector term which is a cross product and the sum of two scalar
% products of vectors
% Use an expansion of the cross product for speed
% qvs(:,2:4) = cross(q(:,2:4), r(:,2:4), 2) + repmat(q(:,1), 1, 3).*r(:,2:4) + repmat(r(:,1), 1, 3).*q(:,2:4);
qvs(:,2) = q(:,3).*r(:,4)-q(:,4).*r(:,3);
qvs(:,3) = -(q(:,2).*r(:,4)-q(:,4).*r(:,2));
qvs(:,4) = q(:,2).*r(:,3)-q(:,3).*r(:,2);
qvs(:,2:4) = qvs(:,2:4) + repmat(q(:,1), 1, 3).*r(:,2:4) + repmat(r(:,1), 1, 3).*q(:,2:4);

% End of function:              q_mxs
return
