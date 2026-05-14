function filtered_image = conservative_smoothing(image)
    
[rows, cols, channels] = size(image);
    filtered_image = image; 
    
    for c = 1:channels
        
        for i = 2:rows-1
            for j = 2:cols-1
                
                neighborhood = image(i-1:i+1, j-1:j+1, c);
                
                min_val = min(neighborhood(:));
                max_val = max(neighborhood(:));
                
               
                current_pixel = image(i, j, c);
                
                
                if current_pixel == min_val || current_pixel == max_val
                   
                    filtered_image(i, j, c) = median(neighborhood(:));
                end
            end
        end
    end
end
