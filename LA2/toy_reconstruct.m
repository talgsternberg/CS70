function[] = toy_reconstruct(toyimage)

%load image
im = im2double(imread('toy_problem.png'));

%create im2var matrix
[imh,imw,nb] = size(im);
im2var = zeros(imh,imw);
im2var(1:imh*imw) = 1:imh*imw;


%some variables to help initialize A and b 
total_pixels = imw*imh;
ob1 = (imh)*(imw-1);
ob2 = (imh-1)*(imw);
ob3 = 1;


%initialize A and b
A = sparse((ob1+ob2+ob3), total_pixels); 
b = zeros((ob1+ob2+ob3),1);



%set equation iterator to 0
e = 0;


%iterate for objectives 1 and 2
for i = 1:imh-1 
    for j = 1:imw-1 
        
        %objective 1
        e = e + 1;
        A(e,im2var(i,j+1)) = 1; 
        A(e,im2var(i,j)) = -1;
        b(e) = im(i,j+1)-im(i,j);
        
        
        %objective 2
        e = e + 1;
        A(e,im2var(i+1,j)) = 1; 
        A(e,im2var(i,j)) = -1;
        b(e) = im(i+1,j)-im(i,j);
        
      
    end
end


%objective 3

e = e + 1;
A(e, im2var(1,1)) = 1;
b(e) = im(1,1);



%solve 
v = A \ b;

%copy solved values to correct pixel
newImv = zeros(imh,imw);

% regenrate image
newImv(1:imw*imh) = v(:,1);
newIm = reshape(newImv, [119 110]);

%show figures to make sure correct
figure(1);
imshow(im);
figure(2);
imshow(newIm);

end

