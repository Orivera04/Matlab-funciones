% BNDDURP   与えられた価格からの債券のデュレーション
%
% この関数は、NUMBONDS 確定利付債権のMacaulayデュレーション及び修正
% デュレーションをそれぞれの債券のクリーン価格から計算します。この関数は、
% 債券のクーポン構造が最初か最後の期間が短期、または、長期である場合
% でも、債券のデュレーションを計算することができます(すなわち、クーポン
% 構造が満期と同期しているかどうかにかかわらず債券のデュレーションを計算
% できます)。この関数は、ゼロクーポン債の Macaulay 及び修正デュレーション
% の計算も可能にします。
%
%   [ModDuration, YearDuration, PerDuration] = ....
%         bnddurp(Price, CouponRate, Settle, Maturity)
%
%   [ModDuration, YearDuration, PerDuration] = .....
%         bnddurp(Price, CouponRate, Settle, Maturity, ....
%         Period, Basis, EndMonthRule, IssueDate,...
%         FirstCouponDate, LastCouponDate, StartDate, Face)
%
% 入力: [必須]と指定されている全ての引数は、NUMBONDS行1列、または、1行
% NUMBONDS列のベクトル、または、スカラ引数です。オプションの引数は全て
% NUMBONDS行1列、または、1行NUMBONDS列のベクトル、スカラ、または、空行列
% となります。入力(オプション)は、空行列によって省略することもできます。
% さらに入力(オプション)の中で、引数リストの末尾に位置する入力は割愛する
% こともできます。入力(オプション)の値をデフォルト値に設定するには、
% NaN値を入力値として設定してください。日付引数は、シリアル日付番号
% または、日付文字列です。SIA確定利付債権の引数に関する詳細については、
% 'help ftb'とタイプしてください。
% ある特定の引数に関する詳細、たとえば、Settleは、"help ftbSettle"と
% タイプすれば参照できます。
% 
%  Price (必須)      - クリーン価格
%  CouponRate (必須) - 10進法で表記されたクーポン利率
%  Settle (必須)     - 決済日
%  Maturity (必須)   - 満期日
%
% 入力(オプション)：
%  Period          - 1年でのクーポン支払回数; デフォルトは2(半年払い)
%  Basis           - 日数のカウント基準; デフォルトは 0 (actual/actual)
%  EndMonthRule    - 月末規則; デフォルトは1(月末規則は有効)
%  IssueDate       - 債権の発行日
%  FirstCouponDate - 不定期、または、通常の第1回クーポン支払日
%  LastCouponDate  - 不定期、または、通常の最終クーポン支払日 
%  StartDate       - 支払いを前もってスタートさせる日付(バージョン2.0で
%                    は無視されます)
%  Face            - 債券の額面価値。デフォルトは100です。
%
% 出力:   
% ModifiedDuration - 修正デュレーション
% YearDuration     - 年単位の Macaulay デュレーション
% PerDuration      - 期間 Macaulay デュレーション
%         
% 出力は、NUMBONDS行1列のベクトルです。
%
% 参考 : BNDDURY, BNDCONVY, BNDCONVP.


%   Author(s): C. Bassignani, M. Reyes-Kattar 07-29-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
