% PAYPER   貸付、または、年金の定期支払額
%
% P = PAYPER(RATE,NPER,PV,FV,DUE) は、貸付、または、年金の定期支払額を
% 出力します。RATE は定期利率、NPER は支払期間数、PV は現在価値、FV は
% 将来価値、または、NPER 期間後の残高、DUE は、支払いが期間の初日に行わ
% れる (DUE = 1) か、末日 (DUE = 0) に行われるかを指定します。デフォルト
% は、FV = 0 と DUE = 0 です。
%
% 例題：
% 年利11.75%の$9000の3年貸付に対して毎月の支払額を求めます。
% 
%       p = payper(.1175/12,36,9000,0,0)
% 
% この結果、p = 297.86 が出力されます。
%
% 参考 : AMORTIZE, PAYADV, PAYODD, FVFIX, PVFIX.


%       Author(s): C.F. Garvin, 2-23-95
%       Copyright 1995-2002 The MathWorks, Inc. 
