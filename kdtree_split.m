% name   :       kdtree_split
% author :       CaiZhongheng
% input  :       test_data        the new data
%                kdtree           the kd_tree of trained data
% output :       root_data        the first nearest leaf node data from test data
%                father_data      the father data of the root_data
%                tree_brother     the brother data and its sub_tree
%                tree_father      the tree derived the root_data and tree_brother from the total kd_tree 
% date           version          record
% 2018.06.10     v1.0             init

function [root_data, father_data, tree_brother, tree_father] = kdtree_split(kdtree, leaf_path)

%% ��Ҫ��kdtree���Ϊ�������֣���һ������leaf pathѡ�����ĸ��ڵ㣬�ڶ������Ǹ��ڵ���ֵܽڵ��Լ��ֵܽڵ��������������������������kdtree��ȥ��һ�͵ڶ���������Ĳ���,father tree
tmp_kdtree   = kdtree;
tree_father  = kdtree;
father_path  = [];
tree_brother = [];
%% find tree brother and tree self
if(length(leaf_path)==1)
    if(leaf_path==0)
        tmp_kdtree  = tmp_kdtree.left;
    else
        tmp_kdtree  = tmp_kdtree.right;
    end
    
    if(leaf_path==0)
        % path�����ѡ������������ô�ֵܽڵ�������ұߡ�
        if(isfield(kdtree,'right'))
            tree_brother = kdtree.right;
        else
            tree_brother = [];
        end
    else
        % path�����ѡ������������ô�ֵܽڵ��������ߡ�
        if(isfield(kdtree,'left'))
            tree_brother = kdtree.left;
        else
            tree_brother = [];
        end
    end
else
    for idx=1:length(leaf_path)
        if(leaf_path(idx)==0)
            tmp_kdtree  = tmp_kdtree.left;
            if(idx<=length(leaf_path)-1)
                father_path = [father_path '.left'];
            else
            end
        else
            tmp_kdtree = tmp_kdtree.right;
            if(idx<=length(leaf_path)-1)
                father_path = [father_path '.right'];
            else
            end
        end
        
        if(idx==length(leaf_path)-1)
            if(leaf_path(end)==0)
                % path�����ѡ������������ô�ֵܽڵ�������ұߡ�
                if(isfield(tmp_kdtree,'right'))
                    tree_brother = tmp_kdtree.right;
                else
                    tree_brother = [];
                end
            else
                % path�����ѡ������������ô�ֵܽڵ��������ߡ�
                if(isfield(tmp_kdtree,'left'))
                    tree_brother = tmp_kdtree.left;
                else
                    tree_brother = [];
                end
            end
        else
        end
    end
end
% get the root data
root_data = tmp_kdtree.data;
% get the father tree
kdtree_father = eval(['kdtree' father_path]);

if((isfield(kdtree_father,'left')==1)&&(isfield(kdtree_father,'right')==0))
    eval(['tree_father' father_path '= rmfield(kdtree' father_path ',''left'');']);
elseif((isfield(kdtree_father,'left')==0)&&(isfield(kdtree_father,'right')==1))
    eval(['tree_father' father_path '= rmfield(kdtree' father_path ',''right'');']);
elseif((isfield(kdtree_father,'left')==1)&&(isfield(kdtree_father,'right')==1))
    eval(['tree_father' father_path '= rmfield(kdtree' father_path ',{''left'',''right''});']);
else
end

father_data.dim  = eval(['tree_father' father_path '.dim']);
father_data.data = eval(['tree_father' father_path '.data']);
end
% end

% end
