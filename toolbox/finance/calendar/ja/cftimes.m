% CFTIMES   端数クーポン期間におけるキャッシュフローまでの時間
%
% この関数は、NUMBONDS だけ存在する確定利付債について時間係数(timefactor)
% を出力します。「時間係数(time factor)」とは、端数半年クーポン期間に
% おけるキャッシュフローまでの時間を意味しています。
%
%   TFactors = cftimes(Settle, Maturity)
%
%   TFactors = cftimes(Settle, Maturity, Period, Basis, EndMonthRule,...
%          IssueDate, FirstCouponDate, LastCouponDate, StartDate)
%
% 入力: [必須]と指定されている全ての引数は、 NUMBONDS 行1列、または、
%   1行NUMBONDS列のベクトルまたはスカラ引数です。オプションの引数は全て
%   NUMBONDS行1列、または、1行NUMBONDS列のベクトル、スカラまたは空行列
%   となります。入力(オプション)は、空行列によって省略することもでき
%   ます。さらに入力(オプション)の中で、引数リストの末尾に位置する入力は
%   割愛することもできます。入力(オプション)の値をデフォルト値に設定する
%   には、NaN値を入力値として設定してください。日付引数は、シリアル日付
%   番号または日付文字列です。SIA確定利付債の引数に関する詳細については、
%   'help ftb' とタイプしてください。ある特定の引数に関する詳細、
%   たとえば、Settle に関するヘルプは、コマンドライン上で "help ftbSettle"
%   とタイプすれば参照できます。
% 
%   Settle (必須)   - 決済日
%   Maturity (必須) - 満期日
%
%入力(オプション)：
%   Period          - 1年でのクーポン支払回数; デフォルトは2(半年払い)
%   Basis           - 日数のカウント基準; デフォルトは 0 (actual/actual)
%   EndMonthRule    - 月末規則; デフォルトは1(月末規則は有効)
%   IssueDate       - 債権の発行日
%   FirstCouponDate - 不定期または通常の第1回クーポン支払日
%   LastCouponDate  - 不定期または通常の最終クーポン支払日 
%   StartDate       - 支払いを前もってスタートさせる日付(バージョン2.0で
%                     は無視されます)
%         
% 出力: 
%  TFactors - キャッシュフローまでの時間　TFactors行列の行の数は、
%    NUMBONDS で、列の数は、債券ポートフォリオを保有することにより要求
%    されるキャッシュフロー支払い日数の最大値によって決定されます。
%    キャッシュフロー支払日の数が、TFactor行列の行数によって示される
%    最大値より少ない債券については、NaN値によって桁揃えが行われます。
%
% 参考 : CPNDAYSN, CPNDAYSP, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, 
%        CPNCOUNT, CFDATES, CFAMOUNTS, ACCRFRAC, CPNPERSZ.


%   Author(s): C. Bassignani, M. Reyes-Kattar 07-31-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
