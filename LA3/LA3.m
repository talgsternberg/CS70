function[] = LA3(image)
%---------------------------------
%SETUP
%load each image
cd = im2double(imread(image));

imageSize = size(cd);
step12Matrix = zeros(imageSize(1), imageSize(2));


%grayscale each image
cdGS = rgb2gray(cd);

%extract salient edges
cdE = edge(cdGS);

%extract x and y coords
[x,y] = find(cdE);
xSize = size(x);

%---------------------------
%E STEP

%initializing variables
Cx = 233;
Cy = 233;
r = 190;
StdDev = 8;
e = 2.718281828459046;

%iterator to go through disk
discIterator = size(x);


while(1)
    %update "old" values with the current values
    oldCx = Cx;
    oldCy = Cy;
    oldr = r;

    % calc residual and Gaussian for M1 for each point
    di = abs(sqrt((x-Cx)+(y-Cy))-r);
    GaussianM1i = (1/(StdDev*sqrt(2*pi)))*e.^(-0.5*(di./StdDev).^2);

    % model 1: P(d ∩ (i ∈ M1)) = P(d|i ∈ M1)P(i ∈ M1)
    discProb = (GaussianM1i)./(GaussianM1i+0.1);                                                                                                


    %---------------------------
    %M STEP

    %initialize B and create weights matrix
    weights = diag(discProb);                   
    B = zeros(discIterator(1),4);


    % iterate though edge points and build matrix B 
    for i = 1:discIterator(1,1)
        B(i,1) = (x(i,1))^2 + (y(i,1))^2;
        B(i,2) = x(i);
        B(i,3) = y(i);
        B(i,4) = 1;
    end 

    %solve using eigenvector/value
    solveMatrix = (B'*weights') * (weights*B);
    [v,d] = eigs(solveMatrix);
    [minVal, ind] = min(diag(d));
    v = v(:,ind);
    

    %update found values
    a = v(1,1);
    b1 = v(2,1);
    b2 = v(3,1);
    c = v(4,1);
    bMag = sqrt((b1^2)+(b2^2));

    
    %update image values
    Cx = -b1/(2*a);
    Cy = -b2/(2*a);
    r = sqrt((bMag^2/(4*a^2))-(c/a));
    
   
    
    %break out of loop checkpoint
    if((abs(Cx-oldCx) < 0.1) || (abs(Cy-oldCy) < 0.1) || (abs(r-oldr) < 0.1)) 
      break;       
    end
    
    
    
    %new variance calculation
    sumWiD2i = (sum(di))^2*(sum(weights));
    sumWi = sum(weights);
    StdDev = sqrt(sumWiD2i/sumWi);
    
    
    
    %disp current circle ontop of orig RGB image (image 1)
    %nexttile;
    imshow(image);  
    hold on;
    step = 0:pi/50:2*pi;
    xunit = r * cos(step) + Cx;
    yunit = r * sin(step) + Cy;
    plot(xunit, yunit);
    hold off;
    
   
    
    %disp current probability of each pixel M1 as binary img (image 2)
    
    %update each edge pixel w current probabilities
    for i = 1:xSize(1)
        xpos = x(i);
        ypos = y(i);
        step12Matrix(ypos,xpos) = discProb(i);
    end
    
    %display the probabilities
    nexttile
    imshow(step12Matrix, [0,255]); %white not showing up here???
    
      
end


end
