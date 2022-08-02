% FINARGDBLE   ������ NaN ���p�f�B���O�����s����Ȃ�{���x�z��Ƀt�H�[
%              �}�b�g
%
% �������݂��ɈقȂ�s�� NaN �Ńp�f�B���O���� NROWS �s MAXCOLS ��̍s��
% �𐶐����܂��B���͂́A�{���x�̐��A�܂��́A�����񂩂��͂��ꂽ���ł��B
% �o�͂����s�́A���͂��ꂽ�s��̍s���琶������邩�A�܂��́A���͂��ꂽ
% �Z���z��̒l���琶������܂��B
%
%   [DbleMat] = finargdble(NumericArg)
%   [DbleMat] = finargdble(StringArg)
%   [DbleMat] = finargdble(CellArg)
%
% ����:
%   NumericArg - NROWS �s MAXCOLS ��̃N���X�{���x�̐��l�z��
%
%   StringArg  - ���l�� NROWS �s STRLEN ��̃L�����N�^��B�X�̐��l�́A
%                STR2DOUBLE �ɂ���ĉ�͂���܂��B�X�y�[�X���\�����鐔��
%                �T�|�[�g���Ă��܂���B�s�́A�ʁX�ȗ�ɐݒ肳��邢����
%                ���̐������܂ނ��Ƃ��ł��܂��B���l�ɒu�������邱�Ƃ�
%                �ł��Ȃ��l�́ANaN �ŕ\������܂��B
%
%   CellArg    - �{���x�̐��A�܂��́A�L�����N�^�s�񂩂�Ȃ� NROWS �s1��
%                �̃Z���z��ł��B���̃Z���z����\�����邻�ꂼ��̃Z����
%                �P��̍s�Ƃ��ď�������܂��B�Z�����\�����镡���̗v�f��
%                �ʁX�̗�ɏo�͂���܂��B�Ȃ��A��̃Z���A�܂��́A�s�K��
%                �ȕ�����ɂ��ẮANaN �ŕ\������܂��B
%
% �o��:
%   DbleMat    - NROWS �s MAXCOLS ��̃N���X�{���x����BMAXCOLS �́A����
%                ����̍s���\�����鐔���̐��̍ő�l�ł��B���̒l�����Z
%                �������̍s�́A�s��𖞂������߂� NaN �ɂ���ăp�f�B���O
%                ����܂��B��̓��͂͒P��� NaN �o�͂𐶐����܂����A����
%                �F������Ȃ��^�C�v�̓��͂ɂ��ẮANaN �ł͂Ȃ��A���
%                �o�͂𐶐����܂��B
%
% ���:
%     Arg = { 38, 'NULL', 45, NaN, 27, [], 58 }
%     Darg = finargdble(Arg)
%     Darg =
%         38
%        NaN
%         45
%        NaN
%         27
%        NaN
%         58
%
%     Arg = { '14.5', '1e2', '28' }
%     Darg = finargdble(Arg)
%     Darg =
%        14.5000
%       100.0000
%        28.0000
%
%     Arg = { [1 2], [1], [1 2 3] }    
%     Darg = finargdble(Arg)
%     Darg =
%         1    2   NaN
%         1  NaN   NaN
%         1    2     3
% 
% �Q�l : FINARGCAT, STR2DOUBLE, NUM2STR, NUM2CELL, FINARGDATE, FINARGCHAR.


%   Author(s): J. Akao 
%   Copyright 1995-2002 The MathWorks, Inc. 
