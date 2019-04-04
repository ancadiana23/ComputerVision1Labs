test_data = load('stl10_matlab/test.mat');
train_data = load('stl10_matlab/train.mat');

[test_image_count, ~] = size(test_data.X);
[train_image_count, ~] = size(train_data.X);

% Set of global variables
CLUSTER_COUNT = 400; % 400, 1000, 4000; number of KNN cluster

% ignore this
use_test = false;

% Data Preprocessing


% reshape and store the 8000 test_images in a (8000, 96, 96, 3) sized
% vector
test_images_raw_data = reshape(test_data.X, test_image_count, 96, 96, 3);
test_class_label = test_data.y;

% reshape and store the 5000 train_images in a (5000, 96, 96, 3) sized
% vector
train_images_raw_data = reshape(train_data.X,train_image_count, 96, 96, 3);
train_class_label = train_data.y;

% Extract data from 5 classes (airplanes, birds, cars, horses, ships) for
% the training data.

% Now we need to extract the data relevant to us (the following classes):
% airplanes (class/label 1)
% birds (class/label 2)
% cars (class/label 3)
% horses (class/label 7)
% ships (class/label 9)

% each of the classes has 500 training images (and 800 test images) So here
% we eliminate all the data from irrelevant classes (we keep 5 out of 10
% classes) See above for 'label-class' assignment.
test_images_raw_data = test_images_raw_data(test_class_label == 1 ...
    | test_class_label == 2 ...
    | test_class_label == 3 ...
    | test_class_label == 7 ...
    | test_class_label == 9,:,:,:);
% and the labels ...
test_class_label = test_class_label(test_class_label == 1 ...
    | test_class_label == 2 ...
    | test_class_label == 3 ...
    | test_class_label == 7 ...
    | test_class_label == 9);

% Here we separate the training data into the classes
train_images_cl_air = train_images_raw_data(train_class_label==1,:,:,:);
train_images_cl_birds = train_images_raw_data(train_class_label==2,:,:,:);
train_images_cl_cars = train_images_raw_data(train_class_label==3,:,:,:);
train_images_cl_horses = train_images_raw_data(train_class_label==7,:,:,:);
train_images_cl_ships = train_images_raw_data(train_class_label==9,:,:,:);


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


% 2.1 Feature extraction:

% take subset of the data: (800 test and 500 train)

% using 'vl_sift' we create cells of the vl_sift data, namely
% 'test_images_sift' and 'test_images_descr' and also the array
% 'test_descr_matrix' that concatenates the descriptor data.

% There are 2500 train images and 4000 test images in total (500/800 per class)
% Here we define the number of images for training the clustering (K-means)
% needs to be multiples of 5 and below 2500
%test_image_count = 800;
train_image_count_cluster = 500;

cluster_train_images = cat(1, ...
    train_images_cl_air(1:train_image_count_cluster/5,:,:,:), ...
    train_images_cl_birds(1:train_image_count_cluster/5,:,:,:), ...
    train_images_cl_cars(1:train_image_count_cluster/5,:,:,:), ...
    train_images_cl_horses(1:train_image_count_cluster/5,:,:,:), ...
    train_images_cl_ships(1:train_image_count_cluster/5,:,:,:));

tic
% Here we save the vl_sift results and concatenate the descriptor data in a
% matrix, so we can apply k-means on it.
train_images_sift = {};
train_images_descr = {};
cluster_train_descr_matrix = [];


