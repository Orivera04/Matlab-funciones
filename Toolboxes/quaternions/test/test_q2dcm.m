%TEST_Q2DCM runs unit tests for the Q2DCM function.

% Release: $Name: quaternions-1_2_2 $
% $Revision: 1.4 $
% $Date: 2001/05/01 20:20:33 $

% Copyright (C) 2001 by Jay A. St. Pierre.  All rights reserved.

test_title = 'q2dcm';
disp_test_title(test_title);

failures=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Insufficient Arguments');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expected_err = 'q2dcm() requires one input argument';
fct_call     = 'q2dcm';
failures=failures+check_err(fct_call, expected_err);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Invalid Input: scalar');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expected_err = ...
    ['Invalid input: must be a quaternion or a vector of' ...
     ' quaternions'];
fct_call     = 'q2dcm(1)';
failures=failures+check_err(fct_call, expected_err);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Ambiguous Input: 4x4 non-normalized');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expected_warn = ...
    'Component quaternion shape indeterminate... assuming row vectors';
fct_call      = 'q2dcm(ones(4,4));';
failures=failures+check_warn(fct_call, expected_warn);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Column of two quaternions');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Q=qnorm(2*rand(2,4)-1), disp(' ')
v=[1 2 3], disp(' ')
truth_value = 'qvxform(Q, v)';
A='q2dcm(Q)', disp(' ')
A=eval(A);
test_value='[A(:,:,1)*v.'' A(:,:,2)*v.''].''', disp(' ')
failures=failures+check_value(truth_value, test_value, 10*eps);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Row of two quaternions');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Q=qnorm(2*rand(4,2)-1), disp(' ')
v=rand(3,2), disp(' ')
truth_value = 'qvxform(Q, v)';
A='q2dcm(Q)', disp(' ')
A=eval(A);
test_value  = '[A(:,:,1)*v(:,1) A(:,:,2)*v(:,2)]';
failures=failures+check_value(truth_value, test_value, 10*eps);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp_num_failures(test_title, failures)

