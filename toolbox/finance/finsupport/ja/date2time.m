% DATE2TIME   期間固定収入のもたらされる時間と度数を日付から計算
%
% 決済日と満期日との間に付けられる複利換算利率に対応する適切な時間ファク
% タを計算します。
%
%   [Times, F] = date2time(Settle, Maturity, Compounding, .....
%                  Basis, EndMonthRule)
%   F - スカラ
%
% 参考 : CFTIMES, RATE2DISC, DISC2RATE.


%   Author(s): J. Akao
%   Copyright 1995-2002 The MathWorks, Inc. 
