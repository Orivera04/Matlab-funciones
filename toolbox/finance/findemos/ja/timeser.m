% TIMESER   時系列プロットの XData を正確な日付値に変換
%
% T = TIMESER(START,PERIODS,HLDAYS)は、時系列プロットの XData を適切な
% 日付値に変換します。これにより、DATEAXIS コマンドを用いて、軸目盛り
% ラベルを変換したい書式の日付文字列ラベルに変換を行うことが可能となり
% ます。START は、時系列の開始日です。PERIODS は、データの度数を指定し
% ます。
%
%              データ度数               Periodsの設定値
%
%                 日単位                       1(デフォルト)
%                 週単位                       2
%                 月単位                       3
%                 四半期単位                   4
%                 半年単位                     5
%                 年単位                       6
%
% 土曜日と日曜日は、XData ベクトルから指定された HLDAYS 同様に取り除かれ
% ます。HLDAYS は、時系列データと関連付けられたデータから除去される土曜
% 日、日曜日以外の他の休業日を示します。HLDAYS は、つぎの方法で設定でき
% ます。まず、1つは、この関数を編集し、適切な日付を追加する方法、もう1つ
% は、HLDAYS と名付けられたグローバル変数に日付を定義する方法、最後に
% 第三の引数として値を入力する方法です。
%
% TIMESER は、今日の日付を開始日として、XData を日付ベクトルに変換します。
% デフォルトでは、HLDAYS は、関数 TIMESER の内部で定義されるか、または、
% ユーザによってグローバル変数として定義されます。
%
% TIMESER(START) は、XData を START で指定された日付を開始日として、XData
% を日付ベクトルに変換します。デフォルトでは、データは日単位のデータ
% (PERIODS = 1)として処理され、HLDAYS は、関数 TIMESER の内部で定義される
% か、または、ユーザによって、グローバル変数として定義されます。
%
% TIMESER(START,PERIODS) は、START で指定された日付を開始日、PERIODS で
% 指定された値をデータの度数として、XData を日付ベクトルに変換します。
% デフォルトでは、HLDAYS は、関数 TIMESER の内部で定義されるか、または、
% ユーザによってグローバル変数として定義されます。
%
% TIMESER(START,PERIODS,HLDAYS) は、START で指定された日付を開始日、
% PERIODS で指定された値をデータの度数として、休業日情報として HLDAYS を
% 使用して、XData を日付ベクトルに変換します。
%
% TRADDAYS = TIMESER(...) は、時系列プロットの XData を変更せずに、日付
% ベクトル情報を、MATLAB ワークスペースに出力します。
%
% 参考 : DATEAXIS.


%       Author(s): C.F. Garvin, 7-17-95
%       Copyright (c) 1995-1999 The MathWorks, Inc. All Rights Reserved.
