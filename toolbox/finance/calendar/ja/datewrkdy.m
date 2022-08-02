% DATEWRKDY   将来、または、過去の営業日
%
%     EndDate = datewrkdy(StartDate, NumberWorkDays, NumberHolidays) 
%
% 詳細：この関数は、営業日及び休日に関して、設定した日数だけ将来、
%   または、過去に日付を移動して、将来、または、過去の日の日付を出力
%   します。
%
% 入力: 
% StartDate       - 最初の日付をシリアル日付番号、または、日付文字列で示す
%                   値で構成されるN行1列、または、1行N列のベクトルです。
% NumberWorkDays  - 将来(正の場合)、または、過去(負の場合)にどれだけの
%                   営業日数だけ日付を動かすかを指定する値で構成される
%                   N行1列、または、1行N列のベクトルです。
% NumberHolidays  - 将来(正の場合)、または、過去(負の場合)にどれだけの
%                   休日数だけ日付を動かすかを指定する値で構成されるN行
%                   1列、または、1行N列のベクトルです。
% 
% 出力: 
% EndDate         - 結果として求まる将来、または、過去の日付の日付番号を
%                   示すN行1列、または、1行N列のベクトルです。
%
% 例題: 
%              StartDate = '20-Dec-1994';
%              NumberWorkDays = 16;
%              NumberHolidays = 2;
%
%              datewrkdy(StartDate, NumberWorkDays, NumberHolidays)
%
%              この結果、つぎの値が出力されます。  
%
%              EndDate = 728671 (12-Jan-1995)
% 
% 参考 : WRKDYDIF. 


%Author(s): C.F. Garvin, 2-23-95; C. Bassignani, 10-26-97 
%   Copyright 1995-2002 The MathWorks, Inc. 
