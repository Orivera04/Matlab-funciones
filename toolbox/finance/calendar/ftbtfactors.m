function ftbtfactors
%
%TFACTORS refers to the matrix of time factors for a portfolio of bonds. Each
%row in the matrix represents a single bond in the portfolio. Each element
%columnwise in a row represents the time factor of a particular cash flow 
%date of that bond.  The time factor of a cash flow is the time between
%the settlement date and the cash flow date measured in semi-annual
%coupon periods.  Time factors are used in price-yield computations
%to determine the present value of a stream of cash flows.  The term
%"time factor" refers to the exponent, TF, in the following discounting
%equation:
%
%     PV = CF / (1 + z/2)^TF
%
%     where:
%     PV = present value of a cash flow
%     CF = the cash flow amount
%     z = the risk-adjusted annualized rate or yield corresponding to a given
%          cash flow.  The yield is quoted on a semi-annual compounding basis.
%     TF = time factor of a given cash flow.

disp(' ');
disp('Type "help ftbtfactors" for an explanation of TFACTORS');
disp(' ');

%Author(s): C. Bassignani, 03-11-98
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.6 $   $Date: 2002/04/14 21:49:26 $

