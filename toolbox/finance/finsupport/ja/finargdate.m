% FINARGDATE   引数をシリアル日付形式の行列にフォーマット
%
% 互いに長さが異なる行を NaN でパディングし、シリアル日付形式の NROWS 行
% MAXCOLS 列の行列を生成します。日付入力には、シリアル日付形式、または、
% キャラクタで入力できます。出力される行は、入力された行列の行、または、
% 入力セル配列の要素から生成されます。
%   
%   [DateNums] = finargdate(DateNumArg)
%   [DateNums] = finargdate(DateStrArg)
%   [DateNums] = finargdate(CellArg)
%
% 入力:
%   DateNumArg - シリアル日付番号からなる NROWS 行 MAXCOLS 列の行列
%
%   DateStrArg - 日付文字列の NROWS 行 NCHAR 列のキャラクタです。使用
%                可能な日付書式の詳細については、"help datestr" とタイプ
%                してください。時間を含む書式についてはサポートの対象と
%                なっておりません。一つの行には、別々の列に設定される
%                可能性のあるいくつかの日付を含むことができます。日付と
%                して認識されない文字列は、NaN に置き換えられます。
%
%   CellArg    - シリアル日付、または、キャラクタ行列からなるNROWS行1列
%                のセル配列です。このセル配列は、単一の行として処理され
%                ます。1つのセル内に複数の要素がある場合、それらは別々
%                の列に配置されます。空白のセルや、日付として認められな
%                い文字列は全て NaN で置き換えられます。
%
% 出力:
%   DateNums   - シリアル日付番号の NROWS 行 MAXCOLS 列の行列です。
%                MAXCOLS は、各行で検出された日付の最大数を示しています。
%                より短い行は、行列を埋めるために NaN でパディングされ
%                ます。空の入力は、単一の NaN 出力を生成し、日付と認め
%                られないタイプの入力は空の出力を生成します。文字列と
%                して出力を表示するには、"datedisp(DateNums)" とタイプ
%                してください。
%
% 例題:
%   DateNumArg = [
%      730135      730316      730500
%      730166      730347         NaN ]
%   DateNums = finargdate(DateNumArg)
%     DateNums =
%         730135      730316      730500
%         730166      730347         NaN
%
%   DateStrArg = ['10/22/99'; '        '; '03/15/01']
%   DateNums = finargdate(DateStrArg)
%     DateNums =
%         730415
%            NaN
%         730925
%
%   CellArg = { 730135 ; 'NULL' ; '10/22/99  03/15/01' }
%   DateNums = finargdate(CellArg)
%      DateNums =
%          730135         NaN
%             NaN         NaN
%          730415      730925
%
% 参考 : DATENUM, DATESTR, DATEDISP, FINARGCHAR, FINARGDBLE.


%   Author(s): J. Akao 
%   Copyright 1995-2002 The MathWorks, Inc. 
