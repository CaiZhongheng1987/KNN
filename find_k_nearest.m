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
k_array_flag = 0; %���k�����Ƿ�������

%% ���ݵ�ǰ��kd tree��Ѱ�������Ҷ�ڵ�
% ��һ��ʹ��leaf_path_search������Ŀ�����ڸ���ָ����·����kdtree���ҵ���Ӧ��Ҷ�ڵ�͸�Ҷ�ڵ���ֵܽڵ���ɵ������Լ�����
if(isempty(leaf_path)==1)
    root_data   = kdtree_cur.data;
    father_data = [];
else
    [root_data, father_data, tree_brother, tree_father] = kdtree_split(kdtree_cur, leaf_path);
end

%% ��k_array�ĳ��Ƚ����ж�
dist_cur = calc_distance(test_data, root_data, dist_mode);
if(size(k_array,1)<k_num)
    %% ���еĳ��Ȼ�û��k��ʱ�򣬾Ͱѵ�ǰ�ڵ��ֵ�;���ֱ�Ӵ��������
    % ���ýڵ�Ͷ�Ӧ�ľ������k_array��
    k_array = [k_array; root_data, dist_cur];
    % �Զ��н�����������ȷ�����а��վ�����������У����������ֵ�ڶ��е����һ��
    if(isempty(k_array)~=1)
        [~,sort_idx]  = sort(k_array(:,end));
        k_array       = k_array(sort_idx,:);
        data_cur_max  = k_array(end,end); % �ҵ����������ľ���
    else
        data_cur_max  = 0;
    end
else
    %% ���еĳ����Ѿ��������Ǿͽ���ǰ�ڵ�Ͷ���������ݽ��бȽϣ�����ǰ���ݺ;�����������
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

%% �ж������ֵܽڵ�
if(isempty(tree_brother)==1)
    % û���ֵܽڵ㣬��ֱ�ӻ��˵����ڵ㣬�ݹ���ã���ʱ���ø��ڵ��kdtree�ϵ��䣬���Եݹ���õ�ʱ��kd_treeʹ��tree_father
    leaf_path                       = leaf_path(1:length(leaf_path)-1);
    [~, return_flag, ~, k_array]    = find_k_nearest(test_data, leaf_path, tree_father, k_array, k_num, dist_mode);
    if(return_flag==1)
        return;
    else
    end
else
    % �����ֵܽڵ㣬�����жϣ��з���Ϊ���ڵ�
    dist_in_dim = abs(test_data(father_data.dim) - father_data.data(father_data.dim));
    
    if(dist_in_dim>data_cur_max)&&(k_array_flag==1)
        %% ֱ�ӻ��˵����ڵ�
        leaf_path                       = leaf_path(1:length(leaf_path)-1);
        [~, return_flag, ~, k_array]    = find_k_nearest(test_data, leaf_path, tree_father, k_array, k_num, dist_mode);
        if(return_flag==1)
            return;
        else
        end
    else
        %% ȥ�ֵܽڵ��������

        % ���ֵܽڵ����½����µ�leaf_path������ݹ���á�
        [~,brother_leaf_path] = find_leaf_node(test_data, tree_brother);
        % ��������leaf_path���ֵܽڵ��leaf_path�޽���һ�𣬽����µ�leaf_path
        new_leaf_path         = [leaf_path(1:end-1) double(~leaf_path(end)) brother_leaf_path];
        % �����µ�kdtree�������������ֵܽڵ㣬���ǲ�������ǰ�Ѿ��ȽϹ��Ľڵ㡣
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
            % �ֵܽڵ���������
            eval(['tree_new' father_path '.left  = tree_brother;']);
        else
            % �ֵܽڵ���������
            eval(['tree_new' father_path '.right = tree_brother;']);
        end
        
        % ���ֵܽڵ���ɵ��µ�kdtree���еݹ�����
        [~, return_flag, ~, k_array] = find_k_nearest(test_data, new_leaf_path, tree_new, k_array, k_num, dist_mode);
        if(return_flag==1)
            return;
        else
        end
    end
end

end

