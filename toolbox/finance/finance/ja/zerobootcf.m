% ZEROBOOTCF   ゼロ曲線ブートストラップエンジン
%
%  [ZeroRates, EndTimes, EndDates] = zeroboot(Prices, CFlowAmounts, ...
%               CFlowDates, TFactors)
%
% 入力: 
% "help cfamounts" とタイプすると、キャッシュフロー引数の説明を参照でき
% ます。
%   Price        - 時刻0での NINST 行1列の市場価格
%   CFlowAmounts - キャッシュフローの金額を示す NINST 行 MOSTCFS 列の行列
%   CFlowDates   - キャッシュフローの日付を示す NINST 行 MOSTCFS 列の行列
%   TFactors     - キャッシュフローの半年時間ファクタを示すNINST行
%                  MOSTCFS列の行列
%
% 出力:
%   ZeroRates    - 入力された価格でのキャッシュフローの流れを評価する
%                  ゼロ率の NPOINTS 行1列のベクトル
%   EndTimes     - レートの満期までの半年時間ファクタを示すNPOINTS行1列
%                  のベクトル
%   EndDates     - レートの満期の日付を示す NPOINTS 行1列のベクトル 
%                  EndDates は、NINST キャッシュフローの流れに固有の満期日
%                  です。
%
% 例題:
%   [cfa,cfd,tf] = cfamounts(0.05,today,today+[300 (500:-200:100)])
%   zerobootcf(99:102, cfa, cfd, tf)
%
% 参考 : CFBYZERO, ZBTPRICE.


%   Author(s) : J. Akao 23-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
