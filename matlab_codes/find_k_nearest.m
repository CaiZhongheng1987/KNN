% name   :       find_k_nearest
% author :       CaiZhongheng
% input  :       test_data        the new data
%                leaf_path        the path of first nearest leaf node data
%                kdtree_cur       the curent kd_tree
%                k_array          the k nearest array
%                k_num            the number of k array
%                dist_mode        0:euclidean, 1:cityblock, 2:minkowski, 3:chebychev
% output :       data_cur_max     the max distance of curent k_array
%                return_flag      if return_flag==1, the function will be returned
%                kdtree_cur       the curent kd_tree
%                k_array          the k nearest array
% date           version          record
% 2018.06.10     v1.0             init

function [data_cur_max, return_flag, kdtree_cur, k_array] = find_k_nearest(test_data, leaf_path, kdtree_cur, k_array, k_num, dist_mode)

% return_flag = 0;
k_array_flag = 0; %标记k队列是否塞满。

%% 根据当前的kd tree，寻找最近的叶节点
% 这一步使用leaf_path_search函数，目的在于根据指定的路径和kdtree，找到对应的叶节点和该叶节点的兄弟节点组成的树，以及父树
if(isempty(leaf_path)==1)
    root_data   = kdtree_cur.data;
    father_data = [];
else
    [root_data, father_data, tree_brother, tree_father] = kdtree_split(kdtree_cur, leaf_path);
end

%% 对k_array的长度进行判断
dist_cur = calc_distance(test_data, root_data, dist_mode);
if(size(k_array,1)<k_num)
    %% 队列的长度还没到k的时候，就把当前节点的值和距离直接存入队列中
    % 将该节点和对应的距离存入k_array中
    k_array = [k_array; root_data, dist_cur];
    % 对队列进行重新排序，确保队列按照距离的升序排列，最大距离的数值在队列的最后一行
    if(isempty(k_array)~=1)
        [~,sort_idx]  = sort(k_array(:,end));
        k_array       = k_array(sort_idx,:);
        data_cur_max  = k_array(end,end); % 找到队列中最大的距离
    else
        data_cur_max  = 0;
    end
else
    %% 队列的长度已经塞满，那就将当前节点和队列里的数据进行比较，将当前数据和距离塞进队列
    data_cur_max = k_array(end,end);
    k_array_flag = 1;
    if(data_cur_max>dist_cur)
        idx                       = find(k_array(:,end)>dist_cur);
        if(length(idx)>1)
            k_array(idx(2):end,:) = k_array(idx(1):end-1,:);
        else
        end
        k_array(idx(1),:)         = [root_data, dist_cur];
    else
    end
end

if(isempty(leaf_path)==1)
    return_flag = 1;
    return;
else
end

%% 判断有无兄弟节点
if(isempty(tree_brother)==1)
    % 没有兄弟节点，则直接回退到父节点，递归调用，此时将该根节点从kdtree上掉落，所以递归调用的时候kd_tree使用tree_father
    leaf_path                       = leaf_path(1:length(leaf_path)-1);
    [~, return_flag, ~, k_array]    = find_k_nearest(test_data, leaf_path, tree_father, k_array, k_num, dist_mode);
    if(return_flag==1)
        return;
    else
    end
else
    % 存在兄弟节点，则做判断，切分面为父节点
    dist_in_dim = abs(test_data(father_data.dim) - father_data.data(father_data.dim));
    
    if(dist_in_dim>data_cur_max)&&(k_array_flag==1)
        %% 直接回退到父节点
        leaf_path                       = leaf_path(1:length(leaf_path)-1);
        [~, return_flag, ~, k_array]    = find_k_nearest(test_data, leaf_path, tree_father, k_array, k_num, dist_mode);
        if(return_flag==1)
            return;
        else
        end
    else
        %% 去兄弟节点继续搜索

        % 给兄弟节点重新建立新的leaf_path，方便递归调用。
        [~,brother_leaf_path] = find_leaf_node(test_data, tree_brother);
        % 将父树的leaf_path和兄弟节点的leaf_path嫁接在一起，建立新的leaf_path
        new_leaf_path         = [leaf_path(1:end-1) double(~leaf_path(end)) brother_leaf_path];
        % 建立新的kdtree，包含父树和兄弟节点，但是不包含当前已经比较过的节点。
        father_path           = [];
        for idx=1:length(leaf_path)-1
            if(leaf_path(idx)==0)
                father_path = [father_path '.left'];
            else
                father_path = [father_path '.right'];
            end
        end
        tree_new            = tree_father;
        if(leaf_path(end)==1)
            % 兄弟节点是左子树
            eval(['tree_new' father_path '.left  = tree_brother;']);
        else
            % 兄弟节点是右子树
            eval(['tree_new' father_path '.right = tree_brother;']);
        end
        
        % 对兄弟节点组成的新的kdtree进行递归搜索
        [~, return_flag, ~, k_array] = find_k_nearest(test_data, new_leaf_path, tree_new, k_array, k_num, dist_mode);
        if(return_flag==1)
            return;
        else
        end
    end
end

end

