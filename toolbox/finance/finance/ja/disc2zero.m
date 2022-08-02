% DISC2ZERO   与えられた割引曲線からゼロ曲線を出力
%
% [ZeroRates, CurveDates] = disc2zero(DiscRates, CurveDates, Settle,...
%      OutputCompounding, OutputBasis)
%
% 詳細： 
% 割引曲線と1組の満期日を入力として与えると、この関数は満期日によって
% 示される所有期間に対して、ゼロ曲線を生成します。ゼロ利率とは、理論上の
% ゼロクーポン債の満期時の利回りのことです。
%
% 入力: 
%    DiscRates          
%       (必須)与えられた所有期間に対する割引曲線を全体的に示す割引ファクタ
%       (10進数表示)のN行1列のベクトル
%    CurveDates        
%       (必須)割引ファクタに対応する満期日をシリアル日付で示すN行1列の
%       ベクトル
%    MSettle           
%       (必須)割引ファクタに対して決済日をシリアル日付形式で表示する
%       スカラ値
%    OutputCompounding 
%       (オプション)出力されるゼロ利率を年率に換算するときにどのくらい
%       の割合で複利計算を行うかを示すスカラ値。入力可能な値は、つぎの
%       通りです。
%            OutputCompounding = 1   -   一年複利計算
%            OutputCompounding = 2   -   (デフォルト)半年複利計算
%            OutputCompounding = 3   -   年3回複利計算
%            OutputCompounding = 4   -   年4回複利計算
%            OutputCompounding = 6   -   隔月複利計算
%            OutputCompounding = 12  -   月1回複利計算
%            OutputCompounding = 365 -   一日複利計算
%            OutputCompounding = -1  -   連続複利計算
%
%     OutputBasis       
%       (オプション)出力されるゼロ利率を年率に換算するときにどの日数カウン
%       ト基準を用いるかを示すスカラ値。入力可能な値は、つぎの通りです。
%            1)Basis = 0 - actual/actual(デフォルト)
%            2)Basis = 1 - 30/360
%            3)Basis = 2 - actual/360
%            4)Basis = 3 - actual/365
%
% 出力: 
%     ZeroRates  - 10進法表記のゼロ利率を含むN行1列の列ベクトル
%     CurveDates - ZeroRates に含まれる各ゼロ利率の満期日をシリアル
%                  日付形式で示した満期日の日付で構成される N 行1列の
%                  列ベクトル
%
% 参考 : ZERO2DISC, ZBTPRICE, ZBTYIELD, TERMFIT, ZERO2FWD, FWD2ZERO, 
%        PYLD2ZERO, ZERO2PYLD.


%Author(s): C. Bassignani, 11/21/97 
%   Copyright 1995-2002 The MathWorks, Inc. 
