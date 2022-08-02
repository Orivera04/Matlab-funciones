% INSTENGINEADD   定義された商品の作成関数に対応するサブルーチン
%
% INSTADDCF, INSTADDBOND, INSTCAP 等の商品作成関数に対応するボイラプレート
% コードです。クラス及びサイズ制限によって引数を解釈し、商品変数作成の
% ためにその結果を INSTENGINESET に受け渡します。
%
%   ISet = instengineadd(TypeString, FieldInfo, varargin{:})
%
%   [FieldList, ClassList, TypeString, SizeList, DefDataList] = ...
%          instengineadd(TypeString, FieldInfo)
%
% 入力:
%    TypeString  - 追加される商品のタイプを指定する文字列
%
%    FieldInfo   - つぎの列からなる NFIELDS 行 4 列のセル配列 :
%                   FieldList, ClassList, SizeList, DefDataList.
%
%    varargin{:} - フィールドに対応する入力データ引数です。データ引数が
%                  何ら存在しない場合、フィールド情報の出力のために、
%                  2番目の使用法が用いられます。
%
% 出力: 
% 出力は、1 行1列、または、5 行 1列のセル配列にラッピングされます。
%    ISet        - 商品の集合からなる変数。商品は、タイプ毎に分類され、
%                  そのそれぞれのタイプについて互いに異なるデータフィー
%                  ルドを設定することができます。記憶されたデータフィー
%                  ルドは、商品のそれぞれに対応する行ベクトル、または、
%                  文字列となっています。変数 ISet に関する詳細について
%                  は、"help instget" とタイプしてください。
% 
%   FieldList    - 各データフィールドの名称をリスト表示する文字列で構成
%                  される NFIELDS 行1列のセル配列。
% 
%   ClassList    - 各フィールドのデータクラスを記載する文字列からなる 
%                  NFIELDS 行1列のセル配列、ここに記載されるデータクラス
%                  によって、引数の解釈法が決定されます。入力可能な引数
%                  は、'dble', 'date', 'char'です。 
% 
%    SizeList    - サイズ制限を示す配列からなる NFIELDS 行1 列のセル配列。
%                  各サイズ制限配列は、それぞれの次元で許容される引数サ
%                  イズの最大値を示す1行 2 列の配列となっています。詳細
%                  については、"help finargflip" とタイプしてください。
% 
%    DefDataList - データ入力値のデフォルト値を示す NFIELDS 行1列のセル
%                  配列です。この情報は現在では未使用となっています。
% 
% 注意：
% この関数は、将来のリリースにおいてサブルーチン及びサブジェクトインタ
% フェースを変更することになっています。INSTENGINEADD は、ユーザ関数と
% して実行されることを意図して設計されていません。
%
% 参考 : INSTGETFIELD, INSTADDCF, INSTADDCAP, INSTADDBOND.


%   Author(s): J. Akao 19-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
