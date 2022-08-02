% BNDYIELD   確定利付債権の満期までの利回り
%
% 与えられた SIA 日付パラメータとクリーン価格を有する Numbonds 数の債券
% について、満期利回りを出力します。
%         
%   Yield = bndyield(Price, CouponRate, Settle, Maturity)
%
%   Yield = bndyield(Price, CouponRate, Settle, Maturity, Period,....
%   Basis, EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate,...
%   StartDate, Face)
%
% 入力: [必須]と指定されている全ての引数は、NUMBONDS行1列、または、1行
% NUMBONDS列のベクトル、または、スカラ引数です。オプションの引数は全て
% NUMBONDS行1列、または、1行NUMBONDS列のベクトル、スカラ、または、空行列
% となります。入力(オプション)は、空行列によって省略することもできます。
% さらに入力(オプション)の中で、引数リストの末尾に位置する入力は割愛する
% こともできます。入力(オプション)の値をデフォルト値に設定するには、
% NaN値を入力値として設定してください。日付引数は、シリアル日付番号
% または、日付文字列です。SIA確定利付証券の引数に関する詳細については、 
% 'help ftb'とタイプしてください。
% ある特定の引数に関する詳細、たとえば、Settleは、"help ftbSettle"と
% タイプすれば参照できます。 
%
%  Price(必須)        - 債券のクリーン価格
%  CouponRate (必須)  - 10進法で表記されたクーポン利率
%  Settle (必須)      - 決済日
%  Maturity (必須)    - 満期日
%  Period             - 年あたりのクーポン支払い(デフォルトは2)
%  Basis              - 日数カウント基準。デフォルトは0 (actual/actual)
%  EndMonthRule       - 月末規則。デフォルトは1(月末規則は有効)
%  IssueDate          - 債券の発行日
%  FirstCouponDate    - 不定期、または、通常の第一回クーポン支払日
%  LastCouponDate     - 不定期、または、通常の最終クーポン支払日
%  StartDate          - 支払いの先スタート日
%                      (2.0ではこの引数の入力は無視されます)
%  Face               - 債券の額面価値。デフォルトは100
%
% 入力(オプション):
%  Period             - 1年でのクーポン支払回数(デフォルトは2)
%  Basis              - 日数カウント基準。デフォルトは0 (actual/actual)
%  EndMonthRule       - 月末ルール。デフォルトは1(月末規則は有効)
%  IssueDate          - 債券の発行日
%  FirstCouponDate    - 不定期、または、通常の第1回クーポン支払日
%  LastCouponDate     - 不定期、または、通常の最終クーポン支払日
%  StartDate          - 支払いの先スタート日
%                       (2.0ではこの引数の入力は無視されます)
%  Face               - 債券の額面価値。デフォルトは100
%
% 出力: NumBonds行1列のベクトルでなければなりません。
%  Yield : 半年複利計算の満期利回り
%
% 注意：
%   価格と利回りを関連付けているのは、つぎの公式です。
%
%   価格 + 経過利子 = sum( キャッシュフロー*(1+利回り/2)^(-時間))
%
%  ここで、sum(総和)は、債券のキャッシュフロー及び半年払いクーポン期間
%  を単位にして測定されるキャッシュフローに対応する時間に渡って計算され
%  ます。
%
% 参考 : BNDPRICE, CFAMOUNTS.


%   Author(s): C. Bassignani, 04-25-98
%   Copyright 1995-2002 The MathWorks, Inc. 
