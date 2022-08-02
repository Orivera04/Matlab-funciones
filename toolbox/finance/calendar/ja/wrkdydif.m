% WRKDYDIF   日付間の営業日の数
%
%  NumberDays = WRKDYDIF(Date1, Date2, NumberHolidays) 
%
% 詳細: この関数は、休業日数が設定されると、2つの日付間の営業日数を
%       出力します。
% 
% 入力: 
%  Date1          - 開始日を示す日付文字列、または、シリアル日付番号で
%                   構成される N行1列、または、1行N列のベクトルです。
%  
%  Date2          - 最終日を示す日付文字列、または、シリアル日付番号で
%                   構成されるN行1列、または、1行N列のベクトルです。
%  
%  NumberHolidays - 次の休日までの将来(正)または過去(負)への移動日数を示す
%                   値で構成されるN行1列、または、1行N列のベクトルです。 
%
%  出力: 
%  NumberDays      - Date1 及び Date2 の間の日数を示すN行1列、または、
%                    1行N列のベクトルです。
%
%  例題: 
%  Date1 = '9/1/1995';
%  Date2 = '9/11/1995';
%  NumberHolidays = 1;
%
%  NumberDays = wrkdydif(Date1, Date2, NumberHolidays)
%
%  この結果、つぎの値が出力されます。
%
%   NumberDays = 6
% 
% 参考 : DATEWRKDY.


%Author(s): C.F. Garvin, 2-23-95, C. Bassignani, 10-7-97
%       Copyright 1995-2002 The MathWorks, Inc. 
