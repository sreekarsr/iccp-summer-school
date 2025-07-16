function [vid, src] = fliropen(ID)
    arguments
        ID = 1
    end

    vid = videoinput('gentl', ID, 'Mono16');
%     vid = videoinput('gentl', 1, 'Morno8');
    src = getselectedsource(vid);
    vid.FramesPerTrigger = 1;
    % triggerconfig manual?
    src.ExposureAuto = 'off';
    src.GainAuto = 'off';
%     src.ExposureTime = exposuretime;
    src.Gain = 0;
    src.GammaEnable = 'False';
    src.SharpeningEnable = 'False';
end