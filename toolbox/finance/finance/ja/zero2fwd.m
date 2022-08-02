% ZERO2FWD   与えられたゼロ曲線から内在フォワード利率曲線を導出
%
%  [ForwardRates, CurveDates] = zero2fwd(ZeroRates, CurveDates, ......
%     Settle,OutputCompounding, OutputBasis,InputCompouding,InputBasis)
%
% 詳細：
% ゼロ曲線と1組の満期日が入力として与えられると、この関数は入力された
% 満期日によって示される所有期間に対して内在的フォワード利率曲線を出力し
% ます。
%
% 入力:  
%    ZeroRates         
%        (必須)与えられた所有期間のゼロ曲線を総体的に示すゼロ率(10進数表
%         記)の N 行1列のベクトル
%    CurveDates        
%        (必須)入力されたゼロ率に対応する満期日をシリアル日付番号で示す 
%        N 行1列のベクトル
%    MSettle           
%        (必須)入力されたゼロ曲線の満期日をシリアル日付番号で示すスカラ
%        値(すなわち、ゼロ曲線がブートストラップされる債券の満期日)
%    OutputCompounding 
%        (オプション)出力される内在的フォワード利率を年率に換算するとき
%        にどのくらいの割合で複利計算を行うかを示すスカラ値。入力できる
%        値は、つぎの通りです。
%              OutputCompounding =   1 - 1年複利計算
%              OutputCompounding =   2 - (デフォルト)半年複利計算
%              OutputCompounding =   3 - 年3回複利計算
%              OutputCompounding =   4 - 年4回複利計算
%              OutputCompounding =   6 - 隔月複利計算
%              OutputCompounding =  12 - 月1回複利計算
%              OutputCompounding = 365 - 毎日複利計算
%              OutputCompounding =  -1 - 連続複利計算
%
%    OutputBasis       
%         (オプション)出力される内在的フォワード利率を年率に換算するとき
%         にどの日数カウント基準を用いるかを示すスカラ値。入力できる値は
%         つぎの通りです。
%              1)Basis = 0 - actual/actual(デフォルト)
%              2)Basis = 1 - 30/360
%              3)Basis = 2 - actual/360
%              4)Basis = 3 - actual/365
%
%    InputCompounding  
%         (オプション)入力されたゼロ率を年率に換算するときに、どのくらい
%         の割合で複利計算を行うかを示すスカラ値。デフォルト値は、
%         OutputCompounding の値となっています。
%
%    InputBasis        
%         (オプション)入力されたゼロ率を年率に換算するときに、どの日数
%          カウント基準を用いるかを示すスカラ値。デフォルト値は、
%          OutputBasis の値となっています。
%
% 出力: 
%    ForwardRates      
%           内在的フォワード利率を10進法で示す N 行1列の列ベクトル
%    CurveDates        
%           ForwardRates を構成する各内在的フォワード利率の満期日をシリ
%           アル日付番号で示す N 行1列の列ベクトル
%
% 参考 : FWD2ZERO, ZBTPRICE, ZBTYIELD, ZERO2DISC, DISC2ZERO, TERMFIT, 
%        PYLD2ZERO, ZERO2PYLD.


%Author(s): J. Akao and C. Bassignani, 11/21/97 
%   Copyright 1995-2002 The MathWorks, Inc. 
