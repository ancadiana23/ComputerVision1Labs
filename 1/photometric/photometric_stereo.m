close all
clear all
clc
 
disp('Part 1: Photometric Stereo')

% obtain many images in a fixed view under different illumination
disp('Loading images...')
image_dir = './photometrics_images/SphereGray5/';   % TODO: get the path of the script
%image_ext = '*.png';

[image_stack, scriptV] = load_syn_images(image_dir);

[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);

% compute the surface gradient from the stack of imgs and light source mat
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, 1);


%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface( p, q, "average");

[x_end, y_end, ~] = size(height_map);
x = 1:16:x_end;
y = 1:16:y_end;
quiver3(x, y, height_map(1:16:end, 1:16:end), normals(1:16:end,1:16:end,1), normals(1:16:end,1:16:end,2), normals(1:16:end,1:16:end,3))


%% Display
show_results(albedo, normals, SE);
show_model(albedo, height_map);


%% Face
[image_stack, scriptV] = load_face_images('./photometrics_images/yaleB02/');
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, 0);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface( p, q, "average");

show_results(albedo, normals, SE);
show_model(albedo, height_map);


%% MonkeyColor
sum_albedo = NaN;
sum_normals = NaN;
sum_p = NaN;
sum_q = NaN;
for channel = 1:3
    [image_stack, scriptV] = load_syn_images('./photometrics_images/SphereColor/', channel);
    [h, w, n] = size(image_stack);
    fprintf('Finish loading %d images.\n\n', n);
    disp('Computing surface albedo and normal map...')
    [albedo, normals] = estimate_alb_nrm(image_stack, scriptV, 0);
    albedo(isnan(albedo)) = 0;
    normals(isnan(normals)) = 0;
    %% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
    disp('Integrability checking')
    [p, q, SE] = check_integrability(normals);
    if channel == 1
        sum_albedo = albedo;
        sum_normals = normals;
        sum_p = p;
        sum_q = q;
    else
        sum_albedo = sum_albedo + albedo;
        sum_normals = sum_normals + normals;
        sum_p = sum_p + p;
        sum_q = sum_q + q;
    end
    
    threshold = 0.005;
    SE(SE <= threshold) = NaN; % for good visualization
    fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

end
albedo = sum_albedo / 3;
normals = sum_normals / 3;
p = sum_p / 3;
q = sum_q / 3;

%% compute the surface height
height_map = construct_surface( p, q, "average");

show_results(albedo, normals, SE);
show_model(albedo, height_map);
