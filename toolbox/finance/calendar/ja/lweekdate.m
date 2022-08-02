% LWEEKDATE   月の最後の週日
%
% D = LWEEKDATE(WKD,Y,M,G)は、与えられた月の与えられた週の最後の日を
% シリアル日付番号で出力します。WKD は、週日です(1から7の数字のそれぞれが
% 日曜から土曜に対応しています)。Y は年、M は月、G は同じ週の WKD 以後に
% 到来する週日を指定します。
%
% たとえば、1997年6月の最後の月曜日を見つけるには、
% 
% d = lweekdate(2,1997,6) として、1997年6月30日に対応するシリアル
% 日付番号 729571 を出力します。
%      
% 参考 : EOMDATE, LBUSDATE, NWEEKDATE.


%        Author(s): C.F. Garvin, 01-08-96
%   Copyright 1995-2002 The MathWorks, Inc. 
