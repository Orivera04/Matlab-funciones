% FIXEDBYZERO   1組のゼロ曲線から確定利付証券の価格を出力
%
%   Price = fixedbyzero(RateSpec, CouponRate, Settle, Maturity)
%
%   Price = fixedbyzero(RateSpec, CouponRate, Settle, Maturity, ...
%                                 Reset, Basis,  Principal)
%
% 入力(必須): 
% この関数の入力は、特に指定がない限り、全てスカラ、または、NINST 行1列
% のベクトルです。日付は、シリアル日付番号、または、日付文字列です。オプ
% ションの引数は、空行列 [] を設定して、デフォルト値を使用することができ
% ます。
%
%   RateSpec     - 年率換算されたゼロ利率期間構造体
%   CouponRate   - 10進法表記のクーポン利率(年率)
%   Settle       - 決済日
%   Maturity     - 満期日
%
% 入力(オプション):
%   Reset        - 年に何回決済日が訪れるかを示す値。デフォルトは1
%   Basis        - 日数のカウント基準。デフォルトは0 (actual/actual).
%   Principal    - 想定元本(名目元本)。デフォルトは100です。
%
% 出力:
%   Price        - 確定利付証券の価格を示すNINST行NUMCURVES列の行列です。
%                  行列の各列がそれぞれ１つのゼロ曲線に対応しています。
%
% 参考 : BONDBYZERO, CFBYZERO, FLOATBYZERO, SWAPBYZERO.


%   Author(s): M. Reyes-Kattar, 07-28-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
