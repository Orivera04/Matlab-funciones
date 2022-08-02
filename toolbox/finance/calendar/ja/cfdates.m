% CFDATES   確定利付債のキャッシュフロー日付
%
% この関数は、NUMBONDS だけ存在する確定利付債権について、キャッシュフロー
% 日付行列を出力します。この関数は、第1期間及び最終期間が通常か長いか
% 短いかに関わらず当該債権の全てのキャッシュフロー日付を出力します。
%
%   CFlowDates = cfdates(Settle, Maturity)
%
%   CFlowDates = cfdates(Settle, Maturity, Period, Basis, 
%                        EndMonthRule, IssueDate, FirstCouponDate, 
%                        LastCouponDate)
% 入力: 
%   Settle   - 決済日
%   Maturity - 満期日
%
% 入力(オプション):
%   Period          - 1年でのクーポン支払回数; デフォルトは2(半年払い)
%   Basis           - 日数のカウント基準; デフォルトは 0 (actual/actual)
%   EndMonthRule    - 月末規則; デフォルトは1(月末規則は有効)
%   IssueDate       - 債権の発行日
%   FirstCouponDate - 実際の第1回クーポン支払日
%   LastCouponDate  - 実際の最終クーポン支払日 
%
% 出力: 
%   CFlowDates      - シリアル日付形式で表示された実際のキャッシュフロー
%     支払い日からなる行列です。 CFlowDates行列の行の数は、NUMBONDS で、
%     列の数は、債券ポートフォリオを保有することにより要求されるキャッ
%     シュフロー支払い日数の最大値によって決定されます。キャッシュフロー
%     支払日の数が、CFlowDates行列の行数によって示される最大値より少ない
%     債券については、NaN値によって桁揃えが行われます。
%
% 注意：[必須]と指定されている全ての引数は、NUMBONDS行1列、または、
%   1行NUMBONDS列のベクトルまたはスカラ引数でなければなりません。オプ
%   ションとなる全ての引数は、NUMBONDS行1列、または、1行NUMBONDS列の
%   ベクトル、スカラまたは空行列でなければなりません。値の指定のない
%   入力には NaN を入力ベクトルとして設定してください。日付は、シリアル
%   日付番号または日付文字列です。
%
%   それぞれの入力引数及び出力引数の詳細については、コマンドライン上で
%   'help ftb' + 引数名(たとえば、Settle(決済日)に関するヘルプは、
%   "help ftbSettle"とタイプして得られます。 
%
% 参考 : CFAMOUNTS, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN,
%        CPNDAYSP, CPNPERSZ, CPNCOUNT, ACCRFRAC, CFTIMES


% Copyright 1995-2002 The MathWorks, Inc. 
