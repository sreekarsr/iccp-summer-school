vid = videoinput('gentl', 2, 'Mono10');
src = getselectedsource(vid);

vid.FramesPerTrigger = 1;

preview(vid);

start(vid);
