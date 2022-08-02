%TEST_QNORM runs unit tests for the QNORM function.

% Release: $Name: quaternions-1_2_2 $
% $Revision: 1.5 $
% $Date: 2001/05/01 20:20:33 $

% Copyright (C) 2001 by Jay A. St. Pierre.  All rights reserved.

test_title = 'qnorm';
disp_test_title(test_title);

failures=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Insufficient Arguments');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expected_err = 'qnorm() requires one input argument';
fct_call     = 'qnorm';
failures=failures+check_err(fct_call, expected_err);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Invalid Input');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expected_err = ...
    ['Invalid input: must be a quaternion or a vector of' ...
     ' quaternions'];
fct_call     = 'qnorm(1)';
failures=failures+check_err(fct_call, expected_err);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Column of two quaternions');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q1=1:4,q2=4:-1:1,disp(' ')
truth_value = '[q1/sqrt(sum(q1.^2)); q2/sqrt(sum(q2.^2))]';
test_value  = 'qnorm([q1; q2])';
failures=failures+check_value(truth_value, test_value);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Row of 6 quaternions');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
truth_value = '.5*ones(4,6)';
test_value  = 'qnorm(ones(4,6))';
failures=failures+check_value(truth_value, test_value);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp_num_failures(test_title, failures)

