% CPNDAYSP   前回クーポン日からの日数
%
% この関数は、NUMBONDS だけ存在する確定利付債のセットについて、前回準
% クーポン日から決済日までの日数を出力します。この関数は、最初と最後の
% クーポン期間が正常でなくとも、日数を出力することができます。ゼロクーポン
% 債については、この関数は理論上の前回準クーポン日(すなわち、債券が
% クーポン債であると仮定した場合の前回クーポン日)から決済日までの日数を
% 出力します。
%
%   NumDaysPrevious = cpndaysp(Settle, Maturity)
%
%   NumDaysPrevious = cpndaysp(Settle, Maturity, Period, Basis, ....
%       EndMonthRule, EndMonthRule, IssueDate, FirstCouponDate, ....
%       LastCouponDate, StartDate)
%
% 入力: [必須]と指定されている全ての引数は、NUMBONDS行1列、または、1行
% NUMBONDS列のベクトル、または、スカラ引数です。オプションの引数は、
% 全てNUMBONDS行1列、または、1行NUMBONDS列のベクトル、スカラまたは空行列
% となります。入力(オプション)は、空行列によって省略することもできます。
% さらに入力(オプション)の中で、引数リストの末尾に位置する入力は割愛する
% こともできます。入力(オプション)の値をデフォルト値に設定するには、
% NaN値を入力値として設定してください。日付引数は、シリアル日付番号または
% 日付文字列です。SIA確定利付債の引数に関する詳細については、 'help ftb' 
% とタイプしてください。
% 
% ある特定の引数に関する詳細については、コマンドライン上で
% 'help ftb' + 引数名(たとえば、Settle(決済日)に関するヘルプは、
% "help ftbSettle")とタイプすれば参照できます。 
% 
%  Settle (必須)  - 決済日
%  Maturity (必須)- 満期日
%
% 入力(オプション)：
%  Period          - 1年でのクーポン支払回数; デフォルトは2(半年払い)
%  Basis           - 日数のカウント基準; デフォルトは 0 (actual/actual)
%  EndMonthRule    - 月末規則; デフォルトは1(月末規則は有効)
%  IssueDate       - 債権の発行日
%  FirstCouponDate - 不定期または通常の第1回クーポン支払日
%  LastCouponDate  - 不定期または通常の最終クーポン支払日 
%  StartDate       - 支払いを前もってスタートさせる日付(バージョン2.0で
%                    は無視されます)
%
% 出力: 
%  NumDaysPrevious - 前回準クーポン日から決済日までの日数を示すNUMBONDS
%                    行1列ベクトルです。
%         
% 注意： 
% 決済日がクーポン日と一致する場合、この関数は常に決済日を出力します。
%
% 参考 : CPNDATEP, CPNDATEPQ, CPNDATEN, CPNDATENQ, CPNDAYSN, CPNPERSZ, 
%        CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.


%   Author(s): C. Bassignani, M. Reyes-Kattar 10-17-97, 07-31-98
%   Copyright 1995-2002 The MathWorks, Inc. 
