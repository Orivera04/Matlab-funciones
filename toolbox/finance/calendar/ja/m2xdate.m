% M2XDATE   MATLABシリアル日付番号をExcelシリアル日付番号に変換
% 
% DateNumber = m2xdate(MATLABDateNumber, Convention)
%
% 詳細： この関数は、MATLABシリアル日付番号書式をExcelシリアル日付番号
%        書式に変換します。
%
% 入力: 
% MATLABDateNumber - MATLABシリアル日付番号で表示されたシリアル日付番号
%                    のN行1列、または、1行N列のベクトルです。
%  
% Convention       - MATLABシリアル日付番号から変換を行う際に、どの 
%                    Excelシリアル日付番号変換規則を用いるかを示す 
%                    N行1列、または、1行N列のベクトル、または、スカラの
%                    フラグ値です。設定できる値は、つぎの通りとなります。
%                    a) Convention = 0 - シリアル日付番号1が、1899年12月
%                                        31日に対応する1900日付システム
%                                        (デフォルト)
%                    b) Convention = 1 - シリアル日付番号0が、1904年1月1日
%                                        に対応する1904日付システム
%
% 出力: Excelシリアル日付番号形式で表示されたシリアル日付番号のN行1列、
%       または、1行N列のベクトル
% 
% 例題: 
%  StartDate = 729706
%  Convention = 0;
%
%  EndDate = m2xdate(StartDate, Convention);
%
% この結果、つぎの値が出力されます。
%
%  EndDate = 35746
%
% 参考 : M2XDATE.


%Author(s): C. Bassignani, 11-12-97 
%   Copyright 1995-2002 The MathWorks, Inc. 
