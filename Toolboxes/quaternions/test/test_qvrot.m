%TEST_QVROT runs unit tests for the QVROT function.

% Release: $Name: quaternions-1_2_2 $
% $Revision: 1.3 $
% $Date: 2001/05/01 20:20:34 $

% Copyright (C) 2001 by Jay A. St. Pierre.  All rights reserved.

test_title = 'qvrot';
disp_test_title(test_title);

failures=0;

q=[0 0 0 1], disp(' ')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Insufficient Arguments: no arguments');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expected_err = 'qvrot() requires two input arguments';
fct_call     = 'qvrot';
failures=failures+check_err(fct_call, expected_err);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Insufficient Arguments: one argument');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expected_err = 'qvrot() requires two input arguments';
fct_call     = 'qvrot(1)';
failures=failures+check_err(fct_call, expected_err);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Algorithm check');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q=qnorm([-1 0.5 1 2; 5 6 7 8]), disp(' ')
v=[1 2 3; 4 5 6].', disp(' ')
truth_value = 'qvxform(qconj(q), v)';
test_value  = 'qvrot(q, v)';
failures=failures+check_float(truth_value, test_value, 1e-15);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_num_failures(test_title, failures)
