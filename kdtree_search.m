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

%% 初始化个数为k的最近距离队列
k_array = [];
% k_array = []; %repmat([zeros(1,size(test_data,2)),0],k_num,1); % [train_data, distance]

%% 根据待测试的数据，首先寻找初始叶节点，搜索过程中将路径记录下来
[~,first_leaf_path] = find_leaf_node(test_data, kdtree);

%% 从初始叶节点开始，搜索过程中将路径记录下来
[~, ~, ~, k_array]  = find_k_nearest(test_data, first_leaf_path, kdtree, k_array, k_num, dist_mode);

end

