% FINARGFMT   �����N���X�ɓK�����镶����Ɉ�����ϊ�
%
% M�̈�������Ȃ�W����1��̃R�[���ŕ�����ɕϊ����邱�Ƃ��ł��܂��B
%
%   [AString] = finargfmt(ClassString, A)
%   [AString1, AString2, ..., AStringM] = ....
%               finargfmt(ClassList, A1, A2, ... AM)
%
% ����:
%   ClassList     - ������A�܂��́A�e�t�B�[���h�̃f�[�^�N���X�����X�g
%                   �\�����镶���񂩂�Ȃ� M �s1��̃Z���z��B�����ŁA
%                   �ݒ肳�ꂽ�N���X�ɂ���āADataList �̉�͖@����܂�
%                   �܂��B���͉\�ȕ�����́A'dble', 'date', 'char'�ł��B
%
%   A, A1, ... AM - FINARGPARSE ����͂�������B�f�t�H���g�̃X�g���[�W
%                   �`���ł��B'date' �y�� 'dble' ��2�̃N���X�͔{���x��
%                   ����ŁA����A'char' �̓L�����N�^�z��ƂȂ�܂��B
%
% �o��:
% AString, AString1, ... AStringM - 
%                   �Ή�������͈����̃t�H�[�}�b�g���ꂽ������\���B
%                   �N���X 'date' �́ADATEDISP �ɏ]���ăt�H�[�}�b�g����A
%                   �N���X 'dble' �́ANUM2STR �ɏ]���ăt�H�[�}�b�g����
%                   �܂��B
%
% ���ӁF
% �I�v�V�����̃t�H�[�}�b�g�w��q���ȗ�����ɂ́A���� DATEDISP�A�܂��́A
% NUM2STR ���R�[�����Ă��������B�Ȃ��AFINARGFMT �́A��Ƀf�t�H���g��
% �t�H�[�}�b�g���g�p���܂��B
%
% �Q�l : FINARGPARSE, NUM2STR, DATEDISP.


%   Author(s): J. Akao
%   Copyright 1995-2002 The MathWorks, Inc. 
