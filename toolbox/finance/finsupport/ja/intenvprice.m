% INTENVPRICE   1組のゼロ曲線に対する確定利付証券の価格決定
%
% 1組のゼロクーポン債が与えられると、それをもとに確定利付債商品の価格
% 決定を行います 
%
%   Price = intenvprice(RateSpec, InstSet)
%
% 入力:
%   RateSpec - 価格決定に用いる年率換算されたゼロ利率期間構造。RateSpec
%              の 'Rates' フィールドは年率換算ゼロ利率のNPOINTS行
%              NUMCURVES列の配列です。期間構造の生成に関する詳細につい
%              ては、"help intenvset"をタイプしてください。
%
%   InstSet  - NINSTの数存在する確定利付債商品の集合からなる変数です。
%              確定利付債商品は、タイプごとに分類され、それぞれのタイプに
%              異なるデータフィールドが割り当てられます。
%
% 出力:
%   Price   - 各確定利付債商品の価格からなるNINST行NUMCURVES列の行列です。
%             価格決定が行えなかった場合は、NaN値を出力します。
%
% 注意:
% INTENVPRICE は、つぎのタイプの確定利付債を処理することができます。
% 'Bond', 'CashFlow',   'Fixed', 'Float', 'Swap'.  
% これらのタイプの債券を生成するには、"help instadd"をタイプしてください。
%
% 価格決定に関する情報を検索するために、単一タイプの価格関数を参照するに
% は、たとえば "help swapbyzero"のようにタイプしてください。
%
%   bondbyzero   - 1組のゼロ曲線によって債券の価格を決定します。
%   cfbyzero     - 1組のゼロ曲線によって任意のキャッシュフローの価格を
%                  決定します。
%   fixedbyzero  - 1組のゼロ曲線によって確定利付債の価格を決定します。
%   floatbyzero  - 1組のゼロ曲線によって変動利付債の価格を決定します。
%   swapbyzero   - 1組のゼロ曲線によってスワップ債の価格を決定します。
%
%
% 例題:	
%   load deriv
%   instdisp(ExInstSet)
%   Price = intenvprice(ExRateSpec,ExInstSet)
%
% 参考 : INTENVSENS, INTENVSET, INSTADD, HJMPRICE, HJMSENS.


%   Author(s): P. N. Secakusuma, M. Reyes-Kattar, 3-Jan-2000
%   Copyright 1998-2002 The MathWorks, Inc. 
