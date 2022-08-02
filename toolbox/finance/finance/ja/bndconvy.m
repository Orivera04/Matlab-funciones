% BNDCONVY   与えられた利回りからの債券のコンベクシティ
%
% この関数は、NUMBONDS 確定利付債権のコンベクシティを、それぞれの債券の
% 満期までの利回りから計算します。この関数は、債券のクーポン構造が最初、
% または、最後の期間が短期、または、長期である場合でも、債券のコンベクシ
% ティを計算することができます(すなわち、クーポン構造が満期と同期してい
% るかどうかにかかわらず債券のコンベクシティを計算できます)。この関数は、
% ゼロクーポン債のコンベクシティの計算も可能にします。
%
%   [YearConvexity, PerConvexity] = bndconvy(Yield, CouponRate,...
%          Settle, Maturity)
%
%   [YearConvexity, PerConvexity] = bndconvy(Yield, CouponRate,...
%          Settle, Maturity, Period, Basis, EndMonthRule, IssueDate,...
%          FirstCouponDate, LastCouponDate, StartDate, Face)
%
% 入力: [必須]と指定されている全ての引数は、NUMBONDS行1列、または、1行
% NUMBONDS列のベクトル、または、スカラ引数です。オプションの引数は全て
% NUMBONDS行1列、または、1行NUMBONDS列のベクトル、スカラ、または、空行列
% となります。入力(オプション)は、空行列によって省略することもできます。
% さらに入力(オプション)の中で、引数リストの末尾に位置する入力は割愛する
% こともできます。入力(オプション)の値をデフォルト値に設定するには、
% NaN値を入力値として設定してください。日付引数は、シリアル日付番号、
% または、日付文字列です。SIA確定利付債権の引数に関する詳細については、 
% 'help ftb'とタイプしてください。
% ある特定の引数に関する詳細、たとえば、Settleは、"help ftbSettle"と
% タイプすれば参照できます。
% 
%  Yield (必須)      -  半年複利計算の満期利回り
%  CouponRate (必須) -  10進法で表記されたクーポン利率
%  Settle (必須)     -  決済日
%  Maturity (必須)   -  満期日
%
% 入力(オプション)：
%  Period          -  1年でのクーポン支払回数; デフォルトは2(半年払い)
%  Basis           -  日数のカウント基準; デフォルトは 0 (actual/actual)
%  EndMonthRule    -  月末規則; デフォルトは1(月末規則は有効)
%  IssueDate       -  証券の発行日
%  FirstCouponDate -  不定期、または、通常の第1回クーポン支払日
%  LastCouponDate  -  不定期、または、通常の最終クーポン支払日 
%  StartDate       -  支払いを前もってスタートさせる日付(バージョン2.0で
%                     は無視されます)
%  Face            -  証券の額面価値：デフォルトは100
%
% 出力:  
%  YearConvexity   -  年間コンベクシティ
%  PerConvexity    -  期間コンベクシティ
%         
% 出力は、NUMBONDS行1列のベクトルです。
%
% 参考 : BNDCONVP, BNDDURP, BNDDURY.


%   Author(s): C. Bassignani, 07-29-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
