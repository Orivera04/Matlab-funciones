% INTENVSENS   債券の感応度及び価格を1組のゼロ曲線から決定
%
% ゼロクーポン債の利率期間構造を使用して、債券のドル感応度、価格を計算
% します。
%
%   [Delta, Gamma, Price] = intenvsens(RateSpec, InstSet)
%
% 入力:
%   RateSpec - 価格決定に用いる年率換算されたゼロ利率期間構造。RateSpec
%              の 'Rates' フィールドは年率換算ゼロ利率のNPOINTS行
%              NUMCURVES列の配列です。期間構造の生成に関する詳細につい
%              ては、"help intenvset"をタイプしてください。
%
%   InstSet  - NINSTの数存在する債券の集合からなる変数です。債券は、
%              タイプごとに分類され、それぞれのタイプに異なるデータ
%              フィールドが割り当てられます。
% 出力:
%   Delta   - 観測されたフォワード利回り曲線のシフトによってどれだけ債券
%             の価格が変化するか、その割合を示すデルタからなるNINST行
%             NUMCURVES列の行列です。デルタは差分によって計算されます。
%
%   Gamma   - 観測されたフォワード利回り曲線のシフトによって、どれだけ
%             債券のデルタが変化するか、その割合を示すガンマからなる
%             NINST行NUMCURVES列の行列です。ガンマは差分によって計算
%             されます。
%
%   Price   - 各債券の価格からなるNINST行NUMCURVES列の行列です。価格決定
%             が行えなかった場合は、NaN値を出力します。
%
% 注意：
%   INTENVSENS は次のタイプの債券を扱うことができます。
%   'Bond', 'CashFlow','Fixed', 'Float', 'Swap'.  
%   ここで定義されたタイプの債券を生成するには、"help instadd"を参照
%   してください。
%
% 例題:
%   load deriv
%   instdisp(ExInstSet)
%   [Delta, Gamma]= intenvsens(ExRateSpec,ExInstSet)
%
% 参考 : INTENVPRICE, INTENVSET, INSTADD, HJMPRICE, HJMSENS.


%   Author(s): P. N. Secakusuma, M. Reyes-Kattar, 3-Jan-2000
%   Copyright 1998-2002 The MathWorks, Inc. 
