% LHSNORM   ���K���z�������e�������i(latin hypercube)�W�{���쐬
%
% X=LHSNORM(MU,SIGMA,N) �́A���σx�N�g��M �� �����U�s�� SIGMA ������
% ���ϗʐ��K���z����A�T�C�Y N �̃��e�������i(latin hypercube)�W�{X��
% �쐬���܂��BX �́A���ϗʐ��K���z����̃����_���W�{�ɗގ����Ă��܂����A
% �e��̎��ӕ��z�́A���̕W�{�̎��ӕ��z���A���_�I�Ȑ��K���z�ɋ߂��Ȃ�
% �悤�ɒ��߂���܂��B
%
% X=LHSNORM(MU,SIGMA,N,'ONOFF') �́A�W�{�̕������ʂ��R���g���[�����܂��B
% 'ONOFF' ��'off'�̏ꍇ�A�e��́A�m�����x�[�X�ɂ����X�P�[�����O�ɂ���
% ���Ԋu�ɔz�u�����_����\������Ă��܂��B����������ƁA�e��́A�l G(.5/N), 
% G(1.5/N), ..., G(1-.5/N)�̏���ł��B�����ŁAG �́A��̎��ӕ��z�ɑ΂���
% ���K�t�ݐϕ��z�ł��B'ONOFF'��'on' (�f�t�H���g)�̏ꍇ�A�e��́A�m����
% �x�[�X�ɂ����X�P�[�����O�ɂ��Ĉ�l�ɕ��z�����_����\������Ă��܂��B
% ���Ƃ��΁A0.5/N �̑���ɁA��� (0/N,1/N)��ɁA��l�ȕ��z�����l��
% �g�p���܂��B
%
% �Q�l : LHSDESIGN, MVNRND.


%   Copyright 1993-2003 The MathWorks, Inc. 
%   $Revision: 1.2 $  $Date: 2003/02/12 17:12:57 $