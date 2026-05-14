classdef ImageProcessingApp < matlab.apps.AppBase

    properties (Access = public)
        UIFigure            matlab.ui.Figure
        OriginalImageAxes   matlab.ui.control.UIAxes
        FilteredImageAxes   matlab.ui.control.UIAxes
        OpenImageButton     matlab.ui.control.Button
        ConservativeButton  matlab.ui.control.Button
        MedianButton        matlab.ui.control.Button
        MeanButton          matlab.ui.control.Button
        SaveButton          matlab.ui.control.Button
    end

    properties (Access = private)
        OriginalImage       
        FilteredImage       
    end

    methods (Access = private)

        function OpenImageButtonPushed(app, ~)
            
            [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files (*.jpg, *.png, *.bmp)'});
            if isequal(filename, 0)
                return; 
            end
            app.OriginalImage = imread(fullfile(pathname, filename));
            
            imshow(app.OriginalImage, 'Parent', app.OriginalImageAxes);
        end

        function ConservativeButtonPushed(app, ~)
           
            if ~isempty(app.OriginalImage)
                app.FilteredImage = conservative_smoothing(app.OriginalImage);
                imshow(app.FilteredImage, 'Parent', app.FilteredImageAxes);
            end
        end

        function MedianButtonPushed(app, ~)
           
            if ~isempty(app.OriginalImage)
                app.FilteredImage = median_smoothing(app.OriginalImage);
                imshow(app.FilteredImage, 'Parent', app.FilteredImageAxes);
            end
        end

        function MeanButtonPushed(app, ~)
           
            if ~isempty(app.OriginalImage)
                app.FilteredImage = mean_smoothing(app.OriginalImage);
                imshow(app.FilteredImage, 'Parent', app.FilteredImageAxes);
            end
        end

        function SaveButtonPushed(app, ~)
           
            if ~isempty(app.FilteredImage)
                [filename, pathname] = uiputfile({'*.jpg', 'JPEG Image (*.jpg)'});
                if isequal(filename, 0)
                    return; 
                end
                imwrite(app.FilteredImage, fullfile(pathname, filename));
            end
        end
    end

    methods (Access = private)

        function createComponents(app)

            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 800 600];
            app.UIFigure.Name = 'Image Processing App';

            app.OriginalImageAxes = uiaxes(app.UIFigure);
            app.OriginalImageAxes.Position = [50 350 300 200];
            app.OriginalImageAxes.XTick = [];
            app.OriginalImageAxes.YTick = [];
            title(app.OriginalImageAxes, 'Original Image');

            app.FilteredImageAxes = uiaxes(app.UIFigure);
            app.FilteredImageAxes.Position = [450 350 300 200];
            app.FilteredImageAxes.XTick = [];
            app.FilteredImageAxes.YTick = [];
            title(app.FilteredImageAxes, 'Filtered Image');

            app.OpenImageButton = uibutton(app.UIFigure, 'push');
            app.OpenImageButton.ButtonPushedFcn = createCallbackFcn(app, @OpenImageButtonPushed, true);
            app.OpenImageButton.Position = [50 300 100 30];
            app.OpenImageButton.Text = 'Open Image';

            app.ConservativeButton = uibutton(app.UIFigure, 'push');
            app.ConservativeButton.ButtonPushedFcn = createCallbackFcn(app, @ConservativeButtonPushed, true);
            app.ConservativeButton.Position = [50 250 100 30];
            app.ConservativeButton.Text = 'Conservative';

            app.MedianButton = uibutton(app.UIFigure, 'push');
            app.MedianButton.ButtonPushedFcn = createCallbackFcn(app, @MedianButtonPushed, true);
            app.MedianButton.Position = [50 200 100 30];
            app.MedianButton.Text = 'Median';

            app.MeanButton = uibutton(app.UIFigure, 'push');
            app.MeanButton.ButtonPushedFcn = createCallbackFcn(app, @MeanButtonPushed, true);
            app.MeanButton.Position = [50 150 100 30];
            app.MeanButton.Text = 'Mean';

            app.SaveButton = uibutton(app.UIFigure, 'push');
            app.SaveButton.ButtonPushedFcn = createCallbackFcn(app, @SaveButtonPushed, true);
            app.SaveButton.Position = [50 100 100 30];
            app.SaveButton.Text = 'Save Image';
        end
    end

    methods (Access = public)

        function app = ImageProcessingApp

            createComponents(app)

            registerApp(app, app.UIFigure)

            runStartupFcn(app, @startupFcn)
        end

        function delete(app)
            
            delete(app.UIFigure)
        end
    end
end