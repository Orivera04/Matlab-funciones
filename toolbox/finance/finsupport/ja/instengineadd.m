% INSTENGINEADD   ��`���ꂽ���i�̍쐬�֐��ɑΉ�����T�u���[�`��
%
% INSTADDCF, INSTADDBOND, INSTCAP ���̏��i�쐬�֐��ɑΉ�����{�C���v���[�g
% �R�[�h�ł��B�N���X�y�уT�C�Y�����ɂ���Ĉ��������߂��A���i�ϐ��쐬��
% ���߂ɂ��̌��ʂ� INSTENGINESET �Ɏ󂯓n���܂��B
%
%   ISet = instengineadd(TypeString, FieldInfo, varargin{:})
%
%   [FieldList, ClassList, TypeString, SizeList, DefDataList] = ...
%          instengineadd(TypeString, FieldInfo)
%
% ����:
%    TypeString  - �ǉ�����鏤�i�̃^�C�v���w�肷�镶����
%
%    FieldInfo   - ���̗񂩂�Ȃ� NFIELDS �s 4 ��̃Z���z�� :
%                   FieldList, ClassList, SizeList, DefDataList.
%
%    varargin{:} - �t�B�[���h�ɑΉ�������̓f�[�^�����ł��B�f�[�^������
%                  ���瑶�݂��Ȃ��ꍇ�A�t�B�[���h���̏o�͂̂��߂ɁA
%                  2�Ԗڂ̎g�p�@���p�����܂��B
%
% �o��: 
% �o�͂́A1 �s1��A�܂��́A5 �s 1��̃Z���z��Ƀ��b�s���O����܂��B
%    ISet        - ���i�̏W������Ȃ�ϐ��B���i�́A�^�C�v���ɕ��ނ���A
%                  ���̂��ꂼ��̃^�C�v�ɂ��Č݂��ɈقȂ�f�[�^�t�B�[
%                  ���h��ݒ肷�邱�Ƃ��ł��܂��B�L�����ꂽ�f�[�^�t�B�[
%                  ���h�́A���i�̂��ꂼ��ɑΉ�����s�x�N�g���A�܂��́A
%                  ������ƂȂ��Ă��܂��B�ϐ� ISet �Ɋւ���ڍׂɂ���
%                  �́A"help instget" �ƃ^�C�v���Ă��������B
% 
%   FieldList    - �e�f�[�^�t�B�[���h�̖��̂����X�g�\�����镶����ō\��
%                  ����� NFIELDS �s1��̃Z���z��B
% 
%   ClassList    - �e�t�B�[���h�̃f�[�^�N���X���L�ڂ��镶���񂩂�Ȃ� 
%                  NFIELDS �s1��̃Z���z��A�����ɋL�ڂ����f�[�^�N���X
%                  �ɂ���āA�����̉��ߖ@�����肳��܂��B���͉\�Ȉ���
%                  �́A'dble', 'date', 'char'�ł��B 
% 
%    SizeList    - �T�C�Y�����������z�񂩂�Ȃ� NFIELDS �s1 ��̃Z���z��B
%                  �e�T�C�Y�����z��́A���ꂼ��̎����ŋ��e���������T
%                  �C�Y�̍ő�l������1�s 2 ��̔z��ƂȂ��Ă��܂��B�ڍ�
%                  �ɂ��ẮA"help finargflip" �ƃ^�C�v���Ă��������B
% 
%    DefDataList - �f�[�^���͒l�̃f�t�H���g�l������ NFIELDS �s1��̃Z��
%                  �z��ł��B���̏��͌��݂ł͖��g�p�ƂȂ��Ă��܂��B
% 
% ���ӁF
% ���̊֐��́A�����̃����[�X�ɂ����ăT�u���[�`���y�уT�u�W�F�N�g�C���^
% �t�F�[�X��ύX���邱�ƂɂȂ��Ă��܂��BINSTENGINEADD �́A���[�U�֐���
% ���Ď��s����邱�Ƃ��Ӑ}���Đ݌v����Ă��܂���B
%
% �Q�l : INSTGETFIELD, INSTADDCF, INSTADDCAP, INSTADDBOND.


%   Author(s): J. Akao 19-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
