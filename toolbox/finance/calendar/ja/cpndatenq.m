% CPNDATENQ   確定利付債に対する次回の準クーポン日
%
% この関数は、NUMBONDS だけ存在する確定利付債のセットについて、次回準
% クーポン日を出力します。「次回準クーポン日」とは、第1回のクーポン日が
% 指定されていないと仮定して算定された次回クーポン日のことを指しています。
% この関数は、当該債権の第1回または最終クーポン期間が正常の長さである
% のか、またはそれよりも長い期間、または、短い期間であるのかに関わらず、
% 当該債権について次回準クーポン日を出力します。
%
%   NextQuasiCouponDate = cpndatenq(Settle, Maturity)
%
%   NextQuasiCouponDate = cpndatenq(Settle, Maturity, Period, Basis, 
%                                     EndMonthRule, IssueDate, FirstCouponDate,
%                                     LastCouponDate)
% 入力:  
%   Settle    - 決済日
%   Maturity  - 満期日
%
% 入力(オプション)：
%   Period          - 1年でのクーポン支払回数; デフォルトは2(半年払い)
%   Basis           - 日数のカウント基準; デフォルトは 0 (actual/actual)
%   EndMonthRule    - 月末規則; デフォルトは1(月末規則は有効)
%   IssueDate       - 債権の発行日
%   FirstCouponDate - 不定期または通常の第1回クーポン支払日
%   LastCouponDate  - 不定期または通常の最終クーポン支払日 
%
% 出力: 
%   NextQuasiCouponDate - 
%                     決済日以降の実際の次回準クーポン日の日付からなる
%                     NUMBONDS行1列のベクトルです。決済日がクーポン日
%                     と同一の場合、この関数は決済日を出力しません。
%                     その代わりに、厳密に決済日以降の実際のクーポン日
%                     を出力します。
%
% 注意：[必須]と指定されている全ての引数は、NUMBONDS行1列、または、1行
%   NUMBONDS列のベクトルまたはスカラ引数でなければなりません。オプション
%   となる全ての引数はNUMBONDS行1列、または、1行NUMBONDS列のベクトル、
%   スカラまたは空行列でなければなりません。値の指定のない入力には NaN 
%   を入力ベクトルとして設定してください。日付は、シリアル日付番号または
%   日付文字列です。
%
%   それぞれの入力引数及び出力引数の詳細については、コマンドライン上で
%   'help ftb' + 引数名(たとえば、Settle(決済日)に関するヘルプは、
%   "help ftbSettle" とタイプして参照できます。 
%
% 参考 : CPNDATEN, CPNDATEP, CPNDATEPQ, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%        CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.


% Copyright 1995-2002 The MathWorks, Inc. 
