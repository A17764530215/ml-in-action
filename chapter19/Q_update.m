% Q���µĲ���ʵ��
for ei = 1:max_episodes
    q_finish = 0;
    % ���ó�ʼ״̬���Լ���ʼ״̬��Ӧ��һά������
    st = s_start; sti_qlearn = sub2ind( [sideII,sideJJ], st(1), st(2) ); 
    % ���ݳ�ʼ״̬������һ����Ϊ
    [value,action] = max(Q_qlearn(sti_qlearn,:));  
    if( rand<epsilon )         % explore ... with a random action
        tmp=randperm(nActions); action=tmp(1);
    end
    
    % ��ʼһ��episode
    R = 0;
    while(1)
        %���ݵ�ǰ״̬����Ϊ��������һ��(s',a')�ͻر��� �㷨s3-1
        [reward, next_state]  = transition(st, action, CF, s_start,s_end);
        R = R + reward;
        nextindex = sub2ind( [sideII,sideJJ], next_state(1), next_state(2) );
        
        if ~q_finish
            steps_epi(1, ei) = steps_epi(1, ei) +1;
            [value, next_action] = max(Q(nextindex, :));
            if( rand<epsilon )         
                tmp=randperm(nActions); next_action=tmp(1); 
            end
            if( ~( (next_state(1)==s_end(1)) && (next_state(2)==s_end(2)) ) ) % ��һ��״̬������ֹ̬
                Q(st,action) = Q(st,action) + alpha*( reward + gamma*max(Q(nextindex,:)) - Q(st,action) ); %ֵ��������,�㷨s3-3
            else
                Q(st,action) = Q(st,action) + alpha*( reward - Q(st,action) );
                q_finish=1;
            end
            % ����״̬����Ӧ�㷨s3-4
            st = next_state; action = next_action; st_index = nextindex;
        end
        if (sarsa_finish)
            break;
        end
    end     %����һ��episode��ѭ��
    ret_epi(ei) = R; 
end        