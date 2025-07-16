vid = videoinput('gentl', 1, 'Mono10');
src = getselectedsource(vid);

vid.FramesPerTrigger = 1;

preview(vid);