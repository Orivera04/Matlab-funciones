% FINARGDATE   �������V���A�����t�`���̍s��Ƀt�H�[�}�b�g
%
% �݂��ɒ������قȂ�s�� NaN �Ńp�f�B���O���A�V���A�����t�`���� NROWS �s
% MAXCOLS ��̍s��𐶐����܂��B���t���͂ɂ́A�V���A�����t�`���A�܂��́A
% �L�����N�^�œ��͂ł��܂��B�o�͂����s�́A���͂��ꂽ�s��̍s�A�܂��́A
% ���̓Z���z��̗v�f���琶������܂��B
%   
%   [DateNums] = finargdate(DateNumArg)
%   [DateNums] = finargdate(DateStrArg)
%   [DateNums] = finargdate(CellArg)
%
% ����:
%   DateNumArg - �V���A�����t�ԍ�����Ȃ� NROWS �s MAXCOLS ��̍s��
%
%   DateStrArg - ���t������� NROWS �s NCHAR ��̃L�����N�^�ł��B�g�p
%                �\�ȓ��t�����̏ڍׂɂ��ẮA"help datestr" �ƃ^�C�v
%                ���Ă��������B���Ԃ��܂ޏ����ɂ��Ă̓T�|�[�g�̑Ώۂ�
%                �Ȃ��Ă���܂���B��̍s�ɂ́A�ʁX�̗�ɐݒ肳���
%                �\���̂��邢�����̓��t���܂ނ��Ƃ��ł��܂��B���t��
%                ���ĔF������Ȃ�������́ANaN �ɒu���������܂��B
%
%   CellArg    - �V���A�����t�A�܂��́A�L�����N�^�s�񂩂�Ȃ�NROWS�s1��
%                �̃Z���z��ł��B���̃Z���z��́A�P��̍s�Ƃ��ď�������
%                �܂��B1�̃Z�����ɕ����̗v�f������ꍇ�A�����͕ʁX
%                �̗�ɔz�u����܂��B�󔒂̃Z����A���t�Ƃ��ĔF�߂���
%                ��������͑S�� NaN �Œu���������܂��B
%
% �o��:
%   DateNums   - �V���A�����t�ԍ��� NROWS �s MAXCOLS ��̍s��ł��B
%                MAXCOLS �́A�e�s�Ō��o���ꂽ���t�̍ő吔�������Ă��܂��B
%                ���Z���s�́A�s��𖄂߂邽�߂� NaN �Ńp�f�B���O����
%                �܂��B��̓��͂́A�P��� NaN �o�͂𐶐����A���t�ƔF��
%                ���Ȃ��^�C�v�̓��͂͋�̏o�͂𐶐����܂��B�������
%                ���ďo�͂�\������ɂ́A"datedisp(DateNums)" �ƃ^�C�v
%                ���Ă��������B
%
% ���:
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
% �Q�l : DATENUM, DATESTR, DATEDISP, FINARGCHAR, FINARGDBLE.


%   Author(s): J. Akao 
%   Copyright 1995-2002 The MathWorks, Inc. 
