% PYLD2ZERO   与えられた額面利回り曲線からゼロ曲線を出力
%
% [ZeroRates, CurveDates] = ....
%       pyld2zero(ParRates, CurveDates, Settle, OutputCompounding, ....
%       OutputBasis,InputCompounding,InputBasis)
%
% 詳細： 
% 額面利回り曲線と満期日を入力として与えると、この関数は入力された満期日
% によって、示される所有期間に対してゼロ曲線を出力します。
%
% 入力:
%         ParRates          - (必須)年率換算された額面利回り(= クーポン
%                             レート)を10進数表記で示す N 行1列のベクト
%                             ル。ここで、N は満期額面売買債券の数です。
%         CurveDates        - (必須)入力された額面利回りに対応する満期日
%                             をシリアル日付で示す N 行1列のベクトル
%         Settle            - (必須)債券の決済日をシリアル日付形式で表示
%                             するスカラ値
%         OutputCompounding - (オプション)出力されるゼロ利率を年率に換算
%                             するときにどのくらいの割合で複利計算を行う
%                             かを示すスカラ値。入力できる値は、つぎの通
%                             りです。
%              OutputCompounding = 1   - 一年複利計算
%              OutputCompounding = 2   - (デフォルト)半年複利計算
%              OutputCompounding = 3   - 年3回複利計算
%              OutputCompounding = 4   - 年4回複利計算
%              OutputCompounding = 6   - 隔月複利計算
%              OutputCompounding = 12  - 月1回複利計算
%              OutputCompounding = 365 - 毎日複利計算
%              OutputCompounding = -1  - 連続複利計算
%
%         OutputBasis       - (オプション)出力されるゼロ利率を年率に換算
%                             するときに、どの日数カウント基準を用いるか
%                             を示すスカラ値。入力できる値はつぎの通りで
%                             す。
%              1)Basis = 0 - actual/actual(デフォルト)
%              2)Basis = 1 - 30/360
%              3)Basis = 2 - actual/360
%              4)Basis = 3 - actual/365
%
%         InputCompounding  - (オプション)入力した額面利回りを年率に換算
%                             するときにどのくらいの割合で複利計算を行う
%                             かを示すスカラ値。デフォルトでは、
%                             OutputCompounding と同じ値となっています。
%         InputBasis        - (オプション)入力した額面利回りを年率に換算
%                             するときに、どの日数カウント基準を用いるか
%                             を示すスカラ値。デフォルトでは、
%                             OutputBasis と同じ値になっています。
% 出力:    
%         ZeroRates         - 10進法表記のゼロ利率を含む N 行1列の列ベク
%                             トル
%         CurveDates        - ZeroRates に含まれる各ゼロ利率の満期日をシ
%                             リアル日付形式で示した満期日の日付で構成さ
%                             れる N 行1列ベクトル
%
% 参考 : ZERO2PYLD, ZBTPRICE, ZBTYIELD, TERMFIT, ZERO2FWD, FWD2ZERO, 
%        ZERO2DISC, DISC2ZERO.


%Author: J. Akao and C. Bassignani, 11-19-97
%   Copyright 1995-2002 The MathWorks, Inc. 
