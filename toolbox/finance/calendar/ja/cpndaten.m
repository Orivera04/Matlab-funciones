% CPNDATEN   確定利付債に対する次回の実際のクーポン支払日
%
% この関数は、NUMBONDS個の確定利付債権のセットについて、次回の実際の
% クーポンを出力します。この関数は、当該債権の第1回または最終クーポン
% 期間が正常の長さであるか、またはそれよりも長い期間または短い期間で
% あるかに関わらず、当該債権について次回の実際のクーポン日を出力します。
% ゼロクーポン債の場合、この関数は満期日を出力します。
%
%   NextCouponDate = cpndaten(Settle, Maturity)
%
%   NextCouponDate = cpndaten(Settle, Maturity, Period, Basis, ....
%               EndMonthRule, IssueDate, FirstCouponDate,...
%               LastCouponDate)
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
%   NextCouponDate - 決済日以降の実際の次回クーポン日の日付からなる
%                    NUMBONDS行1列のベクトルです。決済日がクーポン日と
%                    同一の場合、この関数は決済日を出力しません。
%                    その代わりに、厳密に決済日以降の実際のクーポン日を
%                    出力します(ただし、満期日以降の場合を除く)。
%                    そのため、この関数は常に実際の満期日と次回クーポン
%                    支払日のうち、より近いほうの日付を常に出力します。
%
% 注意：[必須]と指定されている全ての引数は、 NUMBONDS行1列、または、1行
%   NUMBONDS列のベクトルまたはスカラ引数でなければなりません。オプション
%   となる全ての引数は、NUMBONDS 行1列、または、1行 NUMBONDS 列のベク
%   トル、スカラまたは空行列でなければなりません。値の指定のない入力には 
%   NaN を入力ベクトルとして設定してください。日付は、シリアル日付番号
%   または日付文字列です。
%
%   それぞれの入力引数及び出力引数の詳細については、コマンドライン上で
%   'help ftb' + 引数名(たとえば、Settle(決済日)に関するヘルプは、
%   "help ftbSettle"）とタイプして参照できます。 
%
% 参考 : CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, CPNDAYSP, CPNPERSZ, 
%        CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.


% Copyright 1995-2002 The MathWorks, Inc. 
