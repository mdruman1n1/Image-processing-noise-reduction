function filtered_image = mean_smoothing(image)
    
    [rows, cols, channels] = size(image); 
    filtered_image = image;
   
    for c = 1:channels
       
        for i = 2:rows-1
            for j = 2:cols-1
                
                neighborhood = image(i-1:i+1, j-1:j+1, c);
                              
                filtered_image(i, j, c) = mean(neighborhood(:));
            end
        end
    end
end