% FWD2ZERO   与えられた内在的フォワード曲線からゼロ曲線を導出
%
%     [ZeroRates, CurveDates] = ....
%        fwd2zero(ForwardRates, CurveDates, Settle, ....
%        OutputCompounding, OutputBasis, InputCompounding,InputBasis)
%
% 詳細：
% 入力として内在的フォワード曲線と一組の満期日が与えられると、この関数は
% 入力された満期日によって示される所有期間に対してゼロ曲線を出力します。
% 
% 入力:
% 　 ForwardRates      - (必須)与えられた所有期間に対するフォワード曲線
%                        を相対的に示す年率換算された内在的フォワード利率
%                        (10進数表示)のN行1列のベクトル
%    CurveDates        - (必須)入力されたフォワード利率に対応する満期日を
%                         シリアル日付で示すN行1列ベクトル
%    MSettle           - (必須)入力された内在的フォワード曲線に対して決
%                         済日をシリアル日付形式で表示するスカラ値
%    OutputCompounding - (オプション)出力されるゼロ利率を年率に換算する
%                         ときに、どのくらいの率で複利計算を行うかを示
%                         すスカラ値。入力できる値はつぎの通りです。
%              OutputCompounding = 1   -  一年複利計算
%              OutputCompounding = 2   -  (デフォルト)半年複利計算
%              OutputCompounding = 3   -  年3回複利計算
%              OutputCompounding = 4   -  年4回複利計算
%              OutputCompounding = 6   -  隔月複利計算
%              OutputCompounding = 12  -  月1回複利計算
%              OutputCompounding = 365 -  一日複利計算
%              OutputCompounding = -1  -  連続複利計算
%     OutputBasis      - (オプション)出力されるゼロ利率を年率に換算する
%                        ときにどの日数カウント基準を用いるかを示す
%                        スカラ値。入力できる値は、つぎの通りです。
%              1)Basis = 0 - actual/actual(デフォルト)
%              2)Basis = 1 - 30/360
%              3)Basis = 2 - actual/360
%              4)Basis = 3 - actual/365
%     InputCompounding - (オプション)入力したフォワード利率を年率に換算
%                        するときにどのくらいの割合で複利計算を行うかを
%                        示すスカラ値。デフォルトでは、OutputCompounding
%                        と同じ値となっています。
%     InputBasis       - (オプション)入力したフォワード利率を年率に換算
%                        するときにどの日数カウント基準を用いるかを示す
%                        スカラ値。デフォルトでは、OutputBasis と同じ値
%                        になっています。
%
% 出力: 
%           ZeroRates  - 10進法表記のゼロ利率を含むNx1列ベクトル
%           CurveDates - ZeroRates に含まれる各ゼロ利率の満期日をシリアル
%                        日付形式で示した満期日の日付で構成されるN行1列
%                        のベクトル
%
% 参考 : ZERO2FWD, ZBTPRICE, ZBTYIELD, ZERO2DISC, DISC2ZERO, TERMFIT, 
%        PYLD2ZERO, ZERO2PYLD.


%Author(s): J. Akao and C. Bassignani, 11/21/97 
%   Copyright 1995-2002 The MathWorks, Inc. 
