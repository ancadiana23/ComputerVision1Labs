function [Vx_Vy] = lucas_kanade(image1, image2)
im1 = imread(image1);
im2 = imread(image2);

[h,w] = size(im1);
Ix = zeros(size(im1));
Iy = zeros(size(im1));
It = zeros(size(im1));

for i = 1:h
    for j = 1:w
        ix,iy,it = getDerivative(i,j, im1, im2);
        Ix(i,j) = ix;
        Iy(i,j) = iy;
        It(i,j) = it;
    end
end

M_blocks_Iy = cell(17,17);
M_blocks_Ix = cell(17,17);
M_blocks_It = cell(17,17);

Vx_Vy = zeros(17,17,2);

for i = 1:17
    for j = 1:17
    M_blocks_Iy{i,j} = Iy(15*i-14:15 * i, 15*j-14: 15*(j));
    M_blocks_Ix{i,j} = Ix(15*i-14:15 * i, 15*j-14: 15*(j));
    M_blocks_It{i,j} = It(15*i-14:15 * i, 15*j-14: 15*(j));
    
    
    Vx_Vy(i,j) = computeOpticalFlow(generateAb(M_blocks_Iy{i,j},M_blocks_Ix{i,j}, M_blocks_It{i,j}));
    end
end

end

function [Iy, Ix, It] = getDerivative(y, x, im1, im2)
[width, height] = size(im1);
if x < width
    Ix = im1(y,x+1) - im1(y,x);
else
    Ix = 0
end
if y < height
    Iy = im1(y+1,x) - im1(y,x);
else
    Iy = 0
end
It = im2(y,x) - im1(y,x)    

end


function [A,b] = generateAb(block_Iy, block_Ix, block_It)

A = zeros(225,2);

b = -block_It(:);
A(:,1) = block_Ix(:);
A(:,2) = block_Iy(:);

end

function [vx, vy] = computeOpticalFlow(A,b)

vx, vy = mtimes(inv(mtimes(A.',A)), mtimes(A.',b));


end