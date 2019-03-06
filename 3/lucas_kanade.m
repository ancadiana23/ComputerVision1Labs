function [Vy_Vx] = lucas_kanade(im1, im2, blocksize)


[h,w] = size(im1);
% use the width and height of the images and the blocksize to compute the 
% number of regions
block_rows = floor(h/blocksize);
block_columns = floor(w/blocksize);
% initialize the matrices for the derivatives
Ix = zeros(size(im1));
Iy = zeros(size(im1));
It = zeros(size(im1));

% loop over every pixel
for i = 1:h
    for j = 1:w
        % apply our 'getDerivative' function to 
        [iy,ix,it] = getDerivative(i,j, im1, im2);
        Ix(i,j) = ix;
        Iy(i,j) = iy;
        It(i,j) = it;
    end
end

%imshow(Ix)
%imshow(Iy)
%imshow(It)

M_blocks_Iy = cell(block_rows,block_columns);
M_blocks_Ix = cell(block_rows,block_columns);
M_blocks_It = cell(block_rows,block_columns);

Vy_Vx = zeros(block_rows,block_columns,2);

for i = 1:block_rows
    for j = 1:block_columns
    M_blocks_Iy{i,j} = Iy(1 + (i-1)*blocksize:blocksize * i, 1+ (j-1)*blocksize: blocksize*j);
    M_blocks_Ix{i,j} = Ix(1 + (i-1)*blocksize:blocksize * i, 1+ (j-1)*blocksize: blocksize*j);
    M_blocks_It{i,j} = It(1 + (i-1)*blocksize:blocksize * i, 1+ (j-1)*blocksize: blocksize*j);
    
    [A,b] =generateAb(M_blocks_Iy{i,j},M_blocks_Ix{i,j}, M_blocks_It{i,j});
    Vy_Vx(i,j,:) = -computeOpticalFlow(A,b);
    end
end

end

function [Iy, Ix, It] = getDerivative(y, x, im1, im2)
[height, width] = size(im1);
if x < width
    Ix = im1(y,x+1) - im1(y,x);
else
    Ix = 0;
end
if y < height
    Iy = im1(y+1,x) - im1(y,x);
else
    Iy = 0;
end
It = im2(y,x) - im1(y,x) ;   

end


function [A,b] = generateAb(block_Iy, block_Ix, block_It)

[h,w] = size(block_Iy);
A = zeros(h*w,2);

b = -block_It(:);
A(:,2) = block_Iy(:);
A(:,1) = block_Ix(:);

end

function [vy_vx] = computeOpticalFlow(A,b)

[vy_vx,~] = linsolve(mtimes(A.',A), mtimes(A.',b));
%vx_vy = mtimes(inv(mtimes(A.',A)), mtimes(A.',b));



end %test