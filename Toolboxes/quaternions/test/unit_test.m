%UNIT_TEST runs unit tests for the Quaternions toolbox.

% Release: $Name: quaternions-1_2_2 $
% $Revision: 1.7 $
% $Date: 2001/12/18 17:32:15 $

% Copyright (C) 2001 by Jay A. St. Pierre.  All rights reserved.

if ~exist('check_value','file')
  error(['You do not appear to have the test_tools toolbox installed,', 10,...
         'which is necessary to run these unit tests.  You should be', 10,...
         'able to get the test_tools toolbox from the same place you', 10,...
         'obtained this toolbox.']);
end

unix('rm -f test.out')
diary test.out

Failures=0;

test_isq;   Failures=Failures+failures;
test_isnormq; Failures=Failures+failures;

test_qconj; Failures=Failures+failures;
test_qnorm; Failures=Failures+failures;
test_qmult; Failures=Failures+failures;

test_qdecomp; Failures=Failures+failures;
test_qvxform; Failures=Failures+failures;
test_qvrot;   Failures=Failures+failures;

test_q2dcm; Failures=Failures+failures;
test_dcm2q; Failures=Failures+failures;

disp_num_failures('All Unit Tests', Failures)

diary off
