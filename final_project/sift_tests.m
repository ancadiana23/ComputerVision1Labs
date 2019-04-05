
train_data = load('stl10_matlab/train.mat');

[train_image_count, ~] = size(train_data.X);

% reshape and store the 8000 test_images in a (8000, 96, 96, 3) sized
% vector
train_images_raw_data = reshape(train_data.X,train_image_count, 96, 96, 3);

i=2;

[~,descr1] = vl_sift(single(rgb2gray((squeeze(train_images_raw_data(i,:,:,:))))));

[~,descr2] = vl_phow(single(squeeze(train_images_raw_data(i,:,:,:))),'color','gray', 'Step', 8);

descr3 = my_sift(squeeze(train_images_raw_data(i,:,:,:)), 'dense', 'rgb');
descr4 = my_sift(squeeze(train_images_raw_data(i,:,:,:)), 'keypoint', 'rgb');
