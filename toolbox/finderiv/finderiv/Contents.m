% Financial Derivatives Toolbox
% Version 3.0 (R14) 05-May-2004
%
% Portfolio Hedge Allocation
%   hedgeslf      - Self-financing hedge.
%   hedgeopt      - Optimal hedge trading off cost for sensitivity.
%
% Interest Term Structure
%   intenvset    - Set properties of an interest term structure.
%   intenvget    - Get properties of an interest term structure.
%   rate2disc    - Discounting factors from interest rates.
%   disc2rate    - Interest rates from cash flow discounting factors.
%   ratetimes    - Change time intervals defining interest rate environment.
%
% Pricing and Sensitivity from Interest Term Structure
%   intenvprice  - Instrument prices by term structure.
%   intenvsens   - Instrument sensitivities by term structure.
%   bondbyzero   - Price bonds by a set of zero curves.
%   swapbyzero   - Price swaps by a set of zero curves.
%   fixedbyzero  - Price fixed rate notes by zero curves.
%   floatbyzero  - Price floating rate notes by zero curves.
%   cfbyzero     - Price arbitrary set of cash flows by zero curves.
%
% Pricing and Sensitivity from Heath-Jarrow-Morton Tree
%   hjmprice     - Instrument prices by an HJM tree.
%   hjmsens      - Instrument sensitivities by an HJM tree.
%   hjmtree      - Construct HJM interest rate tree.
%   hjmvolspec   - Specify volatility process.
%   hjmtimespec  - Specify tree time layout.
%
% Heath-Jarrow-Morton Utilities
%   bondbyhjm    - Price bonds by an HJM tree.
%   swapbyhjm    - Price swaps by an HJM tree.
%   capbyhjm     - Price caps by an HJM tree.
%   floorbyhjm   - Price floors by an HJM tree.
%   cfbyhjm      - Price arbitrary set of cash flows by an HJM tree.
%   fixedbyhjm   - Price fixed rate notes by an HJM tree.
%   floatbyhjm   - Price floating rate notes by an HJM tree.
%   optbndbyhjm  - Price bond options by an HJM tree.
%   mmktbyhjm    - Create the money market tree.
%
% Heath-Jarrow-Morton Bushy Tree Manipulation
%   mkbush       - Create an empty bushy tree.
%   bushshape    - Retrieve the shape of a bushy tree.
%   bushpath     - Retrieve entries of a bushy tree.
%   treeviewer   - Display information of a Tree.
%
% Pricing and Sensitivity from Black-Derman-Toy Tree
%   bdtprice     - Instrument prices by a BDT tree.
%   bdtsens      - Instrument sensitivities by a BDT tree.
%   bdttree      - Construct BDT interest rate tree.
%   bdtvolspec   - Specify volatility process.
%   bdttimespec  - Specify tree time layout.
%
% Black-Derman-Toy Utilities
%   bondbybdt    - Price bonds by a BDT tree.
%   swapbybdt    - Price swaps by a BDT tree.
%   capbybdt     - Price caps by a BDT tree.
%   floorbybdt   - Price floors by a BDT tree.
%   cfbybdt      - Price arbitrary set of cash flows by a BDT tree.
%   fixedbybdt   - Price fixed rate notes by a BDT tree.
%   floatbybdt   - Price floating rate notes by a BDT tree.
%   optbndbybdt  - Price bond options by a BDT tree.
%   mmktbybdt    - Create the money market tree.
%
% Black-Derman-Toy Recombining Tree Manipulation
%   mktree       - Create an empty recombining tree.
%   treeshape    - Retrieve the shape of a recombining tree.
%   treepath     - Retrieve entries of a recombining tree.
%   treeviewer   - Display information of a Tree.
%
% Pricing and Sensitivity from Cox-Ross-Rubinstein Stock Tree
%   crrprice     - Instrument prices by a CRR stock tree.
%   crrsens      - Instrument sensitivities by a CRR stock tree.
%   crrtree      - Construct a CRR stock tree.
%   crrtimespec  - Specify tree time layout.
%
% Cox-Ross-Rubinstein Utilities
%   optstockbycrr  - Price American, European or Bermuda options by a CRR tree.
%   barrierbycrr   - Price barrier options by a CRR tree.
%   asianbycrr     - Price asian options by a CRR tree.
%   lookbackkbycrr - Price lookback options by a CRR tree.
%   compoundbycrr  - Price compound options by a CRR tree.
% 
% Cox-Ross-Rubinstein and Equal Probability Tree Manipulation
%   mktree       - Create an empty recombining tree.
%   treeshape    - Retrieve the shape of a recombining tree.
%   treepath     - Retrieve entries of a recombining tree.
%   treeviewer   - Display information of a Tree.
%
% Pricing and Sensitivity from Equal Probability Stock Tree
%   eqpprice     - Instrument prices by a EQP stock tree.
%   eqpsens      - Instrument sensitivities by a EQP stock tree.
%   eqptree      - Construct a EQP stock tree.
%   eqptimespec  - Specify tree time layout.
%
% Equal Probability Utilities
%   optstockbyeqp  - Price American, European or Bermuda options by a EQP tree.
%   barrierbyeqp   - Price barrier options by a EQP tree.
%   asianbyeqp     - Price asian options by a EQP tree.
%   lookbackkbyeqp - Price lookback options by a EQP tree.
%   compoundbyeqp  - Price compound options by a EQP tree.
% 
% Instrument Portfolio Handling
%   instbond     - Constructor for the bond instrument.
%   instswap     - Constructor for the swap instrument.
%   instcap      - Constructor for the cap instrument.
%   instfloor    - Constructor for the floor instrument.
%   instoptbnd   - Constructor for the bond option instrument.
%   instcf       - Constructor for the arbitrary cash flow instrument.
%   instfixed    - Constructor for the fixed rate note instrument.
%   instfloat    - Constructor for the floating rate note instrument.
%   instoptstock - Constructor for the stock option instrument.
%   instbarrier  - Constructor for the barrier option instrument.
%   instcompound - Constructor for the compound option instrument.
%   instlookback - Constructor for the lookback option instrument.
%   instlasian   - Constructor for the asian option instrument.
%   instadd      - Constructor gateway for instruments.
%   instaddfield - Field by field constructor for new instruments.
%   instsetfield - Add or reset data for existing instruments.
%   instlength   - Count instruments stored in a variable.
%   insttypes    - List instrument types stored in a variable.
%   instfields   - List fieldnames for a type of instrument.
%   instget      - Retrieve data from an instrument variable.
%   instgetcell  - Retrieve data from an instrument variable into a cell.
%   instfind     - Search instruments for matches.
%   instselect   - Create a subset of instruments by matches.
%   instdelete   - Complement of a subset of instruments by matches.
%   instdisp     - Tabular display of instruments stored in a variable.
%
% Controlling Defaults and Options.
%   derivset     - Create or alter derivatives OPTIONS structure. 
%   derivget     - Get derivatives parameters from OPTIONS structure. 
%
% Financial Object Structures
%   isafin       - True if structure or object is a financial class.
%   classfin     - Create financial structure or return financial class.
%
% Cash Flow Mapping
%   cfport       - Portfolio form of cash flow amounts.
%
% Date function
%   datedisp     - Display date entries.

%   Copyright 1998-2003 The MathWorks, Inc. 
%   Generated from Contents.m_template revision 1.1.6.2  $Date: 2003/10/05 15:11:14 $
