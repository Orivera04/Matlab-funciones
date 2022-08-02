% DAYS360   360日を1年とする日付間の日数 (SIA準拠)
%
% この関数は、30/360の日数カウント基準で、入力された2つの日付間の日数を
% 出力します。
%
%   NumberDays = days360(StartDate, EndDate)
%
% 入力: 
% StartDate  - 最初の日付をシリアル日付番号、または、日付文字列で示す値
%              で構成されるN行1列、または、1行N列のベクトルです。
% EndDate    - 最後の日付をシリアル日付番号、または、日付文字列で示す値
%              で構成されるN行1列、または、1行N列のベクトルです。
%
% 出力:
% NumberDays - 2つの日付間の日数を示すN行1列、または、1行N列のベクトル
%              またはスカラ値です。
%
% 例題: StartDate = '28-Feb-1994';
%       EndDate   = '1-Mar-1994';
%
%       NumberDays = days360(StartDate, EndDate);
%
% は、
%
%       NumberDays = 1 を出力します。
%
% 参考 : DAYS365, DAYSACT, DAYSDIF.


%Author(s): C.F. Garvin, 2-23-95; C. Bassignani, 10-17-97; Bob Winata 1-18-02 
%       Copyright (c) 1995-1999 The MathWorks, Inc. All Rights Reserved. 
