% INSTARGOPTBND   'Type','Bond' 引数の検証を行うサブルーチン
%
% この関数は、処理ルーチンの最初で実行されます。
%
%   [OptSpec, Strike, ExerciseDates, AmericanOpt, CouponRate, ....
%        Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
%           FirstCouponDate, LastCouponDate, StartD, Face] = ....
%              instargoptbnd(ArgList{:})
%
% 入力: 
%   ArgList{:} 出力と1対1で処理される引数を入力します。
%
% 出力: 
%  OptSpec           - 文字列 'call'、または、'put' からなる NINST 行1列
%                      のセル配列
%  Strike            - 権利行使価格の値からなる NINST 行 NSTRIKES 列の
%                      セル配列
%  ExerciseDates     - 権利行使日付を示すNINST 行 NSTRIKES 列、または、
%                      NINST 行 2 列のセル配列
%  AmericanOpt       - フラグ0、または、1を示す NINST 行1列のセル配列
%  CouponRate        - 10進法表記でのクーポンレート
%  Settle            - 決済日
%  Maturity          - 満期日
%  Period            - 年あたりのクーポン支払い回数(デフォルトは2)
%  Basis             - 日数カウント基準。デフォルトは0 (actual/actual)
%  EndMonthRule      - 月末ルール。デフォルトは1(月末ルールは有効)
%  IssueDate         - 債券の発行日
%  FirstCouponDate   - 不定期、または、通常の第一回クーポン支払日
%  LastCouponDate    - 不定期、または、通常の最終クーポン支払日
%  StartDate         - 支払いの先スタート日(2.0ではこの引数の入力は無視
%                      されます)。
%  Face              - 債券の額面価値。デフォルトは100です。
% 
% 参考 : INSTBOND, INSTOPTBND.


%   Author(s): J. Akao 04-May-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
