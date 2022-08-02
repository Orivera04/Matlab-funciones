% ZERO2PYLD   与えられたゼロ曲線から額面利回り曲線を導出
%
%     [ParRates, CurveDates] = zero2pyld(ZeroRates, CurveDates, ....
%        Settle, OutputCompounding, OutputBasis, InputCompounding,....
%        InputBasis)
%
% 詳細： 
% ゼロ曲線及び一組の満期日が入力として与えられると、この関数は入力された
% 満期日によって示される所有期間について額面利回り曲線を出力します。
%
% 入力: 
%   ZeroRates         
%      (必須)年率換算されたゼロ率を10進数で示す N 行1 列のベクトル
%   CurveDates        
%      (必須)入力されたゼロ率に対応する満期日をシリアル日付番号で示すN行
%       1列のベクトル
%   Settle            
%      (必須)当該債券の決済日をシリアル日付番号で示すスカラ値
%   OutputCompounding  
%      (オプション)額面売買債券のクーポン頻度を示すスカラ値
%
%      入力できる値は、つぎの通りです。
%              OutputCompounding =   1 - 1年複利計算、または、年1回払い
%              OutputCompounding =   2 - (デフォルト)半年複利計算
%              OutputCompounding =   3 - 年3回複利計算
%              OutputCompounding =   4 - 年4回複利計算
%              OutputCompounding =   6 - 隔月複利計算
%              OutputCompounding =  12 - 月1回複利計算
%
%   OutputBasis       
%      (オプション)額面売買債券の日数カウント基準を示すスカラ値。
% 　　　
%       入力できる値は、つぎの通りです。
%              1)Basis = 0 - actual/actual(デフォルト)
%              2)Basis = 1 - 30/360
%              3)Basis = 2 - actual/360
%              4)Basis = 3 - actual/365
%
%   InputCompounding  
%      (オプション)入力されたゼロ率を年率に換算するときに、どのくらいの
%       割合で複利計算を行うかを示すスカラ値。デフォルト値は、
%       OutputCompounding となっています。
%   InputBasis        
%       (オプション)入力されたゼロ率を年率に換算するときに、どの日数カウ
%       ント基準を用いるかを示すスカラ値。デフォルト値は、OutputBasis 
%       となっています。
%
% 出力: 
%    ParRates         
%        額面売買債券のクーポンレート(額面利回り)を示す N 行1列の列ベク
%        トル
%    CurveDates       
%        各額面売買債券の満期日をシリアル日付番号で示す N 行1列の列ベク
%        トル
%
% 参考 : PYLD2ZERO, ZBTPRICE, ZBTYIELD, TERMFIT, ZERO2FWD, FWD2ZERO, 
%        ZERO2DISC, DISC2ZERO.


%Author: J. Akao and C. Bassignani, 11-25-97
%   Copyright 1995-2002 The MathWorks, Inc. 
