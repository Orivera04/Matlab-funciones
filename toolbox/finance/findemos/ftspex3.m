%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename FTSPEX3.M
% Financial Toolbox Solving Problems Example 3:
% Visualizing the Sensitivity of a Bond Portfolio's Price
% to Parallel Shifts in the Yield Curve.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.11 $   $Date: 2002/04/14 21:43:02 $

%
% STEP 1.
%
% Specify SIA-compliant bond information. Accept default values for 
% end-of-month payment rule (1 = end-of-month rule in effect) and 
% day-count basis (0 = actual/actual). Also, synchronize the coupon 
% payment structure to the maturity date (i.e., leave the first 
% and last coupon date unspecified for simplicity).
%

settle     = '15-Jan-1995';
maturity   = datenum(['03-Apr-2020' ; '14-May-2025' ; '09-Jun-2019' ; '25-Feb-2019']);
Face       = [1000 ;  1000  ;  1000 ;  1000];
couponRate = [  0  ;  0.05  ;    0  ; 0.055];
periods    = [  0  ;   2    ;    0  ;    2 ];

%
% Now specify the points on the yield curve for each bond.
%

yields = [0.078 ; 0.09 ; 0.075 ; 0.085];

%
% STEP 2.
%
% Compute the true (i.e., dirty) prices as the 
% sum of the quoted price plus accrued interest.
%

[cleanPrice, accruedInterest] = bndprice(yields , couponRate, settle, maturity, ...
                                         periods, [], [], [], [] , [], [] , Face);

prices  =  cleanPrice + accruedInterest;

%
% STEP 3.
%
% Assuming the value of each bond is $25,000, determine the 
% quantity of each bond such that the portfolio value is $100,000.
%

bondAmounts = 25000 ./ prices;

%
% STEP 4.
%
% Compute the portfolio price for a rolling series of settlement
% dates over a range of yields. The evaluation dates occur annually
% on January 15th, beginning on 15-Jan-1995 (settlement) and 
% extending out to 15-Jan-2018. Thus, this step evaluates portfolio
% price on a grid time progression (dT) and interest rates (dY).
%

dy = -0.05:0.005:0.05;                    % Yield changes.

D  = datevec(settle);                     % Get the date components
dt = datenum(D(1):2018 , D(2) , D(3));    % Get the annual evaluation dates

[dT , dY]  =  meshgrid(dt , dy);          % Create the grid in (x,y) plane

nTimes  =  length(dt);                    % # of time steps
nYields =  length(dy);                    % # of yield changes
nBonds  =  length(maturity);              % # of bonds in the portfolio

prices  = zeros(nTimes*nYields , nBonds); % pre-allocate the price vector

%
% Compute the price of each bond in the 
% portfolio on the grid one bond at a time.
%

for i = 1:nBonds

    [cleanPrice, accruedInterest] = bndprice(yields(i) + dY(:) , couponRate(i), ...
                                             dT(:), maturity(i), periods(i)   , ...
                                             [], [], [], [], [], [], Face(i));

    prices(:,i)  =  cleanPrice + accruedInterest;

end

%
% Scale the bond prices by the quantity of bonds.
%

prices = prices * bondAmounts;

%
% Re-shape the bond values to conform
% to the underlying evaluation grid.
%

prices = reshape(prices , nYields , nTimes);

%
% STEP 5.
%
% Now visualize the surface relative to the
% current portfolio value (i.e., $100,000).
%

figure
surf(dt, dy, prices)

hold on
basemesh = mesh(dt, dy, 100000*ones(nYields, nTimes));

set(basemesh , 'facecolor' , 'none');
set(basemesh , 'edgecolor' , 'm');
set(gca , 'box' , 'on');

dateaxis('x',11);

xlabel('Evaluation Date (YY Format)');
ylabel('Change in Yield');
zlabel('Portfolio Price');
hold off

view(-25,25);