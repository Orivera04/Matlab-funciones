% ACCRFRAC   決済前のクーポン期間の端数
%
% この関数は、NBONDS だけ存在する確定利付債に対して、決済日までに経過
% するクーポン期間の端数を計算します。ここで計算された端数を指定された
% 確定利付債の定期キャッシュフローの名目額と掛け合わせることによって、
% 当該債権に支払われる経過利子を算出することができます。この関数は、通常の
% クーポン期間をもつ債権や第1回目または最終クーポン期間の長さが端数の債権
% の経過利子に対して有効です。
% 
% Fraction = accrfrac(Settle, Maturity) 
%
% Fraction = accrfrac(Settle, Maturity, Period, Basis, EndMonthRule, ...
%        IssueDate, FirstCouponDate, LastCouponDate, StartDate)
%
% 入力: [必須]とされている入力引数は、NBONDS行1列のベクトルまたはスカラ
%   引数です。入力(オプション)は、空行列によって省略することもできます。
%   また、引数リストの末尾の入力(オプション)は割愛することもできます。
%   入力(オプション)のいずれかにNaN値を設定すると、その入力はデフォルト
%   値に設定されます。
%   日付引数は、シリアル日付番号または日付文字列です。SIA確定利付債の
%   引数の詳細を見るには、 'help ftb'とタイプしてください。ある特定の
%   引数に関する詳細、たとえば、Settleに関するヘルプは、"help ftbSettle"
%   とタイプすれば参照できます。
% 
%    Settle (必須)   - 決済日
%    Maturity (必須) - 満期日
%
% 入力(オプション)：
%    Period          - 1年でのクーポン支払回数; デフォルトは2(半年払い)
%    Basis           - 日数のカウント基準; デフォルトは 0 (actual/actual)
%    EndMonthRule    - 月末規則; デフォルトは1(月末規則は有効)
%    IssueDate       - 債権の発行日で利子の発生日
%    FirstCouponDate - 第1回クーポン支払日
%    LastCouponDate  - 最終クーポン支払日 
%    StartDate       - 債券がスタートした日(将来利用するための引数)
%
% 出力: 
%    Fraction        - 経過利子の端数を示すNUMBONDS行１列ベクトル
%
% 参考 : CFAMOUNTS, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, 
%        CPNDAYSP, CPNPERSZ, CPNCOUNT, CFDATES.


%Author(s): C. Bassignani, 04-04-98, 07-31-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
