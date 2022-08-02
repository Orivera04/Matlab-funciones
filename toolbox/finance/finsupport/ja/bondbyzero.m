% BONDBYZERO   与えられた1組のゼロ曲線からポートフォリオを構成する債券の
%              価格を出力
%
%   Price = bondbyzero(RateSpec, CouponRate, Settle, Maturity)
%
%   Price = bondbyzero(RateSpec, CouponRate, Settle, Maturity,     ...
%                     Period,     Basis,           EndMonthRule,   ...
%                     IssueDate,  FirstCouponDate, LastCouponDate, ...
%                     StartDate,  Face)
%
% 入力(必須): 
% この関数の入力は、特に指定がない限り、全てスカラ、または、NINST行1列の
% ベクトルです。日付は、シリアル日付番号、または、日付文字列です。オプ
% ションの引数は、空行列[]を設定して、デフォルト値を使用することができ
% ます。
%
%   RateSpec        - 年率換算されたゼロ利率構造体です。
%   CouponRate      - 小数型で入力されたクーポン利率(年率)
%   Settle          - 決済日
%   Maturity        - 満期日
%
% Optional Inputs:
%   Period          - １年当たりのクーポン支払い回数。デフォルトは2です。
%   Basis           - 日数のカウント基準。デフォルトは０(actual/actual)
%                     です。
%   EndMonthRule    - 月末規則。デフォルトは1 (有効)です。
%   IssueDate       - 債券の発行日
%   FirstCouponDate - 不定期の第一回クーポン日
%   LastCouponDate  - 不定期の最終クーポン日
%   StartDate       - 支払いをあらかじめスタートさせる日
%   Face            - 額面価値。デフォルトは100です。
%
% 出力:
%
%   Price           - クリーン債券価格のNINST行NUMCURVES列の行列です。行
%                     列の各列が、それぞれ、1つのゼロ曲線に対応していま
%                     す。
%
%
% 参考 : CFBYZERO, FIXEDBYZERO, FLOATBYZERO, SWAPBYZERO.


%   Author(s): J. Akao, 11-29-1997, 10-15-98, M. Reyes-Kattar
%   Copyright 1995-2002 The MathWorks, Inc. 
