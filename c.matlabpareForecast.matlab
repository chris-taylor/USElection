function data = compareForecast(year)

    forecast = loadForecast(year);
    result   = loadResults(year);
   
    nCorrect = 0;
    right    = {};
    wrong    = {};
    
    for ii = 1:length(result.state)
       
        idx = strmatch(result.state{ii},forecast.state,'exact');
        
        prediction = forecast.result{idx};
        
        if strcmp(prediction,result.result{ii})
            nCorrect = nCorrect + 1;
            right{end+1} = result.state{ii};
        else
            wrong{end+1} = result.state{ii};
        end
        
    end
    
    data.nCorrect = nCorrect;
    data.right    = right;
    data.wrong    = wrong;
    
end