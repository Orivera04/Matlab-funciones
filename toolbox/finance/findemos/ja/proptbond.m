% PROPTBOND   �^����ꂽ�����W���̃c���[�̍����g�ݍ��܂ꂽ�I�v�V�����̒l
%
% IBond : (�z�ʉ��i�ɑ΂���)���̍\���� 
% CoupCFlows [NTimes �~ 1] : ���ςł�(�o�ߗ��q)���܂ރ��f���̊e�_�ł�
%                            ���N�[�|���L���b�V���t���[
% AccrCFlows [NTimes �~ 1] : �e�_�ł̍��̌o�ߗ��q
% CallCFlows [NTimes �~ 1] : �e���ԓ_ (-Inf) �ł̌����s�g�̃R�[��
% PutCFlows  [NTimes �~ 1] : �e���ԓ_ (Inf) �ł̌����s�g�̃v�b�g
% DiscTree   [NTimes-1 �~ NTimes-1] : �L���b�V���t���[�Ԃ̊��Ԃł̊���
% FwdProbDefault [NTimes-1 �~ 1] : ���ԓ��̃f�t�H���g�̊m��
%
% �l�ɑ΂��鎞�ԃX�e�b�v i �ł̓��I�v��@�̃v���O���~���O:
% �ۗL�҂��痣��ď��n����鏊�L���ɕK�v�Ȋ���̎��s
%  1) ���� i �ŗ\�z�����l V �ɏ������l���������܂��B
%  2) K �ł̃R�[���̌����s�g��]�����܂��B : V = min( V , K+AI )
%  3) K �ł̃v�b�g�̌����s�g��]�����܂��B : V = max( V , K+AI )
%  4) �N�[�|������ C ���擾���܂��B    : V = V + C
%  5) �f�t�H���g�� forward prob ���|���܂��B
%
% ����́A���[�U�ɂ���Ē��ڃR�[������邱�Ƃ��Ӑ}���Ă��Ȃ��v���C�x�[�g
% �֐��ł��B
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Author: C. Bassignani, 04-18-98 
%         J. Akao        05-12-98
%   Copyright 1995-2002 The MathWorks, Inc. 
