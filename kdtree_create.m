% name   :       kdtree create
% author :       CaiZhongheng
% input  :       input_data       MxN data, the M is the length of data, the N is the dimesions of data
% output :       root             the struct of kd tree  
% date           version          record
% 2018.06.09     v1.0             init

function root = kdtree_create(input_data)
%% �ҳ���������ά��
data_var                = mean(input_data.^2,1) - mean(input_data,1).*mean(input_data,1);%��ÿ��ά�ȵķ���
[~,dim_idx]             = max(data_var);

%% ����dim_dix������ά�ȣ������ݽ������򣬲�һ��Ϊ��
tmp_data                = input_data(:,dim_idx);
[tmp_data,resort_idx]   = sort(tmp_data);
resort_data             = input_data(resort_idx,:);
data_len                = length(tmp_data);
root.dim                = dim_idx;% ����ǰ�Ƚϵ�ά�ȱ�Ŵ洢����
%% ����ǰ���ڵ㸳ֵ��root.data����,����Ϊ�����������������ݹ����
if(data_len==1)
    root.data        = resort_data(1,:);
elseif(data_len==2)
    root.left.data   = resort_data(1,:);
    root.left.dim    = 1;
    root.data        = resort_data(2,:);
else
    mid_idx          = ceil(data_len/2);% ȡ��λ��
    root.data        = resort_data(mid_idx,:);
    root.left        = kdtree_create(resort_data(1:mid_idx-1,:));%�ݹ���ã�����������
    root.right       = kdtree_create(resort_data(mid_idx+1:end,:));%�ݹ���ã�����������
end
end

