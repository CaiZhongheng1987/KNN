% name   :       kdtree create
% author :       CaiZhongheng
% input  :       input_data       MxN data, the M is the length of data, the N is the dimesions of data
% output :       root             the struct of kd tree  
% date           version          record
% 2018.06.09     v1.0             init

function root = kdtree_create(input_data)
%% 找出方差最大的维度
data_var                = mean(input_data.^2,1) - mean(input_data,1).*mean(input_data,1);%求每个维度的方差
[~,dim_idx]             = max(data_var);

%% 根据dim_dix所处的维度，对数据进行排序，并一分为二
tmp_data                = input_data(:,dim_idx);
[tmp_data,resort_idx]   = sort(tmp_data);
resort_data             = input_data(resort_idx,:);
data_len                = length(tmp_data);
root.dim                = dim_idx;% 将当前比较的维度编号存储下来
%% 将当前父节点赋值到root.data里面,并分为左子树和右子树，递归调用
if(data_len==1)
    root.data        = resort_data(1,:);
elseif(data_len==2)
    root.left.data   = resort_data(1,:);
    root.left.dim    = 1;
    root.data        = resort_data(2,:);
else
    mid_idx          = ceil(data_len/2);% 取中位数
    root.data        = resort_data(mid_idx,:);
    root.left        = kdtree_create(resort_data(1:mid_idx-1,:));%递归调用，生成左子树
    root.right       = kdtree_create(resort_data(mid_idx+1:end,:));%递归调用，生成右子树
end
end

