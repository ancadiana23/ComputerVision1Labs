
video_frame_dir = 'person_toy';
image_names = dir(fullfile(pwd, video_frame_dir, '*.jpg'));

blocksize = 5;

image_name = fullfile(pwd, video_frame_dir, image_names(1).name);
current_image = imread(image_name);
[H, r, c] = harris_corner_detector(current_image);
dr = zeros(size(r));
dc = zeros(size(c));

figure(3)
for ii = 1: length(image_name)
    ii
    image_name = fullfile(pwd, video_frame_dir, image_names(ii+1).name);
    new_image = imread(image_name);
    Vy_Vx = lucas_kanade(current_image, new_image, blocksize);
    
    Vy_Vx(isnan(Vy_Vx)) = 0;
    regions_r = ceil(r / blocksize);
    regions_c = ceil(c / blocksize);
    regions_r(regions_r <=0) = 1;
    regions_c(regions_c <=0) = 1;
    dr = Vy_Vx(sub2ind(size(Vy_Vx), regions_r, regions_c, ones(size(r))));
    dc = Vy_Vx(sub2ind(size(Vy_Vx), regions_r, regions_c, zeros(size(r)) + 1));
    
    r = round(r + 2.0*dr);
    c = round(c - 2.0*dc);
    
    imshow(current_image);
    hold on;
    q = quiver(c, r, -dc, dr,'color',[1 0 0]);
    q.AutoScaleFactor = 1.;
    q.LineWidth = 1.;
    drawnow
    hold off
    saveas(figure(3), "./output/video_frame" + ii + ".jpg");
    current_image = new_image;
end

%{
outputVideo = VideoWriter(fullfile(pwd,'feature_tracking_demo.avi'));
outputVideo.FrameRate = 10;
open(outputVideo);
out_image_names = dir(fullfile(pwd, video_frame_dir, '*.jpg'));
images = cell(length(image_names),1);
for k = 1:length(image_names)
  image_name = fullfile(pwd, video_frame_dir, image_names(k).name);
  images{k} = imread(image_name);
end
for ii = 1:length(images)
   writeVideo(outputVideo, uint8(images{ii}(1:h, 1:w, :)));
end

close(outputVideo)
%}