% PAYADV   指定の回数の前払いの定期支払額を出力
%
% P = PAYADV(RATE,NPER,PV,FV,ADV) は、指定の回数の前払いの定期支払額を
% 出力します。RATE は毎期間の貸し出し、または、借り入れ利率、NPER は商品
% 期間における期間数、PV は現在価値、FV は将来価値、または、NPER 期間後
% に達成したい目標価値、ADV は前払いの回数です。支払いが期間の初日に
% 行われる場合には、ADV に1を加算します。
%
% 例題：
% 貸付現在価値が$1000.00で、12ヶ月で全額支払われます。年利は10%で、期間の
% 終わりに3回の支払いが行われます。このデータを使用すると 
% p = payadv(.1/12,12,1000, 0,3) は、定期支払額として p = 85.94 を出力
% します。
%
% 参考 : AMORTIZE, PAYPER, PAYODD.


%       Author(s): C.F. Garvin, 2-23-95
%       Copyright 1995-2002 The MathWorks, Inc. 
