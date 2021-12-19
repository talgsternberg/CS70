function [im_blend1, im_blend2] = gradientBlend(im_s, mask_s, im_background)
% input
% -----
% im_s : the aligned source image to be blended onto a new image
% mask_s : a binary image specifying the pixels in the new image to be blended
% im_background : the image that im_s will be blended onto



% output
% -----
% im_blend1 : im_background with im_s blended using backslash operator
% im_blend2 : im_background with im_s blended using normal equations


% get size of image

%end result image -- total combined: used in reconstructing whole image
bigImageSize = size(im_background);
imh = bigImageSize(1,1);
imw = bigImageSize(1,2);


%im size
[imh,imw,nb] = size(im_s);

%mask size
mask_size = size(mask_s);


% create matrix that maps each pixel to a variable number
%find mask size to solve
[yy,xx] = find(mask_s>0);

%rows and colums
R = size(yy);
C = size(xx);

%initialize im2var
im2var = zeros(R(1,1),C(1,1));


%iterate through the mask and create an im2var 
pixvar = 0;
for i= 1:yy
    for j = 1:xx
        pixvar = pixvar + 1;
        im2var(i,j) = pixvar;   
    end 
end

disp(im2var);



% find number of variables to be solved
Vars = mask_size(1,1) * mask_size(1,2);
varsToSolve = sum(mask_s, 'all')/(Vars);



% initialize A and b

% we will have at most 4 rows (equations) for each variable (pixel)
% but we don't know the exact amount until we set up the system
% we will remove the unneeded rows at the end

% each row will have at most 2 non-zero elements, so 
% we will have at most 2*maxEqns non-zero elements
A = sparse([],[],[],(4*image_size), varsToSolve, image_size);

%i know i should be creating different vector b's for each color channel
b_red = zeros(varsToSolve);
b_green = zeros(varsToSolve);
b_blue = zeros(varsToSolve);


% set up blending constraints
%iterate for objectives 1 and 2
for i = 1:imh 
    for j = 1:imw 
        
        %objective 1
        e = e + 1;
        A(e,im2var(i,j+1)) = 1; 
        A(e,im2var(i,j)) = -1;
        b_red(e) = im(i,j+1,1)-im(i,j,1);
        b_green(e) = im(i,j+1,2)-im(i,j,2);
        b_blue(e) = im(i,j+1,3)-im(i,j,3);
        
        
        %objective 2
        e = e + 1;
        A(e,im2var(i+1,j)) = 1; 
        A(e,im2var(i,j)) = -1;
        b_red(e) = im(i+1,j,1)-im(i,j,1);
        b_green(e) = im(i+1,j,2)-im(i,j,2);
        b_blue(e) = im(i+1,j,3)-im(i,j,3);
        
      
    end
end




% incomplete tasks:
% remove all rows past the last equation 
% color channels --> i know i should be creating different vector b's for
% each color channel
% also I know a lot of this is incorrect. 




% solve blending constraints
%using backslash
tic;
v = A \ b;
toc;

%using normal equations
tic;
v2 = inv(A'*A)*A'*b;
toc;




% copy the values over to the target image to the area to be blended --
% how?

imv_s1(1:imw*imh) = v(:,1);
imv_s2(1:imw*imh) = v2(:,1);

ims_1 = reshape(imv_s1, [mask_size(1,1), mask_size(1,2)]);
ims_2 = reshape(imv_s2, [mask_size(1,1), mask_size(1,2)]);

disp(ims_1);
disp(ims_2);







