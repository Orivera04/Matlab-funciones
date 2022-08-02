% Fixed-Income Toolbox
% Version 1.0.1 (R14) 05-May-2004
%
% Black functions
%   bkcall           - Price of european call on bond.
%   bkcaplet         - Price of caplet with Black's model.
%   bkfloorlet       - Price of floorlet with Black's model.
%   bkput            - Price of european put on bond.
%
% Bond futures
%   convfactor       - Conversion factor to bond of specified coupon.
%   tfutbyprice      - Bond futures implied by spot spot curve and
%                      current bond prices.
%   tfutbyyield      - Bond futures implied by spot curve and current 
%                      bond yields.
%   tfutimprepo      - Bond futures implied repo from traded prices.
%   tfutpricebyrepo  - Bond futures prices given repo/funding rate.
%   tfutyieldbyrepo  - Bond futures yields given repo/funding rate.
%
% CB pricing
%   cbprice          - Price of Convertible Bond with Goldman method.
%
% Certificate of Deposit functions
%   cdai             - Accrued Interest of CD.
%   cdprice          - Price of CD.
%   cdyield          - Yield of CD.
%
% Coupon Bond functions
%   stepcpncfamounts - Cash flow analysis/generator of stepped coupon
%                      bonds.
%   stepcpnprice     - Stepped coupon bond price.
%   stepcpnyield     - Stepped coupon bond yield.
%
% Fixed Rate mortgage pools
%   mbscfamounts     - Passthrough + time information.  
%   mbsconvp         - Convexity given PSA prepayment and price.
%   mbsconvy         - Convexity given PSA prepayment and yield.
%   mbsdurp          - Duration given PSA prepayment and price.
%   mbsdury          - Duration given PSA prepayment and yield.
%   mbsnoprepay      - Regularly amortized cash loans.
%   mbsoas2price     - Price given OAS and benchmark spot curve.
%   mbsoas2yield     - Yield given OAS and benchmark spot curve.
%   mbspassthrough   - Mortgage pools cash flows.
%   mbsprice         - Price under given PSA prepayment.
%   mbsprice2oas     - OAS given Price and benchmark spot curve.
%   mbsprice2speed   - Implied PSA speed given Price.
%   mbswal           - Average life.
%   mbsyield         - Yield under given PSA prepayment.
%   mbsyield2oas     - OAS given Yield and benchmark spot curve.
%   mbsyield2speed   - Implied PSA speed given Yield.
%   psaspeed2rate    - Mortality rate given PSA speed.
%
% General zero coupon functions
%   zeroprice        - Price of zero-coupon bond given its yield.
%   zeroyield        - Yield of zero-coupon bond given its price.
%
% Swap function
%   liborduration    - Duration of pay and receive-fixed sides.
%   liborfloat2fixed - Fixed rate given floating rates.
%   liborprice       - (Re)Valuation of swap given swap rate.
%
% US Tbill functions
%   tbilldisc2yield  - Yields given discount rates.
%   tbillprice       - Price of US T-bills.
%   tbillrepo        - T-bill breakeven repo rate.
%   tbillval01       - value of 1 bp.
%   tbillyield       - Money-market and Bond equivalent yields.
%   tbillyield2disc  - Discount rates given yields.
% 
%   Copyright 2003 The MathWorks, Inc.
%   Generated from Contents.m_template revision 1.1.6.3 $Date: 2003/10/23 12:15:11 $
