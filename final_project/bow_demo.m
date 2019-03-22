test_data = load('stl10_matlab/test.mat');
train_data = load('stl10_matlab/train.mat');

[test_image_count, ~] = size(test_data.X);
[train_image_count, ~] = size(train_data.X);

% Set of global variables
CLUSTER_COUNT = 400; % 400, 1000, 4000; number of KNN cluster


use_test = false;



% reshape and store the 8000 test_images in a (8000, 96, 96, 3) sized
% vector
test_images_raw_data = reshape(test_data.X, test_image_count, 96, 96, 3);
test_classes_label = test_data.y;

% reshape and store the 5000 test_images in a (5000, 96, 96, 3) sized
% vector
train_images_raw_data = reshape(train_data.X,train_image_count, 96, 96, 3);
train_class_label = train_data.y;

% Before we want to train a BoW based Image Classifier, we need to do the
% following:
%   1. Save all train and test images in an array
%   2. Preprocess, depending on the vl_sift method we use
%       2.1 into 'Single'
%       2.2 RGB
%       2.3 oponent-SIFT?
%
% Output: Array of images ready to use vl_sift on
%       For now: only normal sift (in gray form)

% Creating cells to store the vl_sift data
% 'test_images_sift{i}' contains vl_sift result of test image i



test_image_count = 800;
train_image_count = 500;

if use_test
    test_images_sift = {};
    test_images_descr = {};
    test_descr_matrix = [];

    for i = 1:test_image_count
       [test_images_sift{i}, test_images_descr{i}] = vl_sift(single(rgb2gray((squeeze(t(i,:,:,:))))));
       test_descr_matrix = [test_descr_matrix; test_images_descr{i}'];

    end
end
%}

% Similar for train images
tic
train_images_sift = {};
train_images_descr = {};
train_descr_matrix = [];


for i = 1:test_image_count
   [train_images_sift{i}, train_images_descr{i}] = vl_sift(single(rgb2gray((squeeze(t(i,:,:,:))))));
   train_descr_matrix = [train_descr_matrix; train_images_descr{i}'];
end
toc
% Taking only a part of the data for speed reasons

if use_test
    test_im_c_part = min(1600, test_image_count);
    test_im_s_part = test_images_sift(1:test_im_c_part);
end

train_im_c_part = min(1000, train_image_count);
train_im_s_part = train_images_sift(1:train_im_c_part);


% 2.1 Feature extraction:

% take subset of the data: (800 test and 500 train)

% using 'vl_sift' we create an array of the vl_sift data
%[F, D] = VL


% using vl_sift data of first half, we use knn clustering to cluster
% all the descriptors (we have multiple descriptors for each image), so we
% get a lot of descriptors and the clustering does not cluster images, but
% descriptors.

% take all descriptor data into one large matrix ()
tic
[~, C] = kmeans(double(train_descr_matrix), CLUSTER_COUNT) 
toc % for 500 images and 400 cluster it takes ~22 seconds

% This cluster defines a vocabulary: one cluster is one word. 
% 1 image = set of words

% define function 'get bow_vector' that returns the cluster representation
% of an image (returns an 1x400 array)
% -> we need train_image_count x CLUSTER_COUNT array
% looking at all possible cluster centre seems to be the easiest way to
% implement this.


% 2.3 Encoding Features Using Visual Vocabulary
% using this clustering, we can represent each image as a collecion of
% words:
% 1. extract descriptors 
% 2. assign word to each descriptor

% 2.4 Representing images by frequencies of visual words
% 1. represent image by words and their frequencies (histogram of its visual words)
% 2. normalize histogram


% 2.5 Classification
% After representing every image as a histogram over the vocabulary we can
% train a SVM classifier for image classification. We train the SVM on data
% we have not used for the clustering and apply the SVM on the BoWs,
% which are vectors of size CLUSTER_COUNT. (right?)
% 1. Train a SVM classifier for each object class (-> 5 binary classifiers)
%   1.1 Create set of positive examples
%      1.1.1 Take images of this class that we did not use for clustering
%           (use at least 50 training images of this class)
%      1.1.2 Represent them with histograms 
%   1.2 Create a set of negative examples
%      1.2.1 Take images from other classes we did not use for clustering
%           (use at least 50 training images per other class -> in sum at least 200)
%   1.3 Train SVM classifier for this class
%
% To classify image, apply all 5 SVM classifier to it and take the class
% with the highest probability.


% Evaluation

