% CFAMOUNTS   ポートフォリオの各債権に対するキャッシュフロー及び時間写像
%
% この関数は、以下のものを出力します。
% - キャッシュフロー
% - キャッシュフローの日付
% - 不連続な半年払いのクーポンに対する適切な時間
%   
%   [CFlowAmounts, CFlowDates, TFactors, CFlowFlags] = ...
%       cfamounts(CouponRate, Settle, Maturity)
%
%   [CFlowAmounts, CFlowDates, TFactors, CFlowFlags] = ...
%       cfamounts(CouponRate, Settle, Maturity, Period, ... 
%           Basis, EndMonthRule, IssueDate, ...
%       FirstCouponDate, LastCouponDate, StartDate, Face)
%
% 入力: [スカラ、または NBONDS x 1 の大きさのベクトル]
%
%   CouponRate (必須) - 10進法で表記されたクーポン利率。ゼロクーポン債の
%                       場合は0
%   Settle     (必須) - 決済日
%
%   Maturity   (必須) - 満期日
%
% 入力(オプション):
%   Period - クーポン支払回数; デフォルトは "2" (半年払い)
%
%   Basis - ポートフォリオの各債権に対する日数のカウント基準; 可能な値は、
%           0 - 実際の日数/実際の日数 (デフォルト)
%           1 - 30/360 (SIA準拠)
%           2 - 実際の日数/360
%           3 - 実際の日数/365
%           4 - 30/360  (PSA準拠)
%           5 - 30/360  (ISDA準拠)
%           6 - 30/360  (ヨーロッパ型)
%           7 - act/365 (日本型)
%
%   EndMonthRule    - 月末規則; デフォルトは "1" (月末規則は有効)
%   IssueDate       - 債権の発行日で利子の発生日
%   FirstCouponDate - 第1回クーポン支払日
%   LastCouponDate  - 最終クーポン支払日 
%   StartDate       - 債券がスタートした日(将来利用するための引数)
%   Face            - 額面価値、デフォルトは100
% 
% 出力: 出力はNBONDS行NCFS列の行列です。それぞれの行は、当該債券に対する
%   キャッシュフローを示しています。桁が短い行は、NaN値による桁揃えが
%   行われます。
% 
%  CFlowAmounts - キャッシュフローの総額; それぞれの行ベクトルの最初の
%                 要素は決済日に支払われるべき(負の)経過利子です(経過利子
%                 が支払われない場合は、最初の列はゼロとなります)。
%  CFlowDates   - キャッシュフロー日付を示すシリアル日付番号です。少なく
%                 とも2つの列(決済日、満期日)は常に存在しています。
%  TFactors     - 端数のSIA半年価格／利回り換算に用いる時間係数
%                    割引係数= (1 + Yield/2).^(-TFactor)  
%                 時間係数は半年クーポン期間が単位となって算定されます。
%  CFlowFlags   - 利払いのタイプを示すキャッシュフローフラグ です( "help
%                 ftbcflowflags" とタイプすると、これらのフラグに関する
%                 詳細な説明を見ることができます)。


%   Author(s): Bassignani, 22-Jan-98, Akao 29-Jan-99, Winata 30-Aug-2002
%   Copyright (c) 1995-1999 The MathWorks, Inc. All Rights Reserved.
