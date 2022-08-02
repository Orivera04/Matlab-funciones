% X2MDATE   Excelシリアル日付番号書式をMATLABシリアル日付番号書式へ変換
%
%     DateNumber = x2mdate(ExcelDateNumber, Convention)
%
% 詳細: この関数は、Excelシリアル日付番号書式をMATLABシリアル日付番号
%       書式へ変換します。
%
% 入力: 
% ExcelDateNumber - Excelシリアル日付番号書式で示されたシリアル日付番号
%                   のN行1列、または、1行N列ベクトルです。
%  
% Convention      -  Excel上で日付文字列からシリアル日付番号への変換を
%                    行う際に、どのシリアル日付番号変換規則を用いるかを
%                    示すN行1列、または、1行N列ベクトル、または、スカラ
%                    フラグ値です。設定できる値は、つぎの通りとなります。
%              
%                    a) Convention = 0 - シリアル日付番号1が1899年12月31
%                                        日に対応する1900日付システム
%                                        (デフォルト)
%                    b) Convention = 1 - シリアル日付番号0が1904年1月1日
%                                        に対応する1904日付システム
%
% 出力: MATLABシリアル日付番号形式で表示されたシリアル日付番号のN行1列、
%       または、1行N列ベクトルです。
%
% 例題: 
%  StartDate = 35746
%  Convention = 0;
%
%  EndDate = x2mdate(StartDate, Convention);
%
% この結果、つぎの値が出力されます。
%
%  EndDate = 729706
%
% 参考 : M2XDATE.


%Author(s): C. Bassignani, 11-12-97 
%   Copyright 1995-2002 The MathWorks, Inc.
