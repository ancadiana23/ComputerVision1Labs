
video_frame_dir = 'pingpong';
fullfile(pwd, video_frame_dir, '*.jpg')
image_names = dir(fullfile(pwd, video_frame_dir, '*.jpeg'));
images = cell(length(image_names),1);
for k = 1:length(image_names)
  image_name = fullfile(pwd, video_frame_dir, image_names(k).name);
  images{k} = imread(image_name);
end

%{
c = containers.Map
c('foo') = 1
c(' not a var name ') = 2
keys(c)
values(c)
%}

blocksize = 100;
[H, r, c] = harris_corner_detector(images{1});
size(images{1})
rectangle = zeros(3, 3, 3);
rectangle(:, :, 2) = 255;
for ii = 1:length(images) - 1
    ii
    Vy_Vx = lucas_kanade(images{ii}, images{ii + 1}, blocksize);
    for jj = 1:length(r)
        [dy dx] = Vy_Vx(ceil(r(jj) / blocksize), ceil(c(jj) / blocksize), :);
        r(jj) = r(jj) + dy;
        c(jj) = c(jj) + dx;
        images{ii}(r(jj)-1:r(jj)+1, c(jj)-1:c(jj)+1, :) = rectangle;
    end
end

outputVideo = VideoWriter(fullfile(pwd,'feature_tracking_demo.avi'));
outputVideo.FrameRate = 10;
open(outputVideo);
for ii = 1:length(images)
   writeVideo(outputVideo, uint8(images{ii}));
end

close(outputVideo)
