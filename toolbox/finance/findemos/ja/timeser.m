% TIMESER   ���n��v���b�g�� XData �𐳊m�ȓ��t�l�ɕϊ�
%
% T = TIMESER(START,PERIODS,HLDAYS)�́A���n��v���b�g�� XData ��K�؂�
% ���t�l�ɕϊ����܂��B����ɂ��ADATEAXIS �R�}���h��p���āA���ڐ���
% ���x����ϊ������������̓��t�����񃉃x���ɕϊ����s�����Ƃ��\�ƂȂ�
% �܂��BSTART �́A���n��̊J�n���ł��BPERIODS �́A�f�[�^�̓x�����w�肵
% �܂��B
%
%              �f�[�^�x��               Periods�̐ݒ�l
%
%                 ���P��                       1(�f�t�H���g)
%                 �T�P��                       2
%                 ���P��                       3
%                 �l�����P��                   4
%                 ���N�P��                     5
%                 �N�P��                       6
%
% �y�j���Ɠ��j���́AXData �x�N�g������w�肳�ꂽ HLDAYS ���l�Ɏ�菜����
% �܂��BHLDAYS �́A���n��f�[�^�Ɗ֘A�t����ꂽ�f�[�^���珜�������y�j
% ���A���j���ȊO�̑��̋x�Ɠ��������܂��BHLDAYS �́A���̕��@�Őݒ�ł�
% �܂��B�܂��A1�́A���̊֐���ҏW���A�K�؂ȓ��t��ǉ�������@�A����1��
% �́AHLDAYS �Ɩ��t����ꂽ�O���[�o���ϐ��ɓ��t���`������@�A�Ō��
% ��O�̈����Ƃ��Ēl����͂�����@�ł��B
%
% TIMESER �́A�����̓��t���J�n���Ƃ��āAXData ����t�x�N�g���ɕϊ����܂��B
% �f�t�H���g�ł́AHLDAYS �́A�֐� TIMESER �̓����Œ�`����邩�A�܂��́A
% ���[�U�ɂ���ăO���[�o���ϐ��Ƃ��Ē�`����܂��B
%
% TIMESER(START) �́AXData �� START �Ŏw�肳�ꂽ���t���J�n���Ƃ��āAXData
% ����t�x�N�g���ɕϊ����܂��B�f�t�H���g�ł́A�f�[�^�͓��P�ʂ̃f�[�^
% (PERIODS = 1)�Ƃ��ď�������AHLDAYS �́A�֐� TIMESER �̓����Œ�`�����
% ���A�܂��́A���[�U�ɂ���āA�O���[�o���ϐ��Ƃ��Ē�`����܂��B
%
% TIMESER(START,PERIODS) �́ASTART �Ŏw�肳�ꂽ���t���J�n���APERIODS ��
% �w�肳�ꂽ�l���f�[�^�̓x���Ƃ��āAXData ����t�x�N�g���ɕϊ����܂��B
% �f�t�H���g�ł́AHLDAYS �́A�֐� TIMESER �̓����Œ�`����邩�A�܂��́A
% ���[�U�ɂ���ăO���[�o���ϐ��Ƃ��Ē�`����܂��B
%
% TIMESER(START,PERIODS,HLDAYS) �́ASTART �Ŏw�肳�ꂽ���t���J�n���A
% PERIODS �Ŏw�肳�ꂽ�l���f�[�^�̓x���Ƃ��āA�x�Ɠ����Ƃ��� HLDAYS ��
% �g�p���āAXData ����t�x�N�g���ɕϊ����܂��B
%
% TRADDAYS = TIMESER(...) �́A���n��v���b�g�� XData ��ύX�����ɁA���t
% �x�N�g�������AMATLAB ���[�N�X�y�[�X�ɏo�͂��܂��B
%
% �Q�l : DATEAXIS.


%       Author(s): C.F. Garvin, 7-17-95
%       Copyright (c) 1995-1999 The MathWorks, Inc. All Rights Reserved.
