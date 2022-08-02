% SWAPBYZERO   1組のゼロ曲線から通常のスワップ債の価格を決定
%
%   [Price, SwapRate] = swapbyzero(RateSpec, LegRate, Settle, Maturity)
%
%   [Price, SwapRate] = swapbyzero(RateSpec, LegRate,  Settle,....
%         Maturity, LegReset, Basis,  Principal, LegType)
%
% 入力(必須): 日付はシリアルデート番号、または、日付文字列でなければなり
% ません。オプションの引数は空行列 []によって省略できます。
%
%   RateSpec   - 年率換算されたゼロ利率期間構造
%   LegRate    - NINST行2列の行列です。この行列の各行は次のように定義
%                されています。
%                [CouponRate Spread]、または、[Spread CouponRate]
%                ここでCouponRate は10進数表記の年率。Spreadは基準金利を
%                超えるベーシスポイントの数です。最初の列は受け取った
%                区間(receiving leg)、二番目の列は支払いを行う区間
%                (paying leg)を示しています。              
%   Settle     - フロアの決済日を示す日付文字列、または、シリアル日付
%                番号
%   Maturity   - スワップ債の満期日を示すNINST行1列のベクトルです。
%
% 入力(オプション)：
%   LegReset   - それぞれのスワップ債について年に何回決済が行われるかを
%                示すNINST行2列の行列です。デフォルトは [1 1] です。
%   Basis      - 入力されたフォワード利率ツリーの分析に適用される日数の
%                カウント基準を示すNINST行1列のベクトルです。デフォルト
%                は0 (actual/actual)
%   Principal  - 想定元本(名目元本)を示すNINST行1列のベクトルです。
%                デフォルトは100
%   LegType    - NINST行2列の行列です。この行列の各行は、スワップ債商品
%                に対応しており、各列は、対応する区間が固定利率、または
%                変動利率のいずれであるのかを示しています。この列の値が0
%                であれば、変動利率、値が１であれば固定利率です。行列
%                LegRate に入力された値をどのように解析するかを定義する
%                ためにこの行列は使用されます。デフォルトでは、各商品に
%                ついて [1,0] に設定されています。
%
% 出力:
%   Price     - スワップ債の価格からなるNINST行NUMCURVES列の行列です。
%               行列の各列はそれぞれ１つのゼロ曲線に対応しています。
%
%   SwapRate  - スワップ債の価格が決済時点でゼロとなるような、固定利率
%               区間に適用できる利率からなるNINST行 NUMCURVES列の行列
%               です。引数 LegRate で固定利率区間に指定された利率がNaN値
%               の場合にこの利率が計算され、スワップ債の価格決定に使用
%               されます。
% 
%               クーポン利率がNaNに設定されていない債券については、
%               SwapRate に対してNaN値を用いた桁揃えが行われます。
%
% 参考 : BONDBYZERO, CFBYZERO, FIXEDBYZERO, FLOATBYZERO.


%   Author(s): M. Reyes-Kattar, 02/07/2000
%   Copyright 1995-2002 The MathWorks, Inc. 
