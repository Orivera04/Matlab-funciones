% INSTADD   商品の集合変数に、MathWorks によって供給された商品タイプを
%           追加
%
%INSTADD には、つぎのタイプの商品が記憶されています。'Bond', 'CashFlow', 
% 'OptBond', 'Fixed', 'Float', 'Cap', 'Floor'、または、'Swap' です。
% なお、価格決定ルーチン及び感応度ルーチンの双方が、これらの商品に対して
% 提供されています。
%
% 使用法：
%   それぞれの証券作成関数について、使用法と共に整理していきます。
% 
%   instbond   - 債券商品
%   InstSet = instadd('Bond', CouponRate, Settle, Maturity, ...
%                     Period, Basis, EndMonthRule, ...
%                     IssueDate, FirstCouponDate, LastCouponDate, ...
%                     StartDate, Face)
%
%   instcf     - 任意のキャッシュフローを有する商品
%   InstSet = instadd('CashFlow', CFlowAmounts, CFlowDates, TFactors)
%   
%   instoptbnd -オプション組み込み債券
%   InstSet = instoptbnd('OptBond', BondIndex, OptSpec, ... 
%                         Strike, ExerciseDates, AmericanOpt)
%
%   instfixed  - 確定利付債商品
%   InstSet = instadd('Fixed', CouponRate, Settle, Maturity, ...
%                      Reset, Basis, Principal)
%
%   instfloat  - 変動利付債商品
%   InstSet = instadd('Float', Spread, Settle, Maturity, ...
%                      Reset, Basis, Principal)
%
%   instcap    - キャップ付き商品
%   InstSet = instadd('Cap', Strike, Settle, Maturity, Reset, Basis, ...
%                      Principal)
%
%   instfloor  - フロア付き商品.
%   InstSet = instadd('Floor', Strike, Settle, Maturity, Reset, ...
%              Basis, Principal)
%
%   instswap   - スワップ商品
%   InstSet = instadd('Swap', LegRate, Settle, Maturity, LegReset, ....
%              Basis, Principal, LegType)
%
%   既存の集合に商品を追加するには、つぎの関数を実行してください。
%   InstSet = instadd(InstSetOld, TypeString, Data1, Data2, ...)
%   InstSet = instadd('CashFlow', CFlowAmounts, CFlowDates, TFactors)
%
% 入力: 
% たとえば、"help instcap" とタイプすれば、商品のデータパラメータに
% 関する詳細な情報を得ることができます。
%
%   InstSetOld - 商品の集合からなる変数。商品は、タイプ毎に分類されてお
%                り、それぞれのタイプについて異なるデータフィールドを設
%                定できます。記憶されたデータフィールドは、商品のそれぞ
%                れに対応する行ベクトル、または、文字列となっています。
%
% 出力:   
%   InstSet    - 新しい入力データを含む商品集合変数。
%
% 例題: 
%   2つのキャップ付き債券と6％債券を出力します。
%   CapStrike = [0.06; 0.07];
%   BondCoupon = 0.04;
%   Settle = '06-Feb-1999';
%   Maturity = '15-Jan-2001';
%
%   ISet = instadd('Cap', CapStrike, Settle, Maturity);
%   ISet = instadd(ISet, 'Bond', BondCoupon, Settle, Maturity);
%   instdisp(ISet)
%   
% 参考 : INSTBOND, INSTCF, INSTOPTBND, INSTFIXED, INSTFLOAT, INSTCAP, 
%        INSTFLOOR, INSTSWAP.


%   Author(s): J. Akao, M. Reyes-Kattar 10/27/99
%   Copyright 1995-2002 The MathWorks, Inc. 
