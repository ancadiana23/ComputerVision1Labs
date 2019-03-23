function [net, info, expdir] = finetune_cnn(varargin)

%% Define options
run(fullfile(fileparts(mfilename('fullpath')), ...
  '..', '..', '..', 'matlab', 'vl_setupnn.m')) ;

opts.modelType = 'lenet' ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.expDir = fullfile('data', ...
  sprintf('cnn_assignment-%s', opts.modelType)) ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.dataDir = './data/' ;
opts.imdbPath = fullfile(opts.expDir, 'imdb-stl.mat');
opts.whitenData = true ;
opts.contrastNormalization = true ;
opts.networkType = 'simplenn' ;
opts.train = struct() ;
opts = vl_argparse(opts, varargin) ;
if ~isfield(opts.train, 'gpus'), opts.train.gpus = []; end;

opts.train.gpus = [0];



%% update model

net = update_model();

%% TODO: Implement getIMDB function below

if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath) ;
else
  imdb = getIMDB() ;
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
end

%%
net.meta.classes.name = imdb.meta.classes(:)' ;

% -------------------------------------------------------------------------
%                                                                     Train
% -------------------------------------------------------------------------

trainfn = @cnn_train ;
[net, info] = trainfn(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', find(imdb.images.set == 2)) ;

expdir = opts.expDir;
end
% -------------------------------------------------------------------------
function fn = getBatch(opts)
% -------------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

end

function [images, labels] = getSimpleNNBatch(imdb, batch)
% -------------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if rand > 0.5, images=fliplr(images) ; end

end

% -------------------------------------------------------------------------
function imdb = getIMDB()
% -------------------------------------------------------------------------
% Preapre the imdb structure, returns image data with mean image subtracted
classes = {'airplanes', 'birds', 'ships', 'horses', 'cars'};
splits = {'train', 'test'};
%% In original data: 10 classes: 'airplanes' = 1; 'bird' = 2
relevant_labels = [1 2 9 7 3];

%% TODO: Implement your loop here, to create the data structure described in the assignment
%% Use train.mat and test.mat we provided from STL-10 to fill in necessary data members for training below
%% You will need to, in a loop function,  1) read the image, 
%% 2) resize the image to (32,32,3), 
%% 3) read the label of that image

%% imdb.images.data: 4D matrix(im_h, im_w, num_channels, num_images)
%% imdb.images.labels: 1D vector: airplanes(1), birds(2), ships(3), horses(4), cars(5)
%% imdb.images.set is a 1D vector training (== 1) or the testing (== 2) 

train = load('stl10_matlab/train.mat');
test = load('stl10_matlab/test.mat');

%% only take images with y value in class labels -> find ids of images with 
%% class out of relevant_labels
ids_train = find(ismember(train.y, relevant_labels));
ids_test= find(ismember(test.y, relevant_labels));

%% select relevant images
train.X = train.X(ids_train, :);
train.y = train.y(ids_train, :);
test.X = test.X(ids_test, :);
test.y = test.y(ids_test, :);

%% convert labels to 1:5

%% train data
for i = 1:length(train.y)
   if train.y(i) == 9
       train.y(i) = 3;
   elseif train.y(i) == 7
       train.y(i) = 4;
   elseif train.y(i) == 3
       train.y(i) = 5;
   end
end
%% test data
for i = 1:length(test.y)
   if test.y(i) == 9
       test.y(i) = 3;
   elseif test.y(i) == 7
       test.y(i) = 4;
   elseif test.y(i) == 3
       test.y(i) = 5;
   end
end
%% reshape per image to 96x96x3 (image_width, image_height, num_channel)
%% train has 500 per class so 2500x96x96x3 for all train images
train.X = reshape(train.X, 2500, 96, 96, 3);
%% test has 800 per class so 4000x96x96x3 for all test images
test.X = reshape(test.X, 4000, 96, 96, 3);

%% build data; set and labels
%% data is filled with train.X and test.X
data = zeros(96, 96, 3, length(train.y) + length(test.y));
labels = zeros(length(train.y) + length(test.y), 1);
sets = zeros(length(train.y) + length(test.y), 1);

for i = 1:length(train.y)
    data(:,:,:,i) = train.X(i,:,:,:);
    labels(i) = train.y(i);
    sets(i) = 1;
end
for i = (length(train.y)+1):(length(train.y)+length(test.y))
    data(:,:,:,i) = test.X(i-length(train.y),:,:,:);
    labels(i) = test.y(i-length(train.y));
end


%% 
% subtract mean
dataMean = mean(data(:, :, :, sets == 1), 4);
data = bsxfun(@minus, data, dataMean);

imdb.images.data = data ;
imdb.images.labels = single(labels) ;
imdb.images.set = sets;
imdb.meta.sets = {'train', 'val'} ;
imdb.meta.classes = classes;

perm = randperm(numel(imdb.images.labels));
imdb.images.data = imdb.images.data(:,:,:, perm);
imdb.images.labels = imdb.images.labels(perm);
imdb.images.set = imdb.images.set(perm);

end
