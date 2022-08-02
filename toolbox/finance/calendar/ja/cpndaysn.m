% CPNDAYSN   次回クーポン日までの日数
%
% この関数は、NUMBONDS だけ存在する確定利付債のセットについて、決済日
% から次回準クーポン日までの日数を出力します。この関数は、最初と最後の
% クーポン期間が正常でなくとも、日数を出力することができます。ゼロクーポン
% 債については、この関数は決済日から理論上の次回準クーポン日(すなわち、
% 債券がクーポン債であると仮定した場合の次回クーポン日)までの日数を出力
% します。
%
%     NumDaysNext = cpndaysn(Settle, Maturity)
%
%     NumDaysNext = cpndaysn(Settle, Maturity, Period, Basis, .....
%                   EndMonthRule, IssueDate, FirstCouponDate, .....
%                   LastCouponDate, StartDate)
%
% 入力: [必須]と指定されている全ての引数は、NUMBONDS行1列、または、1行
% NUMBONDS列のベクトルまたはスカラ引数です。オプションの引数は、全て
% NUMBONDS行1列、または、1行NUMBONDS列のベクトル、スカラまたは空行列と
% なります。入力(オプション)は、空行列によって省略することもできます。
% さらに入力(オプション)の中で、引数リストの末尾に位置する入力は割愛する
% こともできます。入力(オプション)の値をデフォルト値に設定するには、
% NaN値を入力値として設定してください。日付引数は、シリアル日付番号または
% 日付文字列です。SIA確定利付債の引数に関する詳細については、'help ftb' 
% とタイプしてください。
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
%  NumDaysNext - 次回クーポン日までの日数を示すNUMBONDS行1列ベクトルです。
%         
% 参考 : CPNDAYSP, CPNDATEP, CPNDATEPQ, CPNDATEN, CPNDATENQ, CPNPERSZ, 
%        CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CFTIMES.
%   
% Author(s): C. Bassignani, M. Reyes-Kattar 10-17-97, 07-31-98 


%   Author(s): C. Bassignani, M. Reyes-Kattar 10-17-97, 07-31-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
