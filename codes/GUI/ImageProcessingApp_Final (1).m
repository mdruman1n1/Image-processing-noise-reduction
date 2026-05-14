classdef ImageProcessingApp_Final < matlab.apps.AppBase
    
    properties (Access = public)
        
        UIFigure            matlab.ui.Figure
        OriginalImageAxes   matlab.ui.control.UIAxes
        FilteredImageAxes   matlab.ui.control.UIAxes
        OpenImageButton     matlab.ui.control.Button
        ConservativeButton  matlab.ui.control.Button
        MedianButton        matlab.ui.control.Button
        MeanButton          matlab.ui.control.Button
        SharpenButton       matlab.ui.control.Button
        ResetButton         matlab.ui.control.Button
        SaveButton          matlab.ui.control.Button
        BrightnessSlider    matlab.ui.control.Slider
        ContrastSlider      matlab.ui.control.Slider
        BrightnessLabel     matlab.ui.control.Label
        ContrastLabel       matlab.ui.control.Label
    end

    properties (Access = private)
        
        OriginalImage  
        FilteredImage  
        CurrentImage   
    end

    methods (Access = private)
               
        function OpenImageButtonPushed(app, ~)
            [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files'});
            if ~isequal(filename, 0)
                app.OriginalImage = imread(fullfile(pathname, filename));
                app.CurrentImage = app.OriginalImage;
                imshow(app.CurrentImage, 'Parent', app.OriginalImageAxes);
                title(app.OriginalImageAxes, 'Original Image');
                app.BrightnessSlider.Value = 0;
                app.ContrastSlider.Value = 0;
            end
        end
        
        function filtered = conservativeFilter(~, img)
            [rows, cols, ch] = size(img);
            filtered = img;
            for c = 1:ch
                for i = 2:rows-1
                    for j = 2:cols-1
                        neighborhood = img(i-1:i+1,j-1:j+1,c);
                        min_val = min(neighborhood(:));
                        max_val = max(neighborhood(:));
                        if img(i,j,c) == min_val || img(i,j,c) == max_val
                            filtered(i,j,c) = median(neighborhood(:));
                        end
                    end
                end
            end
        end
        
        function filtered = medianFilter(~, img)
            filtered = medfilt3(img);
        end
        
        function filtered = meanFilter(~, img)
            kernel = ones(3)/9;
            filtered = imfilter(img, kernel);
        end
           
        function ConservativeButtonPushed(app, ~)
            if ~isempty(app.CurrentImage)
                app.FilteredImage = app.conservativeFilter(app.CurrentImage);
                imshow(app.FilteredImage, 'Parent', app.FilteredImageAxes);
                title(app.FilteredImageAxes, 'Conservative Filter');
            end
        end
        
        function MedianButtonPushed(app, ~)
            if ~isempty(app.CurrentImage)
                app.FilteredImage = app.medianFilter(app.CurrentImage);
                imshow(app.FilteredImage, 'Parent', app.FilteredImageAxes);
                title(app.FilteredImageAxes, 'Median Filter');
            end
        end
        
        function MeanButtonPushed(app, ~)
            if ~isempty(app.CurrentImage)
                app.FilteredImage = app.meanFilter(app.CurrentImage);
                imshow(app.FilteredImage, 'Parent', app.FilteredImageAxes);
                title(app.FilteredImageAxes, 'Mean Filter');
            end
        end
        
        function BrightnessSliderValueChanged(app, ~)
            if ~isempty(app.CurrentImage)
                brightness_value = app.BrightnessSlider.Value * 2.55;
                enhanced = double(app.CurrentImage) + brightness_value;
                app.CurrentImage = uint8(min(max(enhanced, 0), 255));
                imshow(app.CurrentImage, 'Parent', app.OriginalImageAxes);
            end
        end
        
        function ContrastSliderValueChanged(app, ~)
            if ~isempty(app.CurrentImage)
                factor = (app.ContrastSlider.Value + 100)/100;
                enhanced = (double(app.CurrentImage) - 128) * factor + 128;
                app.CurrentImage = uint8(min(max(enhanced, 0), 255));
                imshow(app.CurrentImage, 'Parent', app.OriginalImageAxes);
            end
        end
        
        function SharpenButtonPushed(app, ~)
            if ~isempty(app.CurrentImage)
                kernel = [0 -1 0; -1 5 -1; 0 -1 0];
                sharpened = imfilter(double(app.CurrentImage), kernel, 'conv');
                app.CurrentImage = uint8(min(max(sharpened, 0), 255));
                imshow(app.CurrentImage, 'Parent', app.OriginalImageAxes);
            end
        end
        
        function ResetButtonPushed(app, ~)
            if ~isempty(app.OriginalImage)
                app.CurrentImage = app.OriginalImage;
                app.BrightnessSlider.Value = 0;
                app.ContrastSlider.Value = 0;
                imshow(app.CurrentImage, 'Parent', app.OriginalImageAxes);
            end
        end
        
        function SaveButtonPushed(app, ~)
            if ~isempty(app.FilteredImage)
                [filename, pathname] = uiputfile({'*.jpg', 'JPEG Image'});
                if ~isequal(filename, 0)
                    imwrite(app.FilteredImage, fullfile(pathname, filename));
                end
            end
        end
    end

    methods (Access = private)
        function createComponents(app)
           
            app.UIFigure = uifigure('Name', 'Image Processing App');
            app.UIFigure.Position = [100 100 900 600];
            
            app.OriginalImageAxes = uiaxes(app.UIFigure);
            app.OriginalImageAxes.Position = [50 300 350 250];
            title(app.OriginalImageAxes, 'Original Image');
            
            app.FilteredImageAxes = uiaxes(app.UIFigure);
            app.FilteredImageAxes.Position = [500 300 350 250];
            title(app.FilteredImageAxes, 'Filtered Image');
            
            btnStyle = {'FontWeight', 'bold', 'FontSize', 12};
            
            app.OpenImageButton = uibutton(app.UIFigure, btnStyle{:}, ...
                'Position', [50 250 120 30], 'Text', 'Open Image');
            
            app.ConservativeButton = uibutton(app.UIFigure, btnStyle{:}, ...
                'Position', [50 210 120 30], 'Text', 'Conservative');
            
            app.MedianButton = uibutton(app.UIFigure, btnStyle{:}, ...
                'Position', [50 170 120 30], 'Text', 'Median');
            
            app.MeanButton = uibutton(app.UIFigure, btnStyle{:}, ...
                'Position', [50 130 120 30], 'Text', 'Mean');
            
            app.SharpenButton = uibutton(app.UIFigure, btnStyle{:}, ...
                'Position', [500 250 120 30], 'Text', 'Sharpen');
            
            app.ResetButton = uibutton(app.UIFigure, btnStyle{:}, ...
                'Position', [500 210 120 30], 'Text', 'Reset');
            
            app.SaveButton = uibutton(app.UIFigure, btnStyle{:}, ...
                'Position', [500 170 120 30], 'Text', 'Save Image');
            
            app.BrightnessSlider = uislider(app.UIFigure, ...
                'Position', [200 250 150 20], 'Limits', [-100 100]);
            
            app.ContrastSlider = uislider(app.UIFigure, ...
                'Position', [200 210 150 20], 'Limits', [-100 100]);
            
            app.BrightnessLabel = uilabel(app.UIFigure, ...
                'Position', [200 270 150 20], 'Text', 'Brightness');
            
            app.ContrastLabel = uilabel(app.UIFigure, ...
                'Position', [300 270 150 20], 'Text', 'Contrast');
        end
    end

    methods (Access = public)
        function app = ImageProcessingApp_Final
            createComponents(app);
            
            app.OpenImageButton.ButtonPushedFcn = createCallbackFcn(app, @OpenImageButtonPushed, true);
            app.ConservativeButton.ButtonPushedFcn = createCallbackFcn(app, @ConservativeButtonPushed, true);
            app.MedianButton.ButtonPushedFcn = createCallbackFcn(app, @MedianButtonPushed, true);
            app.MeanButton.ButtonPushedFcn = createCallbackFcn(app, @MeanButtonPushed, true);
            app.SharpenButton.ButtonPushedFcn = createCallbackFcn(app, @SharpenButtonPushed, true);
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.SaveButton.ButtonPushedFcn = createCallbackFcn(app, @SaveButtonPushed, true);
            app.BrightnessSlider.ValueChangedFcn = createCallbackFcn(app, @BrightnessSliderValueChanged, true);
            app.ContrastSlider.ValueChangedFcn = createCallbackFcn(app, @ContrastSliderValueChanged, true);
            
            registerApp(app, app.UIFigure);
            runStartupFcn(app, @startupFcn);
        end

        function delete(app)
            delete(app.UIFigure);
        end
    end
end