for i = 1:train_image_count_cluster
   [train_images_sift{i}, train_images_descr{i}] = vl_sift(single(rgb2gray((squeeze(cluster_train_images(i,:,:,:))))));
   cluster_train_descr_matrix = [cluster_train_descr_matrix; train_images_descr{i}'];
end
toc

% using vl_sift data , we use knn clustering to cluster
% all the descriptors (we have multiple descriptors for each image), so we
% get a lot of descriptors and the clustering does not cluster images, but
% descriptors.

% C is then a CLUSTER_COUNTx128 matrix, where the rows are the cluster
% centres
tic
[~, C] = kmeans(double(cluster_train_descr_matrix), CLUSTER_COUNT); 
toc 
% for 500 images and 400 cluster it takes ~22 seconds

% This cluster defines a vocabulary: one cluster is one word. 
% 1 image = set of words

% define function 'find_cluster_vector' that returns the normalized cluster 
% representation of an image (returns an 1xCLUSTER_COUNT array). (It uses 
% the internal function "get_closest_cluster" which returns the
% corresponding cluster for each descriptor.)
% -> we need train_image_count x CLUSTER_COUNT array
% looking at all possible cluster centre seems to be the easiest way to
% implement this.

% 'find_cluster_vector' will be used in the next step: Encoding


% 2.3 Encoding Features Using Visual Vocabulary
% using this clustering, we can represent each image as a collecion of
% words:
% 1. extract descriptors 
% 2. assign word to each descriptor

tic

svm_train_images_bow_hist_air = [];
svm_train_images_bow_hist_birds = [];
svm_train_images_bow_hist_cars = [];
svm_train_images_bow_hist_horses = [];
svm_train_images_bow_hist_ships = [];


%svm_train_descr_matrix = [];


% 2.4 Representing images by frequencies of visual words
% 1. represent image by words and their frequencies (histogram of its visual words)
% 2. normalize histogram
% This is all done in the 'find_cluster_vector'-function



% for i = (train_image_count_cluster/5+1):train_image_count/5

% Here we create the words for the different class-images. These will be
% used for training the SVMs
for i = train_image_count_cluster/5+1:train_image_count_cluster/5+100
   [~, descr] = vl_sift(single(rgb2gray((squeeze(train_images_cl_air(i,:,:,:))))));
   cluster_vector = find_cluster_vector(C, descr, CLUSTER_COUNT);
   svm_train_images_bow_hist_air = cat(1,svm_train_images_bow_hist_air,cluster_vector);
   
   [~, descr] = vl_sift(single(rgb2gray((squeeze(train_images_cl_birds(i,:,:,:))))));
   cluster_vector = find_cluster_vector(C, descr, CLUSTER_COUNT);
   svm_train_images_bow_hist_birds = cat(1,svm_train_images_bow_hist_birds,cluster_vector);
   
   [~, descr] = vl_sift(single(rgb2gray((squeeze(train_images_cl_cars(i,:,:,:))))));
   cluster_vector = find_cluster_vector(C, descr, CLUSTER_COUNT);
   svm_train_images_bow_hist_cars = cat(1,svm_train_images_bow_hist_cars,cluster_vector);
   
   [~, descr] = vl_sift(single(rgb2gray((squeeze(train_images_cl_horses(i,:,:,:))))));
   cluster_vector = find_cluster_vector(C, descr, CLUSTER_COUNT);
   svm_train_images_bow_hist_horses = cat(1,svm_train_images_bow_hist_horses,cluster_vector);
   
   [~, descr] = vl_sift(single(rgb2gray((squeeze(train_images_cl_ships(i,:,:,:))))));
   cluster_vector = find_cluster_vector(C, descr, CLUSTER_COUNT);
   svm_train_images_bow_hist_ships = cat(1,svm_train_images_bow_hist_ships,cluster_vector);
   
   %train_descr_matrix = [train_descr_matrix; train_images_descr{i}'];
end
toc


%size(svm_train_images_bow_hist_ships)


% 2.5 Classification
% After representing every image as a histogram over the vocabulary we can
% train a SVM classifier for image classification. We train the SVM on data
% we have not used for the clustering and apply the SVM on the BoWs,
% which are vectors of size CLUSTER_COUNT.
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

% current data size for testing = 250 for every svm training (50 per class, we use the same ones here)
training_size = 250;

% Creating training labels
Y_air = zeros(1,training_size);
Y_air(1:training_size/5) = ones(1,training_size/5);

Y_birds = zeros(1,training_size);
Y_birds(training_size/5+1:training_size/5*2) = ones(1,training_size/5);

Y_cars = zeros(1,training_size);
Y_cars(training_size/5*2+1:training_size/5*3) = ones(1,training_size/5);

Y_horses = zeros(1,training_size);
Y_cars(training_size/5*3+1:training_size/5*4) = ones(1,training_size/5);

Y_ships = zeros(1,training_size);
Y_ships(training_size/5*4+1:training_size/5*5) = ones(1,training_size/5);

% Creating the training dataset (training_size/5 of each)

X = [
    svm_train_images_bow_hist_air(1:training_size/5,:),
    svm_train_images_bow_hist_birds(1:training_size/5,:),
    svm_train_images_bow_hist_cars(1:training_size/5,:),
    svm_train_images_bow_hist_horses(1:training_size/5,:),
    svm_train_images_bow_hist_ships(1:training_size/5,:)];

size(X)

hAxes = axes( figure ); % I usually use figure; hAxes = gca; here, but this is even more explicit.
hImage = imshow(rgb2gray(squeeze(train_images_cl_air(i,:,:,:))), 'Parent', hAxes);


size(Y_air')
SVMModel_air = fitcsvm(X,Y_air')%,'KernelFunction','gaussian');
SVMModel_birds = fitcsvm(X,Y_birds')%,'KernelFunction','gaussian');
SVMModel_cars = fitcsvm(X,Y_cars')%,'KernelFunction','gaussian');
SVMModel_horses = fitcsvm(X,Y_horses')%,'KernelFunction','gaussian');
SVMModel_ships = fitcsvm(X,Y_ships')%,'KernelFunction','gaussian');

% test_images_raw_data = reshape(test_data.X, test_image_count, 96, 96, 3);
% test_classes_label = test_data.y;
test_data_count = 40;

test_data = test_images_raw_data(1:test_data_count,:,:,:);
test_label = test_class_label(1:test_data_count);
% test_hist represents the histograms of the test data. On these histograms
% we will apply the SVM classifier.
test_hist = [];
for i = 1:test_data_count
   [~, descr] = vl_sift(single(rgb2gray((squeeze(test_data(i,:,:,:))))));
    cluster_vector = find_cluster_vector(C, descr, CLUSTER_COUNT);
    test_hist = [test_hist; cluster_vector];
end
% -> compute histograms for the test data

% define our test_data
newX = test_hist;

% score_air etc. are a nx2 array, where the second column are the
% probabilities of a positive prediction
[~ , score_air] = predict(SVMModel_air,newX);
[~ , score_birds] = predict(SVMModel_birds,newX);
[~ , score_cars] = predict(SVMModel_cars,newX);
[~ , score_horses] = predict(SVMModel_horses,newX);
[~ , score_ships] = predict(SVMModel_ships,newX);

score_air
[air_sort, air_order] = sort(score_air(:,2));
air_sort
test_label_sorted = test_label(air_order,:)
test_data_sorted = test_data(air_order,:,:,:);

for i=1:5
    hAxes = axes( figure ); % I usually use figure; hAxes = gca; here, but this is even more explicit.
    hImage = imshow(rgb2gray((squeeze(test_data_sorted(i,:,:,:)))), 'Parent', hAxes);
end



% for sorting: [A_sort, A_order] = sort(A) -> B(A_order,:) is B sorted by
% values in A


% Evaluation

% Do not forget to swtich out every vl_sift function in the code
% Maybe even create a custom_sift_function, with one additional parameter,
% that decides on the type of sift function. This parameter can then be set
% at the start of the demo.


