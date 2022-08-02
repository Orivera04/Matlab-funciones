% BLKIMPV   Blackのインプライド・ボラティリティ
%
% V = BLKIMPV(F, X, R, T, CALL, MAXITER, TOL) は、将来のスポット価格 F、
% 将来のコールオプション権利行使価格 X、安全利子率 R、オプションの行使
% 期間 T、将来のコールオプション価格 CALL で与えられた将来の価格の
% インプライド・ボラティリティを出力します。
% MAXITER は、V に対する解で用いられる最大反復回数です。
% デフォルトでは、MAXITER=50 です。TOL は収束の許容誤差で、デフォルトは
% 1e-6 です。
%
% 注意: R と T が同じ期間に基づいていることを確かめてください。すなわち、
% R が年率の場合、T は年表示でなければなりません。
%
% 例題:  スポット価格を$104.125とし、コールオプション権利行使価格を$104、
%        安全利子率を6.33%の年率で、行使期間を66日、そしてコールオプション
%        価格を$1.515625としたときの将来のインプライド・ボラティリティを
%        計算します。
%
%             v = blkimpv(104.125, 104, 0.0633, 66/365, 1.515625)
%             v =
%                     0.0833
%
% 参考 : BLKPRICE, BLSPRICE, BLSIMPV.
%
% 参考文献 : Hull, Options, Futures and Other Derivative Securities, 
%            2nd Edition, page 259-264. 
%            Chriss, Black-Scholes and Beyond: Option Pricing Models,
%            Chapter 4 and 8.


%   Author(s): P.N.Secakusuma, 12-15-2000, M. Reyes-Kattar 1-22-2002
%   Copyright 1995-2002 The MathWorks, Inc.  
