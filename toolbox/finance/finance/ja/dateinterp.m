% DATEINTERP   金融シリアル日付に利率を内挿します。一連の参照する利率
%              曲線から列方向に内挿を行います。
%
% 表示：
%   Rates = dateinterp(RefDates, RefRates, Dates, Basis)
%
% 入力：
%   RefDates : 参照する点となる日付を示したNref行1列のベクトル
%   RefRates : 参照する利率を示すNref行Ncurve列の行列。この行列の各列は、
%              RefDates で観測される利率曲線です。
%   Dates    : 内挿される利率を計算するために用いる日付のNdates行1列の
%              ベクトル
%   Basis    : 経過時間を計算するために用いる市場日数カウント基準
%
% 出力：
%   Rates    : 内挿された利率のNdates行Ncurve列の行列。行列の各列は
%              RefRates内の対応する利率曲線から導出された利率曲線です。
%              内挿は、RefDatesの範囲外では定数内挿、RefDatesの範囲外
%              では線形内挿となっています。
%
% 参考 : INTERP1Q, DAYSDIF.


%   Training example function JHA 1/13/98
%   Copyright 1995-2002 The MathWorks, Inc. 
