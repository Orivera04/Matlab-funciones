% CHECKRNG   ����y�щ����ɂ��ē��͈������e�X�g
%
% ECODE = CHECKRNG(ARG_NAMES,ACTUAL,LOW,UP,LOWNAME,UPNAME,LEQ,UEQ,FUN) 
% �́A�^����ꂽ�������w�肳�ꂽ���E�����ɓK�����Ă��邩�ǂ��������؂�
% �܂��B���̊֐��́A���͈����̃����W�`�F�b�N�����s���邽�߂ɁAFinancial 
% Toolbox �̊֐�����Ăяo����܂��BARG_NAMES �́A�֐��̓��͈����̖��̂�
% ����������s��ł��BACTUAL �́A�^����ꂽ���͈����̎��ۂ̒l�ł��B
% LOW �͉����l�AUP �͏���l�ALOWNAME �͂��Ⴂ���E�l�����ϐ��̖��́A
% �܂��́A������̍s��AUPNAME �͂�荂�����E�l�����ϐ��̖��́A�܂���
% ������̍s��ł��BLEQ �� 'e' �ɐݒ肷��ƁA���͈����̒l�� LOW ������
% �����l�A�܂��́A�������l�ɐ�������܂��BUEQ �� 'e' �ɐݒ肷��ƁA����
% ������ UP �����������l�A�܂��́AUP �Ɠ������l�ɐ�������܂��B LEQ = 
% 'l' �y�� UEQ = 'l' �́A���͈����� LOW �����傫���l�y�� UP ��������
% ���l�ɐ������܂��BFUN �́ACHECKRNG ���Ăяo���֐��̖��̂ł��B���E����
% ����������Ȃ��ꍇ�ɂ́AECODE =1���o�͂���܂��B
%
% ���F
% checkrng('rate',0.1,0,inf,'0','inf','e','l',mfilename) �́Arate �Ƃ���
% ���̂̓��͈�����0�Ɩ�����̊Ԃɂ��邩�ǂ������`�F�b�N���܂��B���͈̔�
% �O�̒l�̏ꍇ�A�G���[���b�Z�[�W���o�͂���܂��B


%       Author(s): C.F. Garvin, 7-18-95
%       Copyright 1995-2002 The MathWorks, Inc. 
