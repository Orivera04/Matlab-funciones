% GARCH Toolbox
% Version 2.0.1 (R14) 05-May-2004
%
% GARCH Toolbox Structure Interface Functions.
%   garchget   - Access GARCH specification parameters.
%   garchset   - Create or modify GARCH specification structures.
%
% Univariate GARCH Modelling.
%   garchfit   - Univariate GARCH process parameter estimation.
%   garchpred  - Univariate GARCH process forecasting.
%   garchsim   - Univariate GARCH process simulation (Monte Carlo).
% 
% Univariate GARCH Innovations Inference (Inverse/Whitening Filter).
%   garchinfer - Infer GARCH innovations and conditional standard deviations.
%
% Statistics and Tests.
%   aicbic     - Akaike and Bayesian information criteria for model selection.
%   archtest   - Engle's hypothesis test for the presence of ARCH/GARCH.
%   autocorr   - Compute or plot sample auto-correlation function.
%   crosscorr  - Compute or plot sample cross-correlation function.
%   lbqtest    - Ljung-Box Q-statistic lack-of-fit hypothesis test.
%   lratiotest - Likelihood ratio hypothesis test.
%   parcorr    - Compute or plot sample partial auto-correlation function.
%
% Helpers and Utilities.
%   garchar    - Convert finite-order ARMA models to infinite-order AR models.
%   garchma    - Convert finite-order ARMA models to infinite-order MA models.
%   garchcount - Count number of GARCH process estimated parameters.
%   garchdisp  - Display GARCH process estimation results.
%   lagmatrix  - Create a lagged time series regression matrix.
%   price2ret  - Convert a price series to a return series.
%   ret2price  - Convert a return series to a price series.
%
% Graphics.
%   garchplot  - Plot GARCH simulation, estimation, or forecasting results.
%


% Copyright 1999-2004 The MathWorks, Inc.
% Generated from Contents.m_template revision 1.1.6.1   $Date: 2003/05/08 21:45:12 $
