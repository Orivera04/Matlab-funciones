% HOLIDAYS   休日及び休業日
%
% H = HOLIDAYS(D1,D2)は、日付 D1 及び D2 間の休日及び休業日に対応する
% シリアル日付番号のベクトルを全て出力します。H = HOLIDAYS は、既知の
% 休業日データを出力します。
%
% この関数には、1950年から2030年までの間のニューヨーク株式市場の休日及び
% 休業日全てのデータが組み込まれています。
% 
% 注意: 1998年1月以降、Martin Luther King Jr. Day が、米国市場で休日と
%       なりました。
%
% たとえば、h = holidays('01-jan-1997','23-jun-1997') は、
% h =  729391, 729438, 729477, 729536 を出力します。
% すなわち、1997年1月1日、1997年2月17日、1997年3月28日、1997年5月26日に
% 対応するシリアル日付番号を出力します。
%
% 参考 : BUSDATE, FBUSDATE, ISBUSDAY, LBUSDATE.


%        Author(s): C.F. Garvin and J. Abbott, 10-24-95
%   Copyright 1995-2002 The MathWorks, Inc. 
