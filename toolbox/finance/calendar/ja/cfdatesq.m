% CFDATESQ   確定利付証券の準(quasi)クーポン支払日
%
% この関数は、NUMBONDS だけ存在する確定利付証券について、準(quasi)
% クーポン支払日の日付行列を出力します。連続する準クーポン日付は、確定
% 利付証券の標準クーポン期間の長さを決定します。ただし、準クーポン日付が
% 実際のクーポン支払日と必ずしも一致するとは限りません。準クーポン日は、
% 第1または最終クーポン期間が通常の長さであるのか、それとも通常よりも
% 長い(または短い)期間であるのかにかかわらず確定されます。デフォルト
% では、決済日の後及び、満期日または満期日より前に到来する準クーポン日が
% 出力されます。
% 
%   QuasiCouponDates = cfdatesq(Settle, Maturity)
%
%   QuasiCouponDates = cfdatesq(Settle, Maturity, Period, Basis, 
%                               EndMonthRule, IssueDate, FirstCouponDate, 
%                               LastCouponDate, PeriodsBeforeSettle, 
%                               PeriodsAfterMaturity)
% 入力: 
%   Settle   - 決済日
%   Maturity - 満期日
%
% 入力(オプション):
%   Period               - 1年でのクーポン支払回数; デフォルトは2
%                          (半年払い)
%   Basis                - 日数のカウント基準; デフォルトは0 
%                          (actual/actual)
%   EndMonthRule         - 月末規則; デフォルトは1(月末規則は有効)
%   IssueDate            - 証券の発行日
%   FirstCouponDate      - 不定期または通常の第1回クーポン支払日
%   LastCouponDate       - 不定期または通常の最終クーポン支払日 
%   PeriodsBeforeSettle  - 算入の対象となる決済日と同じ日付に到来する
%                          準クーポン日、または、決済日より前に到来する
%                          準クーポン日の数(非負の整数)。デフォルトは0
%   PeriodsAfterMaturity - 算入の対象となる満期日よりも後に到来する
%                          準クーポン日の数(非負の整数)。デフォルトは0
%
% 出力: 
%   QuasiCouponDates - シリアルデート形式で表示された準クーポン日付行列
%     です。QuasiCouponDates行列の行の数は、NUMBONDSで、列の数は、債券
%     ポートフォリオを保有することにより要求される準クーポン日数の最大値
%     によって決定されます。準クーポン日の数が、QuasiCouponDates行列の
%     列の数によって示される最大値より少ない債券については、NaN値によって
%     桁揃えが行われます。デフォルトでは、決済日の後、及び、満期日または
%     満期日より前に到来する準クーポン日が出力されます。決済日が満期日と
%     同時に到来し、満期日が 準クーポン日となっているケースでは、満期日が
%     出力されます。
%
% 注意：[必須]と指定されている全ての引数は、NUMBONDS行1列、または1行
%   NUMBONDS列のベクトルまたはスカラ引数となります。オプションとなる
%   全ての引数はNUMBONDS行1列、または、1行NUMBONDS列のベクトル、スカラ
%   または空行列のいずれかとなります。値の指定のない入力には NaN を入力
%   ベクトルとして設定してください。日付は、シリアル日付番号または日付
%   文字列です。
%
%   それぞれの入力引数及び出力引数の詳細については、コマンドライン上で
%   'help ftb' + 引数名(たとえば、Settle(決済日)に関するヘルプは、
%   "help ftbSettle"とタイプして得られます)。
%
% 参考 : CFAMOUNTS, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, 
%        CPNDAYSP CPNPERSZ, CPNCOUNT, ACCRFRAC, CFTIMES.


% Copyright 1995-2002 The MathWorks, Inc. 
