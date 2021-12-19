function[] = get_coords(videoFile, outputFile, skip)


vidObj = VideoReader(videoFile);

%how many frames total? Keep a tracker
frameNumber = 1;

%preallocate frames and coords
coords = zeros(25,2);
frames = zeros(1024,1280,3,25);


%start at the first row, move down each frame
row = 1;


%iterate while frame exists and incorporate "skip"
while hasFrame(vidObj)
    frame = readFrame(vidObj);
    
    
    % if its a fourth frame
    if (mod(frameNumber-1,skip) == 0)
        imshow(frame);
        drawnow;
        
        %store indivual frames
        %nframes = round(vidObj.Duration * vidObj.FrameRate); --> use for
        %allocating
        
        %frames(row) = frame;
        frames(:,:,:,row) = frame(:,:,:);

        
        %prompt input and store in coords
        [x,y] = ginput(1);
        coords(row, 1) = x;
        coords(row, 2) = y;
                
        

        %save the vars
        save(outputFile, 'frames', 'coords');


        %update pos in matrix
        row = row + 1;

    end




    %next frame
    frameNumber = frameNumber + 1;
   


end




       
    
end


