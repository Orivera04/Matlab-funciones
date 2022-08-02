% CPNCOUNT   満期日までのクーポンの支払いの回数
%
% この関数は、NBONDS個の確定利付債について、満期日までに残されたクーポン
% 支払いの回数を出力します。
% 
%  NumCouponsRemaining = cpncount(Settle, Maturity)
%
%  NumCouponsRemaining = cpncount(Settle, Maturity, Period, Basis, ...
%         EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate, ...
%         StartDate)
%
% 入力: [必須]と指定されている全ての引数は、NBONDS行1列、または、1行
%   NBONDS列のベクトルまたはスカラ引数です。オプションの引数は、空行列
%   によって省略することもできます。さらに入力(オプション)の中で、引数
%   リストの末尾に位置する入力は割愛することもできます。入力(オプション)
%   の値をデフォルト値に設定するには、NaN値を入力値として設定してくだ
%   さい。日付引数は、シリアル日付番号または日付文字列です。SIA確定
%   利付債の引数に関する詳細については、'help ftb' とタイプしてください。
%   ある特定の引数に関する詳細、たとえばSettleに関するヘルプは、
%   "help ftbSettle" とタイプすれば参照できます。 
% 
%  Settle (必須)  - 決済日
%  Maturity (必須)- 満期日
%
% 入力(オプション)：
%  Period          - 1年でのクーポン支払回数; デフォルトは2(半年払い)
%  Basis           - 日数のカウント基準; デフォルトは 0 (actual/actual)
%  EndMonthRule    - 月末規則; デフォルトは1(月末規則は有効)
%  IssueDate       - 債権の発行日
%  FirstCouponDate - 実際の第1回クーポン支払日
%  LastCouponDate  - 実際の最終クーポン支払日 
%  StartDate       - 債券がスタートした日(将来利用するための引数)
%
% 出力: 
% NumCouponsRemaining - 決済日より後に支払われるクーポンの回数を示す 
%                       NBONDS行１列のベクトルです。決済日に支払われる
%                       クーポン及び決済日より前に支払われたクーポンに
%                       ついてはカウントされません。但し、満期日に支払わ
%                       れるクーポンについては常にカウントされます。
%
% 参考 : CPNCDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, 
%        CPNDAYSP, CPNPERSZ, CFDATES, CFAMOUTNS, ACCRFRAC, CFTIMES.


%Author(s): C. Bassignani, 10-17-97, 07-31-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
