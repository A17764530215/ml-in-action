
function [reward, next_state] = transition(st, act, CF, s_start, s_end)
% �������ڼ��㵱ǰת�Ƶ���һ��״̬�����أ�s',a')��r
[row, col] = size(CF);
ii = st(1); jj = st(2);

switch act
    case 1,
        %
        % action = UP
        %
        next_state = [ii-1,jj];
    case 2,
        %
        % action = DOWN
        %
        next_state = [ii+1,jj];
    case 3,
        %
        % action = RIGHT
        %
        next_state = [ii,jj+1];
    case 4
        %
        % action = LEFT
        %
        next_state = [ii,jj-1];
    otherwise
        error(sprintf('δ�������Ϊ = %d',act));
end

% �߽紦��
if( next_state(1)<1      ) next_state(1)=1;      end
if( next_state(1)>row ) next_state(1)=row; end
if( next_state(2)<1      ) next_state(2)=1;      end
if( next_state(2)>col ) next_state(2)=col; end

% �ر�����

if( (ii==s_end(1)) && (jj==s_end(2)) )  % ����
  reward = 0;
elseif( CF(next_state(1),next_state(2))==0 )        % ����������
  reward  = -100;
  next_state = s_start;
else                                   
  reward = -1;
end
end
