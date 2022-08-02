% BNDDURY 与えられた利回りから債券のデュレーションを計算します。
%
% この関数は、NUMBONDS 確定利付債権の Macaulay デュレーション及び修正デ
% ュレーションをそれぞれの債券の満期までの利回りから計算します。この関数
% は、債券のクーポン構造が最初、または、最後の期間が短期、または、長期で
% ある場合でも、債券のデュレーションを計算することができます(すなわち、
% クーポン構造が満期と同期しているかどうかにかかわらず債券のデュレーショ
% ンを計算できます)。この関数は、ゼロクーポン債の Macaulay 及び修正デュ
% レーションの計算も可能にします。
%
%   [ModDuration, YearDuration, PerDuration] = ....
%            bnddury(Yield, CouponRate, Settle, Maturity)
%
%   [ModDuration, YearDuration, PerDuration] = ....
%            bnddury(Yield, CouponRate, Settle, Maturity, ....
%            Period, Basis, EndMonthRule, IssueDate,....
%            FirstCouponDate, LastCouponDate, StartDate, Face)
%
% 入力: [必須]と指定されている全ての引数は、NUMBONDS行1列、または、1行
% NUMBONDS列のベクトル、または、スカラ引数です。オプションの引数は全て
% NUMBONDS行1列、または、1行NUMBONDS列のベクトル、スカラ、または、空行列
% となります。入力(オプション)は、空行列によって省略することもできます。
% さらに入力(オプション)の中で、引数リストの末尾に位置する入力は割愛する
% こともできます。入力(オプション)の値をデフォルト値に設定するには、
% NaN 値を入力値として設定してください。日付引数は、シリアル日付番号
% または、日付文字列です。SIA確定利付債権の引数に関する詳細については、 
% 'help ftb'とタイプしてください。
% ある特定の引数に関する詳細、たとえば、Settleは、"help ftbSettle"と
% タイプすれば参照できます。
%
%  Yield (必須)      - 半年複利計算の満期利回り
%  CouponRate (必須) - 10進法で表記されたクーポン利率
%  Settle (必須)     - 決済日
%  Maturity (必須)   - 満期日
%
% 入力(オプション):
%  Period          - 1年でのクーポン支払回数(デフォルトは2)
%  Basis           - 日数カウント基準。デフォルトは0 (actual/actual)
%  EndMonthRule    - 月末規則; デフォルトは1(月末規則は有効)
%  IssueDate       - 債券の発行日
%  FirstCouponDate - 不定期、または、通常の第1回クーポン支払日
%  LastCouponDate  - 不定期、または、通常の最終クーポン支払日
%  StartDate       - 支払いを前もってスタートさせる日付
%                    (2.0ではこの引数の入力は無視されます。)
%  Face            - 債券の額面価値。デフォルトは100
%
% 出力:
% ModifiedDuration - 修正デュレーション
% YearDuration     - 年単位の Macaulay デュレーション
% PerDuration      - 期間 Macaulay デュレーション
%         
% 出力は、NUMBONDS行1列のベクトルです。
%
% 参考 : BNDDURP, BNDCONVY, BNDCONVP.


%   Author(s): C. Bassignani, 07-29-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
