% LBUSDATE   月の最後の営業日
%
% D = LBUSDATE(Y,M,HOL,WEEKEND) 
%
% 入力:
%
%   Y - 年
%       例題: 2002
%
%   M - 月
%       例題: 12 (12月)
%
% 入力(オプション):
%
%   HOL - 休業日を示すベクトルです。HOL の指定がない場合、休業日のデータは
%         HOLIDAYS ルーチンによって出力されます。
%         現時点では、HOLIDAYS はNYの休日をサポートします。
%
%   WEEKEND - 週末を1とする0と1を含む長さ7のベクトルです。
%             このベクトルの最初の要素は、日曜日に対応します。
%             そのため、土曜日と日曜日が週末とすると、
%             WEEKDAY = [1 0 0 0 0 0 1] となります。デフォルトでは、
%             土曜日と日曜日が週末になります。
% 出力:
%
%   D - 指定された月の最後の営業日
%
% たとえば、d = lbusdate(1997,5) は、1997年5月30日に相当するシリアル
% 日付番号 d = 729540 を出力します。
% 
% 参考 : BUSDATE, EOMDATE, FBUSDATE, HOLIDAYS, ISBUSDAY.


% Author(s): C.F. Garvin, 11-14-95 Bob Winata 12-12-02
% Copyright (c) 1995-1999 The MathWorks, Inc. All Rights Reserved.
