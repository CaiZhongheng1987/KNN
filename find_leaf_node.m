% name   :       find_leaf_node
% author :       CaiZhongheng
% input  :       test_data        the new data 
%                kdtree           the kd-tree of trained data
% output :       leaf_data        the first nearest leaf node data from test data  
%                leaf_path        the path of first nearest leaf node data
% date           version          record
% 2018.06.10     v1.0             init

function [leaf_data, leaf_path] = find_leaf_node(test_data, kdtree)

left_flag  = isfield(kdtree,'left');
right_flag = isfield(kdtree,'right');

if(left_flag==0)&&(right_flag==0)
    % 已经是叶节点，直接返回
    leaf_data        = kdtree;
    leaf_path_parent = [];
    leaf_path_child  = [];
%     kdtree_brother   = kdtree_brother;
elseif(left_flag==1)&&(right_flag==0)
    % 只有左子树，那就直接去左子树
    leaf_path_parent               = 0; % 0: left; 1: right 
    [leaf_data, leaf_path_child] = find_leaf_node(test_data, kdtree.left);
elseif(left_flag==0)&&(right_flag==1)
    % 只有右子树，那就直接去右子树
    leaf_path_parent             = 1; % 0: left; 1: right 
    [leaf_data, leaf_path_child] = find_leaf_node(test_data, kdtree.right);
else
    % 左右子树都有，那就做比较，去最接近的一方
    if(test_data(kdtree.dim)<=kdtree.data(kdtree.dim))
        leaf_path_parent               = 0; % 0: left; 1: right 
        [leaf_data, leaf_path_child] = find_leaf_node(test_data, kdtree.left);
    else
        leaf_path_parent               = 1; % 0: left; 1: right
        [leaf_data, leaf_path_child] = find_leaf_node(test_data, kdtree.right);
    end
end
leaf_path = [leaf_path_parent leaf_path_child];

end

