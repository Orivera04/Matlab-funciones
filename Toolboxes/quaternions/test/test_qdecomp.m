%TEST_QDECOMP runs unit tests for the QDECOMP function.

% Release: $Name: quaternions-1_2_2 $
% $Revision: 1.5 $
% $Date: 2001/05/01 20:20:33 $

% Copyright (C) 2001 by Jay A. St. Pierre.  All rights reserved.

test_title = 'qdecomp';
disp_test_title(test_title);

failures=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Insufficient Arguments');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expected_err = 'qdecomp() requires one input argument';
fct_call     = 'qdecomp';
failures=failures+check_err(fct_call, expected_err);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Invalid Input: scalar');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expected_err = ...
    ['Input Q must be a quaternion or a vector of quaternions'];
fct_call     = 'qdecomp(1)';
failures=failures+check_err(fct_call, expected_err);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('q=[0 0 0 1]');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test values
test_string='[test_v, test_phi] = qdecomp([0 0 0 1])';
disp(test_string), eval(test_string), disp(' ')
% phi
truth_value = '0';
test_value  = 'test_phi';
failures=failures+check_float(truth_value, test_value, 1e-15);
% v
truth_value = '[0 0 0]';
test_value  = 'test_v';
failures=failures+check_float(truth_value, test_value, 1e-15);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Column of three quaternions');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q1=qnorm([ 1 2.0 3  4]),disp (' ')
q2=[0 0 0 1],disp (' ')
q3=qnorm([-1 0.5 2 -2]),disp (' ')
% Test values
test_string='[test_v, test_phi] = qdecomp([q1; q2; q3])';
disp(test_string), eval(test_string), disp(' ')
% phi
truth_phi = [ ...
    '[ 2*acos(q1(4))', 10, ...
    '  0',             10, ...
    '  2*acos(q3(4)) ]'], disp(' ')
truth_phi = eval(truth_phi);
truth_value = 'truth_phi';
test_value  = 'test_phi';
failures=failures+check_float(truth_value, test_value, 1e-15);
% v
truth_v = [ ...
    '[ [q1(1) q1(2) q1(3)]/sin(acos(q1(4)))', 10, ...
    '  [0 0 0]',                              10, ...
    '  [q3(1) q3(2) q3(3)]/sin(acos(q3(4))) ]'], disp(' ')
truth_v = eval(truth_v);
truth_value = 'truth_v';
test_value  = 'test_v';
failures=failures+check_float(truth_value, test_value, 1e-15);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Row of 6 quaternions');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test values
test_string='[test_v, test_phi] = qdecomp([q1; q2; q3; q3; q2; q1].'')';
disp(test_string), eval(test_string), disp(' ')
% phi
truth_phi = [ ...
    '[ 2*acos(q1(4))', 10, ...
    '  0',             10, ...
    '  2*acos(q3(4))', 10, ...
    '  2*acos(q3(4))', 10, ...
    '  0',             10, ...
    '  2*acos(q1(4)) ]'], disp(' ')
truth_phi = eval(truth_phi);
truth_value = 'truth_phi';
test_value  = 'test_phi';
failures=failures+check_float(truth_value, test_value, 1e-15);
% v
truth_v = [ ...
    '[ [q1(1) q1(2) q1(3)]/sin(acos(q1(4)))', 10, ...
    '  [0 0 0]',                              10, ...
    '  [q3(1) q3(2) q3(3)]/sin(acos(q3(4)))', 10, ...
    '  [q3(1) q3(2) q3(3)]/sin(acos(q3(4)))', 10, ...
    '  [0 0 0]',                              10, ...
    '  [q1(1) q1(2) q1(3)]/sin(acos(q1(4))) ]'], disp(' ')
truth_v = eval(truth_v);
truth_value = 'truth_v';
test_value  = 'test_v';
failures=failures+check_float(truth_value, test_value, 1e-15);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Ambiguous Input: 4x4, check result for validity');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test values
test_string='[test_v, test_phi] = qdecomp([q1; q3; q1; q2])';
disp(test_string), eval(test_string), disp(' ')
% phi
truth_phi = [ ...
    '[ 2*acos(q1(4)) ', 10, ...
    '  2*acos(q3(4)) ', 10, ...
    '  2*acos(q1(4)) ', 10, ...
    '  0            ]'], disp(' ')
truth_phi = eval(truth_phi);
truth_value = 'truth_phi';
test_value  = 'test_phi';
failures=failures+check_float(truth_value, test_value, 1e-15);
% v
truth_v = [ ...
    '[ [q1(1) q1(2) q1(3)]/sin(acos(q1(4))) ', 10, ...
    '  [q3(1) q3(2) q3(3)]/sin(acos(q3(4))) ', 10, ...
    '  [q1(1) q1(2) q1(3)]/sin(acos(q1(4))) ', 10, ...
    '  [0 0 0]                             ]'], disp(' ')
truth_v = eval(truth_v);
truth_value = 'truth_v';
test_value  = 'test_v';
failures=failures+check_float(truth_value, test_value, 1e-15);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Ambiguous Input: 4x4');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expected_warn = ['Component quaternion shape indeterminate... assuming' ...
                 ' row vectors'];
fct_call      = 'qdecomp(0.5*ones(4,4));';
failures=failures+check_warn(fct_call, expected_warn);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp_num_failures(test_title, failures)


