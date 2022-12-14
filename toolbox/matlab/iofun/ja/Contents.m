% ファイルの入出力
%
% ファイルのインポート/エクスポート関数
%   dlmread     - デリミタ付きテキストファイルの読み込み
%   dlmwrite    - デリミタ付きファイルに書き出し
%   load        - MATLAB (MAT) ファイルからデータをワークスペースに読み込む
%   importdata  - ワークスペース変数ディスクファイルを読み込む
%   wk1read     - スプレッドシート(WK1)ファイルの読み込み
%   wk1write    - スプレッドシート(WK1)ファイルの書き出し
%   xlsread     - スプレットシート(XLS)ファイルの読み込み
%
% インターネットリソース
%   urlread     - URLの内容を文字列に読み込む
%   urlwrite    - URLの内容をローカルファイルに書き出す
%   sendmail    - 電子メールの送信
%
% Zip ファイルアクセス
%   zip         - ファイルをzipファイルに圧縮
%   unzip       - zipファイルの内容の解凍
%
% 書式付きファイル入出力
%   fgetl       - 行の終端子なしで、ファイルのつぎの行を1つの文字として出力
%   fgets       - 行の終端子付きで、ファイルのつぎの行を1つの文字として出力
%   fprintf     - データを書式付きでファイルに書き出す
%   fscanf      - データを書式付きでファイルから読み込む
%   input       - ユーザ入力の要求
%   textread    - データを書式付きでテキストファイルから読み込む
%
% 文字列の変換
%   sprintf     - データを書式付きで文字列に書き出す
%   sscanf      - 書式を制御して文字列を読み込む
%   strread     - テキスト文字列から書式付きデータの読み込み
%
% ファイルのオープンとクローズ
%   fopen       - ファイルのオープン
%   fclose      - ファイルのクローズ
%
% バイナリファイルの入出力
%   fread       - ファイルからバイナリデータを読み込む
%   fwrite      - バイナリデータをファイルに書き出す
%
% ファイルの位置
%   feof        - EOF(ファイルの終了)の検出
%   ferror      - ファイルのエラーの状態を調べる
%   frewind     - ファイルのリワインド
%   fseek       - ファイルの位置指示子の設定
%   ftell       - ファイルの位置指示子の取得
%
% ファイル名の操作
%   fileparts   - ファイル名の部分
%   filesep     - プラットフォームに対するディレクトリのセパレータ
%   fullfile    - 完全なファイル名を複数のファイル名から作成
%   matlabroot  - MATLAB がインストールされているルートディレクトリ
%   mexext      - プラットフォームに対する MEX ファイル名の拡張子
%   partialpath - 部分パス名
%   pathsep     - プラットフォームに対するパスのセパレータ
%   prefdir     - 参照ディレクトリ
%   tempdir     - テンポラリディレクトリの取得
%   tempname    - テンポラリファイルの取得
%
% XML ファイルの取り扱い
%   xmlread     - MLファイルを文法解釈し Document Object Model ノードを出力
%   xmlwrite    - XML Document Object Model ノードをシリアル化
%   xslt        - XSLT エンジンを使って XML ドキュメントを変換
%
% シリアルポートサポート
%   serial      - serial port オブジェクトの作成
%
% Timer サポート
%   timer       - timer オブジェクトの構築
%
% コマンドウィンドウ I/O
%   clc         - コマンドウィンドウの消去
%   disp        - 配列の表示
%   home        - カーソルをホームに移動
%   input       - ユーザ入力の要求
%   pause       - ユーザ応答を待ちます
%
% FIG ファイルの plotedit と printframes のサポート
%   hgload      - ファイルから Handle Graphics オブジェクトをロード
%   hgsave      - HG オブジェクトの階層をファイルに保存
%
% ユーティリティ
%   str2rng     - スプレッドシートの範囲文字列を数値配列に変換
%   wk1const    - WK1 レコードタイプの定義
%   wk1wrec     - WK1 レコードヘッダの書き出し
%
% 参考 AUDIOVIDEO, IMAGESCI.

% 廃止された関数
%   csvread     - カンマで区切られた値のファイルを読み込む
%   csvwrite    - カンマで区切られた値のファイルを書き出す

%   Copyright 1984-2004 The MathWorks, Inc.
