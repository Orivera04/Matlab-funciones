% Financial Toolbox demonstration functions.
% 
% Financial charting and display.
%   finchart     - Financial Expo financial charts.  
%   charhelp     - Help for financial charts demonstration.
%   timeser      - Convert XData of time series plot to correct date values.
%   cfplot       - Visualize sets of cash flows.
%   dtaxis       - Sync axis date ticks to plot data.
% 
% Option demonstrations.
%   blsdemos     - Gateway to option pricing, hedging, and implied volatility.
%   oneopt       - Option pricing and sensitivities.
%   payoff       - Option portfolio hedging.
%   smile        - Implied volatility from option prices.
%   advgreek     - Financial Expo option portfolio sensitivities.
%   greekdem     - Financial Expo single option sensitivities.
%   seoption     - Calculates sensitivity measures of portfolio of options.
% 
% Portfolio optimization demonstrations and functions
%   capaldemo    - Capital allocation demo
%   optport      - Portfolio optimization demonstration.
%   portopt.xls  - Excel spreadsheet for portfolio optimization.
%   frontier     - Efficient frontier.
%   portrand     - Randomized portfolio risks, returns and weights.
%   portror      - Portfolio expected rate of return.
%   portvar      - Portfolio variance.
% 
% Spline Smoothing demonstration.
%   termfit      - Demo function for smoothing rates with splines.
%
% Black-Derman-Toy
%   bdtdemo      - Bond option valuation GUI.
%   plotbintree  - Plot a binary tree.
%
% GARCH
%   garchgui     - GARCH process simulation and forecasting.
%   ugarchplot   - Plot volatility against time series.
%
% Genetic Algorithm demonstration
%   degatool     - Genetic algorithm to optimize a function.
%
% Tutorial example files.
%   ftgex1       - Financial Toolbox graphics example 1.
%   ftgex2       - Financial Toolbox graphics example 2.
%   ftgex3       - Financial Toolbox graphics example 3.
%   ftspex1      - Financial Toolbox solving problems example 1.
%   ftspex2      - Financial Toolbox solving problems example 2.
%   ftspex3      - Financial Toolbox solving problems example 3.
%   ftspex4      - Financial Toolbox solving problems example 4.
%

% $Revision: 1.26 $   $Date: 2002/04/14 21:42:38 $
% Copyright 1995-2002 The MathWorks, Inc. 

% Old functions removed from doc
%   ewcov

% # User and support files for BLSDEMO
% # 07/22/98
% # Kickoff function for the other demos
% toolbox/finance/findemos/blsdemos.m
% # Option price and sensitivities
% toolbox/finance/findemos/oneopt.m
% toolbox/finance/findemos/oneoptfn.m
% toolbox/finance/findemos/oneopth.m
% # Option probabilities and hedging
% toolbox/finance/findemos/payoff.m
% toolbox/finance/findemos/payofffn.m
% toolbox/finance/findemos/payoffh.m
% # Volatility smile
% toolbox/finance/findemos/smile.m
% toolbox/finance/findemos/smilefn.m
% toolbox/finance/findemos/smileh.m
% # Demo helper functions
% toolbox/finance/findemos/axisfn.m
% toolbox/finance/findemos/axisgui.m
% toolbox/finance/findemos/axismenu.m
% toolbox/finance/findemos/gpabout.m
% toolbox/finance/findemos/blslambda1.m
% toolbox/finance/findemos/printfn.m

% # User and support files for BDT demo
% # 05/21/98
% # files to run the BDT demo gui
% toolbox/finance/findemos/bdtdemo.m
% toolbox/finance/findemos/bdteditcreditcurvegui.m
% toolbox/finance/findemos/bdteditvolatilitycurvegui.m
% toolbox/finance/findemos/bdteditzerocurvegui.m
% toolbox/finance/findemos/bdtmainaction.m
% toolbox/finance/findemos/bigplotbdttree.m
% toolbox/finance/findemos/bigplotbond.m
% toolbox/finance/findemos/bigplotcreditcrv.m
% toolbox/finance/findemos/bigplotvolatilitycrv.m
% toolbox/finance/findemos/bigplotzerocrv.m
% toolbox/finance/findemos/bondspecgui.m
% toolbox/finance/findemos/bondspecguicall.m
% toolbox/finance/findemos/getbondgui.m
% toolbox/finance/findemos/getbondguicall.m
% toolbox/finance/findemos/getcreditcrvgui.m
% toolbox/finance/findemos/getcreditcrvguicall.m
% toolbox/finance/findemos/getvolcrvgui.m
% toolbox/finance/findemos/getvolcrvguicall.m
% toolbox/finance/findemos/getzerocrv.m
% toolbox/finance/findemos/getzerocrvgui.m
% toolbox/finance/findemos/getzerocrvguicall.m
% toolbox/finance/findemos/ldcrvstruct.m
% toolbox/finance/findemos/ldoptionbond.m
% toolbox/finance/findemos/ldvolatilitycrv.m
% toolbox/finance/findemos/plotscale.m
% toolbox/finance/findemos/samplecreditcrv.m
% toolbox/finance/findemos/sampleoptionbond.m
% toolbox/finance/findemos/samplevolcrv.m
% toolbox/finance/findemos/samplezerocrv.m
% toolbox/finance/findemos/viewbdttreegui.m
% toolbox/finance/findemos/viewbondgui.m
% toolbox/finance/findemos/viewcreditcrvgui.m
% toolbox/finance/findemos/viewvolatilitycrvgui.m
% toolbox/finance/findemos/viewzerocrvgui.m
% -b toolbox/finance/findemos/bdtdemo.mat
% -b toolbox/finance/findemos/bdteditcreditcurvegui.mat
% -b toolbox/finance/findemos/bdteditvolatilitycurvegui.mat
% -b toolbox/finance/findemos/bdteditzerocurvegui.mat
% -b toolbox/finance/findemos/bondspecgui.mat
% -b toolbox/finance/findemos/getbondgui.mat
% -b toolbox/finance/findemos/getcreditcrvgui.mat
% -b toolbox/finance/findemos/getvolcrvgui.mat
% -b toolbox/finance/findemos/getzerocrv.mat
% -b toolbox/finance/findemos/getzerocrvgui.mat
% -b toolbox/finance/findemos/samplecreditcrv.mat
% -b toolbox/finance/findemos/sampleoptionbond.mat
% -b toolbox/finance/findemos/samplevolcrv.mat
% -b toolbox/finance/findemos/samplezerocrv.mat
% -b toolbox/finance/findemos/viewbdttreegui.mat
% -b toolbox/finance/findemos/viewbondgui.mat
% -b toolbox/finance/findemos/viewcreditcrvgui.mat
% -b toolbox/finance/findemos/viewvolatilitycrvgui.mat
% -b toolbox/finance/findemos/viewzerocrvgui.mat

