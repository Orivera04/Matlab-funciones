function varargout = portalloc(PortRisk, PortReturn, PortWts, RisklessRate, BorrowRate, RiskAversion)
%PORTALLOC Capital allocation to efficient frontier portfolios.
%   Given user-specified standard deviations, expected returns, and weights of
%   NPORTS efficient frontier portfolios of risky assets, and the risk-free
%   rate, calculate the optimal risky portfolio and the optimal allocation of
%   funds between that risky portfolio of NASSETS and the risk-free asset.
%
%   [RiskyRisk, RiskyReturn, RiskyWts, RiskyFraction, OverallRisk, ...
%     OverallReturn] = portalloc(PortRisk, PortReturn, PortWts, RisklessRate)
%
%   [RiskyRisk, RiskyReturn, RiskyWts, RiskyFraction, OverallRisk, ...
%     OverallReturn] = portalloc(PortRisk, PortReturn, PortWts, ...
%     RisklessRate, BorrowRate, RiskAversion)
%
% Optional Inputs: BorrowRate, RiskAversion
%
% Inputs:
%   PortRisk - NPORTS by 1 vector of risky asset efficient frontier portfolio
%     standard deviations.
%
%   PortReturn - NPORTS by 1 vector of risky asset efficient frontier portfolio
%     expected returns.
%
%   PortWts - NPORTS by NASSETS matrix of weights allocated to each asset. Each
%     row represents an efficient frontier portfolio of risky assets. The sum
%     of all weights of each portfolio is 1 (sum-to-one budget constraint).
%
%   RisklessRate - Risk free lending rate, expressed as a scalar decimal.
%
% Optional Inputs:
%   BorrowRate - Borrowing rate, expressed as a scalar decimal. If borrowing is
%     not desired, or not an option, set this to NaN. The default is NaN.
%
%   RiskAversion - Scalar coefficient of investor degree of risk aversion
%     applied to a quadratic utility function. The higher this number, the more
%     averse an investor is to risk. Typical risk aversion coefficient range
%     between 2 and 4. The default is 3.
%
% Outputs:
%   RiskyRisk - Standard deviation of the optimal risky portfolio.
%
%   RiskyReturn - Expected return of the optimal risky portfolio.
%
%   RiskyWts - 1 by NASSETS vector of weights allocated to the assets in the
%     optimal risky portfolio. The total of all weights in the portfolio is 1.
%
%   RiskyFraction - Fraction of the complete portfolio (i.e., the overall
%     portfolio including risky and risk-free assets) allocated to the risky
%     portfolio.
%
%   OverallRisk - Standard deviation of the optimal overall portfolio.
%
%   OverallReturn - Expected rate of return of the optimal overall portfolio.
%
% Note:
%   If invoked without any output arguments, a graph of the optimal capital
%   allocation decision is displayed.
%
% See also PORTOPT, FRONTCON, PORTSTATS, EWSTATS
%
% Reference: Bodie, Kane, and Marcus, Investments, 2nd Ed., Chapters 6 & 7.

%  Author(s): M. Reyes-Kattar, 02/15/98
%  Copyright 1995-2003 The MathWorks, Inc.
%  $Revision: 1.13.2.1 $   $ Date: 1998/01/30 13:45:34 $

% Check for input errors

if (nargin < 4)
    error('Finance:portalloc:NotEnoughInputs', ...
        'You must enter PortRisk, PortReturn, PortWts, and RisklessRate.');
end

if (nargin < 5 || isempty(BorrowRate))
    BorrowRate = NaN;
end

if (nargin < 6 || isempty(RiskAversion))
    RiskAversion = 3;
end

if(RisklessRate > BorrowRate)
    error('Finance:portalloc:NotLargeEnough', ...
        'Borrowing rate must equal or exceed the risk-free rate.');
end

if(RisklessRate <= 0 || BorrowRate <= 0 || RiskAversion <= 0)
    error('Finance:portalloc:NonPositiveInput', ...
        'RisklessRate, BorrowRate, and RiskAversion must be positive.');
end

RATE = RisklessRate;
PP   = spline(PortReturn, PortRisk);         % PP = f(x)
DPP  = ppdiff(PP);

% Find the risk at the optimal point (tangent point) using fzero.
% check starting points
RetMin = max(RisklessRate+eps, min(PortReturn));
RetMax = max(PortReturn);
if portalloptpoint(RetMin, PP, DPP, RATE) >= 0
    % min point
    return_p = RetMin;

elseif portalloptpoint(RetMax, PP, DPP, RATE) <= 0
    % max point
    return_p = RetMax;

else
    % search along the frontier
    FZoptions = optimset('Display','none');

    try
        [return_p, fval, eflag] = fzero(@portalloptpoint, ...
            [max([PortReturn(1),RisklessRate+eps])  PortReturn(end)], ...
            FZoptions, PP, DPP, RATE);
    catch
        error('Finance:portalloc:TangencyFailure', ...
            'Unable to compute tangent to the frontier.')
    end

    if (eflag<0)
        error('Finance:portalloc:TangencyFailure', ...
            'Unable to compute tangent to the frontier.')
    end

end

if(isnan(return_p))
    error('Finance:portalloc:OptimalPointFailure', ...
        'Unable to find optimal point.');
end

% Expected Risk of the optimal point.
risk_p = ppval(PP, return_p);

RiskyRisk = risk_p;
RiskyReturn = return_p;

% We now find the point of tangency between the CAL
% and the indifference curve.
RiskyFraction = (return_p - RisklessRate)/(RiskAversion*(risk_p^2));
return_c = RisklessRate + RiskyFraction*(return_p - RisklessRate);
risk_c = RiskyFraction*risk_p;
cal  = 'cal1';
% The values above correspond to CAL1

