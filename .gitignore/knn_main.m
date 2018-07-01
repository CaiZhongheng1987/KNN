% name   :  kd tree demo main script
% author :  CaiZhongheng
% 
% date           version          record
% 2018.06.09     v1.0             init

clc;
clear;
close all;
rng(38);
%% setting
k_num         = 30;
%% create the data
uni_scale     = 100;
data_len      = 90;
train_data_x1 = unifrnd(-uni_scale,uni_scale,[data_len,1]);
train_data_x2 = unifrnd(-uni_scale,uni_scale,[data_len,1]);

if(k_num>data_len)
   error('Please check the k_num and data_len!!!'); 
else
end

figure(1);
plot(complex(train_data_x1,train_data_x2),'*');
xlim([-uni_scale uni_scale]);
ylim([-uni_scale uni_scale]);
axis square;
title('data');
hold on;

% test_data_x1 = [2;5;9;4;8;7];
% test_data_x2 = [3;4;6;7;1;2];
input_data   = [train_data_x1,train_data_x2];

%% creat kd-tree
data_kdtree  = kdtree_create(input_data);

%% use knn to search the kd-tree
test_data_x1 = unifrnd(-uni_scale,uni_scale,[1,1]);
test_data_x2 = unifrnd(-uni_scale,uni_scale,[1,1]);
test_data    = [test_data_x1,test_data_x2];
plot(complex(test_data_x1,test_data_x2),'*r');

k_array      = kdtree_search(test_data, data_kdtree, k_num);

%% plot figure
plot(complex(k_array(:,1),k_array(:,2)),'square');
viscircles([test_data_x1,test_data_x2], k_array(end,end));
hold off;

