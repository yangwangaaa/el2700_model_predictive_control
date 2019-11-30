if exist('lab','var')
    delete(lab)
end

t = timerfindall;
for timer = t
    stop(timer)
    delete(timer)
end

clear all;

delete *.mat