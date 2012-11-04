function newdata = mungeData(data)
%MUNGEDATA
%
%   When there are polls from the last month, take the mean.
%   If there is no poll in the last month, use the most recent month, or
%   the 2008 results when no poll is available.
    
    % Config for model. Take the mean of all polls from the last 30 days.
    dayWindow = 30;
    method    = @mean;
    
    % Munge poll data
    states = unique(data.state);
    
    lastDay = max(data.day);
    
    newdata.state = cell(51,1);
    newdata.p     = zeros(51,2);
    newdata.ev    = zeros(51,1);

    for ii = 1:length(states)
       
        state = states{ii};
        
        stateIdx = strmatch(state,data.state,'exact');
        
        lastMonthIdx = (lastDay - data.day(stateIdx)) < dayWindow;
        
        if ~any(lastMonthIdx)
            idx = stateIdx(1);
        else
            idx = stateIdx(lastMonthIdx);
        end
        
        p = bsxfun(@rdivide,[data.dem(idx) data.gop(idx)] ,(data.dem(idx)+data.gop(idx)));
        n = size(p,1);
        p = method(p,1);
        
        newdata.state{ii}    = state;
        newdata.p(ii,:)      = p;
        newdata.npolls(ii,:) = n;
        newdata.ev(ii)       = data.ev(idx(1));
         
    end

end