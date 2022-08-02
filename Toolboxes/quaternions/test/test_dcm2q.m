%TEST_DCM2Q runs unit tests for the DCM2Q function.

% Release: $Name: quaternions-1_2_2 $
% $Revision: 1.4 $
% $Date: 2001/05/01 20:20:32 $

% Copyright (C) 2001 by Jay A. St. Pierre.  All rights reserved.

test_title = 'dcm2q';
disp_test_title(test_title);

failures=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Insufficient Arguments');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expected_err = 'dcm2q() requires one input argument';
fct_call     = 'dcm2q';
failures=failures+check_err(fct_call, expected_err);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Invalid Input: scalar');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
expected_err = ['Invalid input: must be a 3x3xN array'];
fct_call     = 'dcm2q(1)';
failures=failures+check_err(fct_call, expected_err);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp_test_name('Algorithm');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Q=qnorm(2*rand(10,4)-1);
% make sure all quaternions have q4>0
for count=1:10
  if Q(count,4)<0
    Q(count,:)=-Q(count,:);
  end
end
Q, disp(' ')

A='q2dcm(Q)', disp(' ')
A=eval(A);

Q2='dcm2q(A)', disp(' ')
Q2=eval(Q2);

qdiff='qmult(qconj(Q2),Q)', disp(' ')
qdiff=eval(qdiff);

truth_value = '1';
test_value  = 'sqrt(sum(qdiff.^2,2))';
failures=failures+check_value(truth_value, test_value);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp_num_failures(test_title, failures)

