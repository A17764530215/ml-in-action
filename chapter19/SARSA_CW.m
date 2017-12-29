
% ���script��չʾ�������SARSA�㷨���������������
% Note���Ȿ������д��һ���ű��ļ�������Ϊ����һ�������ж������е��Ӻ�����д�ɺ�������ʽ
% ��matlab�ű��ļ����޷������Ӻ�����
% ��ʼ��������ͨ�ò���
close all
clear
alpha = 1e-1  %ѧϰ����
row = 4; col = 12   %�����С
CF = ones(row, col); CF(row, 2:(col-1)) = 0 %������Ϊ0�ĵط���ʾ����
s_start = [4, 1]; %��ʼ״̬
s_end = [4, 12];    %Ŀ��
max_epoch = 500;  %���ѧϰ�����֣�һ��episode��һ��

% SARSA�еĲ���
gamma = 1;  %�ۿ�ϵ��
epsilon = .1;   %epsilon-greedy���Եĸ�����ֵ
nStates = row*col;  %���е�״̬��
nActions = 4;   %ÿ��״̬����Ϊ

Q = zeros(nStates, nActions);   %��Ϊֵ��������SARSA�ĸ���Ŀ��
ret_epi = zeros(1, max_epoch);  %�洢ÿһ��episode���ۻ��ر�R
n_sarsa = zeros(nStates, nActions); %�洢ÿ����s,a�����ʵĴ���
steps_epi = zeros(1, max_epoch);    %�洢ÿ��episode�о����Ĳ�����ԽС˵��ѧϰԽ��

% ����ÿһ��ѭ��
for ei = 1:max_epoch
    sarsa_finish = 0; %��־sarsa�Ƿ����
    st = s_start;

    % ��ʼ��״̬����ʼ�㷨��step2
    % sub2ind������һ����ά������ת����һ��һά������ֵ������ÿ���������걻ӳ���һ��Ψһ������ֵ
    st_index = sub2ind([row, col], s_start(1), s_start(2));

    % ѡ��һ����Ϊ����Ӧ�㷨step2����
    [value, action] = max(Q(st_index, :))   %����ֱ���1,2,3,4������������4����Ϊ

    % ��epsilon�ĸ���ѡ��һ���������
    if( rand<epsilon )       
        tmp=randperm(nActions); action=tmp(1); %����һ���������
    end
    
    % ��ʼһ��episode����Ӧ�㷨step3
    R = 0;
    while(1)
        %���ݵ�ǰ״̬����Ϊ��������һ��(s',a')�ͻر��� �㷨s3-1
        [reward, next_state]  = transition(st, action, CF, s_start,s_end);
        R = R + reward;
        next_ind = sub2ind( [row, col], next_state(1), next_state(2));
        % �����һ��״̬������ֹ̬����ִ��
        if (~sarsa_finish)
            steps_epi(1, ei) = steps_epi(1, ei) +1;
            % ѡ����һ��״̬����Ϊ���㷨s3-2
            [value, next_action] = max(Q(next_ind, :));
            if( rand<epsilon )         
                tmp=randperm(nActions); next_action=tmp(1); 
            end
            n_sarsa(st_index,action) = n_sarsa(st_index,action)+1; %״̬�ĳ��ִ���
            if( ~( (next_state(1)==s_end(1)) && (next_state(2)==s_end(2)) ) ) % ��һ��״̬������ֹ̬
                Q(st_index,action) = Q(st_index,action) + alpha*( reward + gamma*Q(next_ind,next_action) - Q(st_index,action) ); %ֵ��������
            else                                                  % stp1 IS the terminal state ... no Q_sarsa(s';a') term in the sarsa update
                Q(st_index,action) = Q(st_index,action) + alpha*( reward - Q(st_index,action) );
                sarsa_finish=1;
            end
            % ����״̬����Ӧ�㷨s3-4
            st = next_state; action = next_action; st_index = next_ind;
        end
        if (sarsa_finish)
            break;
        end
    end     %����һ��episode��ѭ��
    
    ret_epi(1,ei) = R;
          
end

% ��ò���
sideII=4; sideJJ=12;
% ��ʼ��pol_pi_sarsa��ʾ���ԣ�V_sarsa��ֵ������n_g_sarsa �ǵ�ǰ״̬��ȡ���Ų��ԵĴ���
pol_pi_sarsa  = zeros(sideII,sideJJ); V_sarsa  = zeros(sideII,sideJJ); n_g_sarsa  = zeros(sideII,sideJJ); 
for ii=1:sideII,
  for jj=1:sideJJ,
    sti = sub2ind( [sideII,sideJJ], ii, jj ); 
    [V_sarsa(ii,jj),pol_pi_sarsa(ii,jj)] = max( Q(sti,:) ); 
    n_g_sarsa(ii,jj) = n_sarsa(sti,pol_pi_sarsa(ii,jj));
  end
end

% ��ͼ
plot_cw_policy(pol_pi_sarsa,CF,s_start,s_end);
title( 'SARSA�㷨����' ); 
% fn = sprintf('cw_sarsa_policy_nE_%d',MAX_N_EPISODES); if( save_figs ) saveas( gcf, fn, 'png' ); end 

figure('Position', [100 100 400 200]); 
imagesc( V_sarsa ); colormap(flipud(jet)); colorbar; 
title( 'SARSA״̬��Ϊֵ' ); 
set(gca, 'Ytick', [1 2 3 4 ], 'Xtick', [1:12], 'FontSize', 9);
% fn = sprintf('cw_sarsa_state_value_fn_nE_%d',MAX_N_EPISODES); if( save_figs ) saveas( gcf, fn, 'png' ); end

figure('Position', [100 100 400 200]); 
imagesc( n_g_sarsa ); colorbar; 
title( 'SARSA:���Ų��ԵĲ���' ); 
set(gca, 'Ytick', [1 2 3 4 ], 'Xtick', [1:12], 'FontSize', 9);

% Plot the reward per epsiode as in the book: 
rpe_sarsa = cumsum(ret_epi)./cumsum(1:length(ret_epi));
ph=figure; ph_sarsa = plot( rpe_sarsa, '-x' ); axis([0, 1000, -5 0]); grid on; hold on; 

figure('Position', [100 100 600 250]); 
subplot(121)
plot(1:max_epoch, ret_epi, 'b', 'LineWidth', 1);
title('ÿ��episode���ۻ��ر�(SARSA)');
xlabel('episode');
ylabel('�ر�ֵ');
set(gca, 'FontSize', 9);
axis( [-50 600 -2500 100]);
subplot(122)
plot(1:max_epoch, steps_epi, '-b', 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 2);
title('ƽ��ÿ��episode�õĲ���(SARSA)');
xlabel('episode');
ylabel('����');
set(gca, 'FontSize', 9);
axis( [-50 600 -100 1000]);