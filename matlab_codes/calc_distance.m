function dist_cur = calc_distance(test_data, first_leaf_data, dist_mode)

switch dist_mode
    case 0 % 0:euclidean
        dist_cur = sqrt(sum((test_data-first_leaf_data).^2));
    otherwise
        % 1:cityblock, 2:minkowski, 3:chebychev
end
end

