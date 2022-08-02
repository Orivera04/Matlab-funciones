% YEARFRAC   日付間の年の端数
%
%    [YearFraction] = yearfrac(Date1, Date2, Basis)
%
% 詳細: この関数は、指定された日付カウント基準を用いて、2つの日付間の
%       日数に基づき、当該日付間の年の端数を出力します。
%
% 入力: 
%  Date1 - 開始日を示す日付文字列、または、シリアル日付番号で構成される 
%          N行1列、または、1行N列のベクトルです。
%  
%  Date2 - 最終日を示す日付文字列、または、シリアル日付番号で構成される 
%          N行1列、または、1行N列のベクトルです。
%
%  Basis - 日付の各セットに対して適用される日付カウント基準を指定する値
%          で構成されるN行1列、または、1行N列のベクトルです。入力できる
%          値は、つぎの通りです。
%              a) Basis 0 - actual/actual(デフォルト)
%              b) Basis 1 - 30/360
%              c) Basis 2 - actual/360
%              d) Basis 3 - actual/365
%
% 出力: 
%  YearFraction - Date1 及び Date2 間の間隔を年で示した実数のN行1列、
%                 または、1行N列のベクトルです。
%
% 参考 : YEAR.


%Author(s): C.F. Garvin, 2-23-95; C. Bassignani, 11-12-97 
%   Copyright 1995-2002 The MathWorks, Inc. 
