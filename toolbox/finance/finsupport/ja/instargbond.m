% INSTARGBOND   'Type','Bond' 引数の検証を行うサブルーチン
%
% この関数は、処理ルーチンの最初に実行されます。
%
%   [CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, ....
%    IssueDate, FirstCouponDate, LastCouponDate, StartDate, Face] = ...
%          instargbond(ArgList{:})
%
% 入力: 
% ArgList{:} 出力と1対1で処理される引数を入力します。
%
% 出力: 
% 出力は、適合する NINST 行1列のベクトルとなります。SIA 確定利付け証券の
% 引数の詳細については、"help ftb"とタイプしてください。
%
%       CouponRate        - 10進法表記でのクーポンレート
%       Settle            - 決済日
%       Maturity          - 満期日
%       Period            - 年あたりのクーポン支払い回数(デフォルトは2)
%       Basis             - 日数カウント基準。デフォルトは0 
%                           (actual/actual)
%       EndMonthRule      - 月末ルール。デフォルトは1(月末ルールは有効)
%       IssueDate         - 債券の発行日
%       FirstCouponDate   - 不定期、または、通常の第一回クーポン支払日
%       LastCouponDate    - 不定期、または、通常の最終クーポン支払日
%       StartDate         - 支払いをあらかじめスタートさせる日付
%  　　　　　　　　　       (2.0ではこの引数の入力は無視されます)。
%       Face              - 債券の額面価値。デフォルトは100です。
%   
% 参考 : INSTBOND.


%   Author(s): J. Akao 19-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