if( risk_c > risk_p ) % We're above P.

    if(~isnan(BorrowRate))
        if(RisklessRate ~= BorrowRate) % Portfolio BB (CAL2)
            % Find the new Xp.
            RATE = BorrowRate;

            try
                [return_p, fv ,eflag] = fzero(@portalloptpoint, ...
                    [max([PortReturn(1),BorrowRate+eps]) PortReturn(end)], ...
                    FZoptions, PP, DPP, RATE);
            catch
                error('Finance:portalloc:IndifferenceFailure', ...
                    'Unable to compute indifference curve tangency portfolio.')
            end

            if (eflag<0)
                error('Finance:portalloc:TangencyFailure', ...
                    'Unable to compute tangent to the frontier.')
            end

            if (isnan(return_p))
                error('Finance:portalloc:OptimalPointFailure', ...
                    'Unable to find optimal point.');
            end

            % Expected Risk of the optimal point
            risk_p = ppval(PP, return_p);

            RiskyRisk = risk_p;
            RiskyReturn = return_p;

            % We now find the point of tangency between the CAL2
            % and the indifference curve.
            RiskyFraction = (return_p - BorrowRate)/(RiskAversion*(risk_p^2));
            return_c = BorrowRate + RiskyFraction*(return_p - BorrowRate);
            risk_c = RiskyFraction*risk_p;
            cal = 'cal2';
            if(risk_c < risk_p)      % If Xc is below P2, borrowing is too risky for this customer
                BorrowRate = NaN;     % Act as if borrowing was not desired, and choose a new point
            end                      % on the efficient frontier curve.
        end
    end

    if(isnan(BorrowRate)) % No possibility or desire to borrow.

        AA = RiskAversion;
        try
            [return_c, fv, eflag] = fzero(@portalltanpoint, ...
                [PortReturn(1) PortReturn(end)], FZoptions, PP, DPP, AA);
        catch
            error('Finance:portalloc:IndifferenceFailure', ...
                'Unable to compute indifference curve tangency portfolio.')
        end

        if (eflag<0)
            error('Finance:portalloc:TangencyFailure', ...
                'Unable to compute tangent to the frontier.')
        end

        if(isnan(return_c))
            error('Finance:portalloc:OptimalPointFailure', ...
                'Unable to find optimal point.');
        end

        risk_c = ppval(PP, return_c);
        RiskyFraction = 1;          % All the money goes to the risky asset.

        % The optimal risky portfolio, and the overall risk, are the same.
        RiskyRisk = risk_c;
        RiskyReturn = return_c;
        cal = [];
    end
end

OverallRisk = risk_c;
OverallReturn = return_c;

% Calculate the weights by interpolation.
RiskyWts = interp1(PortReturn, PortWts, RiskyReturn);

%RiskAversion plot of the optimal overall portfolio and the efficient frontier
%is returned if the function is invoked without output arguments.
if nargout == 0
    FrontWin = figure;
    set(FrontWin,'NumberTitle','off');
    set(FrontWin,'Name','Capital Allocation');
    set(FrontWin,'Resize','on');
    set(FrontWin,'Tag','FrontWin');

    hEff = plot(PortRisk, PortReturn);
    hold on
    hOverall = plot(OverallRisk, OverallReturn,'r+') ;
    hRisky = plot(RiskyRisk, RiskyReturn,'k*') ;
    if(strcmp(cal, 'cal1'))
        plot([0, RiskyRisk], [RisklessRate, RiskyReturn], 'm');
        if(OverallRisk > RiskyRisk)
            plot([RiskyRisk, OverallRisk], [RiskyReturn, OverallReturn], '--m');
        end
    else
        if(strcmp(cal, 'cal2'))
            plot([0, RiskyRisk], [BorrowRate, RiskyReturn], '--m');
            plot([RiskyRisk, OverallRisk], [RiskyReturn, OverallReturn], 'm');
        end
    end
    l = get(gca, 'xlim');
    l(1) = 0;
    set(gca, 'xlim', l);
    legend([hOverall hRisky], 'Optimal Overall Portfolio', 'Optimal Risky Portfolio', 0);

    title('Optimal Capital Allocation');
    xlabel('Risk (Standard Deviation)');
    ylabel('Expected  Return');
    grid on;

else
    varargout  =  {RiskyRisk, RiskyReturn, RiskyWts, RiskyFraction, ...
        OverallRisk, OverallReturn};
end



function dpp = ppdiff(pp)
% dpp = ppdiff(pp) differentiate a piecewise polynomial (such as generated
% by pp = spline(x,y);

% JHA 8/26/96

[breaks,coefs,l,k] = unmkpp(pp);

pows = (k-1:-1:1);

dcoefs = coefs(:,1:k-1).*pows(ones(l,1),:);

dpp = mkpp(breaks,dcoefs);


function err = portalltanpoint(x, PP, DPP, AA)
%  This function is called by fzero. This is a private function callable
%  only through the PORTALLOC function.
%  Indifference curve-> Return = U + 0.5A*Risk^2
%  f1(x) = U + 0.5Ax^2 -> indifference curve
%  f2(x) = efficient frontier curve
%  err = d(f1(x))/dx - d(f2(x))/dx

%  Author(s): M. Reyes-Kattar, 02/05/98

err = 1/(AA*ppval(PP,x)) - ppval(DPP,x);


function err = portalloptpoint(x, PP, DPP, RATE)
%  This function is called by fzero. This is a private function callable
%  only through the PORTALLOC function.
%  err = f'(x) - f(x)/(x - RATE)
%  We want to find x, so that err = 0

%  Author(s): M. Reyes-Kattar, 02/05/98

err = ppval(DPP, x) - ppval(PP,x)/(x - RATE);


% [EOF]

