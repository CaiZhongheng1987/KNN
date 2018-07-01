% name   :       kdtree_search
% author :       CaiZhongheng
% input  :       test_data        the new data 
%                kdtree           the kd_tree of trained data
%                k_num            the number of nearest traind data from the test_data 
%                dist_mode        0:euclidean, 1:cityblock, 2:minkowski, 3:chebychev
% output :       k_array          the nearest traind data from the test_data 
% date           version          record
% 2018.06.09     v1.0             init

function k_array = kdtree_search(test_data, kdtree, k_num, dist_mode)

if(nargin<4)
    dist_mode = 0;
end

%% ��ʼ������Ϊk������������
k_array = [];
% k_array = []; %repmat([zeros(1,size(test_data,2)),0],k_num,1); % [train_data, distance]

%% ���ݴ����Ե����ݣ�����Ѱ�ҳ�ʼҶ�ڵ㣬���������н�·����¼����
[~,first_leaf_path] = find_leaf_node(test_data, kdtree);

%% �ӳ�ʼҶ�ڵ㿪ʼ�����������н�·����¼����
[~, ~, ~, k_array]  = find_k_nearest(test_data, first_leaf_path, kdtree, k_array, k_num, dist_mode);

end

