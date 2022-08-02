% CPNPERSZ   クーポン期間の日数
% 
% この関数は、NUMBONDS だけ存在する確定利付債権に対して、決済日を含む
% クーポン期間の日数を出力します。
%
%   NumDaysPeriod = cpnpersz(Settle, Maturity)
%
%   NumDaysPeriod = cpnpersz(Settle, Maturity, Period, Basis, ...
%          EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate, ...
%          StartDate)
%
% 入力: [必須]と指定されている全ての引数は、NUMBONDS行1列、または、1行
%   NUMBONDS列のベクトル、または、スカラ引数です。オプションの引数は
%   全てNUMBONDS行1列、または、1行NUMBONDS列のベクトル、スカラ、または、
%   空行列となります。入力(オプション)は、空行列によって省略することも
%   できます。さらに入力(オプション)の中で、引数リストの末尾に位置する
%   入力は割愛することもできます。入力(オプション)の値をデフォルト値に
%   設定するには、NaN値を入力値として設定してください。日付引数は、シリ
%   アル日付番号または日付文字列です。SIA確定利付債権の引数に関する詳細
%   については、'help ftb' とタイプしてください。
% 
% ある特定の引数に関する詳細については、コマンドライン上で、
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
% NumDaysPeriod - 
%      決済日を含むクーポン期間の日数を示すNUMBONDS行1列のベクトルです。
% 
% 参考: CPNDAYSN, CPNDAYSP, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, 
%       CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC.


%   Author(s): C. Bassignani, 10-17-97, 07-31-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
