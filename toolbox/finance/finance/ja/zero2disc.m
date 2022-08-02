% ZERO2DISC   与えられたゼロ曲線から割引曲線を導出
%
%   [DiscRates, CurveDates] = zero2disc(ZeroRates, CurveDates, .....
%      Settle, InputCompounding, InputBasis)
%
% 詳細：
% ゼロ曲線と満期日のセットが入力として与えられると、この関数は、1組の
% 割引ファクタ、または、割引曲線を入力された満期日によって示される所有
% 期間について生成します。
%
% 入力: 
%   ZeroRates        
%     (必須)与えられた所有期間のゼロ曲線を総体的に示すゼロ率(10進数表記)
%      の N 行1列のベクトル
%   CurveDates       
%     (必須)入力されたゼロ率に対応する満期日をシリアル日付番号で示すN行
%      1列のベクトル
%   MSettle          
%      (必須)入力されたゼロ曲線の満期日をシリアル日付番号で示すスカラ値
%      (たとえば、ゼロ曲線がブートストラップされる債券の満期日)
%   InputCompounding 
%      (オプション)入力されたゼロ率を年率に換算するときに、どのくらいの
%      割合で複利計算を行うかを示すスカラ値
% 
%      入力できる値は、つぎの通りです。
%           InputCompounding =   1 - 1年複利計算、または、年あたり1回の
%                                    支払い
%           InputCompounding =   2 - (デフォルト)半年複利計算
%           InputCompounding =   3 - 年3回複利計算
%           InputCompounding =   4 - 年4回複利計算
%           InputCompounding =   6 - 隔月複利計算
%           InputCompounding =  12 - 月1回複利計算
%           InputCompounding = 365 - 毎日複利計算
%           InputCompounding =  -1 - 連続複利計算
%
%   InputBasis       
%       (オプション)入力されたゼロ率を年率に換算するときに、どの日数カウ
%       ント基準を用いるかを示すスカラ値。入力できる値は、つぎの通りです。
%            1)Basis = 0 - actual/actual(デフォルト)
%            2)Basis = 1 - 30/360
%            3)Basis = 2 - actual/360
%            4)Basis = 3 - actual/365
%
% 出力:    
%   DiscRates       - 10進数で表された割引ファクタの N 行1列の列ベクトル
%   CurveDates      - DiscRatesを構成する各割引ファクタの満期日をシリア
%                     ル日付番号で示す N 行1列の列ベクトルです。
%
% 参考 : DISC2ZERO, ZBTPRICE, ZBTYIELD, TERMFIT, ZERO2FWD, FWD2ZERO, 
%        PYLD2ZERO, ZERO2PYLD.


%Author(s): C. Bassignani, 11/21/97 
%   Copyright 1995-2002 The MathWorks, Inc. 
