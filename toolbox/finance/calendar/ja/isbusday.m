% ISBUSDAY   日付が営業日である場合の判定
%
% T = ISBUSDAY(D,HOL,WEEKEND)
%
% 入力:
%        
%   D       - 該当する日付のベクトル
%
% 入力(オプション):
%
%   HOL     - ユーザ定義の休日のベクトルです。デフォルトは、(holidays.mの)
%             あらかじめ定義されているUSの休日です。
%
%   WEEKEND - 週末を1とする0と1を含む長さ7のベクトルです。
%             このベクトルの最初の要素は、日曜日に対応します。
%             そのため、土曜日と日曜日が週末とすると、
%             WEEKDAY = [1 0 0 0 0 0 1] となります。デフォルトでは、
%             土曜日と日曜日が週末になります。
%
% 出力:
%
%   T       - D が営業日である場合は1、そうでない場合は0です。
%
%
% たとえば、
%
%   Date = ['15 feb 2001'; '16 feb 2001'; '17 feb 2001'];
%
% として、(holidays.mから)あらかじめ定義されているUSの休日ベクトルを
% 用いて、日曜日のみを週末として営業日を見つけるには、MATLABに以下の
% ように指示します。
%
%   Busday = isbusday(Date, [], [1 0 0 0 0 0 0])
%
% 参考 : BUSDATE, FBUSDATE, HOLIDAYS, LBUSDATE.


%   Author(s): C.F. Garvin, M. Reyes-Kattar, 10-24-95 Bob Winata, 04-02-02
%   Copyright (c) 1995-1999 The MathWorks, Inc. All Rights Reserved.
