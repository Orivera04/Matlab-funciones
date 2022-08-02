% CPNDATEP   確定利付債に対する前回の実際のクーポン日
%
% この関数は、NUMBONDS だけ存在する確定利付債のセットについて、前回の
% クーポン日を出力します。この関数は、当該証券の第1回または最終クーポン
% 期間が正常の長さであるのか、またはそれよりも長い期間または短い期間であ
% るのかに関わらず、当該証券について前回のクーポン日を出力します。ゼロ
% クーポン債については、この関数は満期日を出力します。
%
%   PreviousCouponDate = cpndaten(Settle, Maturity)
%
%   PreviousCouponDate = cpndatep(Settle, Maturity, Period, Basis, 
%                             EndMonthRule, IssueDate, FirstCouponDate,
%                             LastCouponDate)
% 入力:
%  Settle    - 決済日
%  Maturity  - 満期日
%
% 入力(オプション)：
%  Period          - 1年でのクーポン支払回数; デフォルトは2(半年払い)
%  Basis           - 日数のカウント基準; デフォルトは 0 (actual/actual)
%  EndMonthRule    - 月末規則; デフォルトは1(月末規則は有効)
%  IssueDate       - 証券の発行日
%  FirstCouponDate - 不定期または通常の第1回クーポン支払日
%  LastCouponDate  - 不定期または通常の最終クーポン支払日 
%
% 出力: 
% PreviousCouponDate - 決済日及びそれ以前に到来した実際の前回クーポン日
%   からなる NUMBONDS行1列のベクトルです。決済日がクーポン日と同一の
%   場合、この関数は決済日を出力します。すなわち厳密に決済日またはそれ
%   以前の実際のクーポン日をこの関数は出力しますが、前回クーポン日が
%   発行日以前となる場合は(それが、たとえ利用可能であったとしても)
%   除外します。そのため、この関数は実際の発行日または決済日を基準に
%   した前回クーポン日のいずれか近いほうの日付を出力します。
%
% 注意：[必須]と指定されている全ての引数は、NUMBONDS行1列、または、1行
%   NUMBONDS列のベクトルまたはスカラ引数でなければなりません。オプション
%   となる全ての引数は、NUMBONDS行1列、または、1行NUMBONDS列のベクトル、
%   スカラまたは空行列でなければなりません。値の指定のない入力には NaN を
%   入力ベクトルとして設定してください。日付は、シリアル日付番号または
%   日付文字列です。
%
%   それぞれの入力引数及び出力引数の詳細については、コマンドライン上で
%   'help ftb' + 引数名(たとえば、Settle(決済日)に関するヘルプは、
%   "help ftbSettle")とタイプして得られます。 
%
% 参考 : CPNDATEPQ, CPNDATEN, CPNDATENQ, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%        CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.


%Copyright 1995-2002 The MathWorks, Inc.
