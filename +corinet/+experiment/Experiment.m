classdef Experiment < handle
    
    %EXPERIMENT Interface class for corinet experiments
    
    methods (Abstract)
        run(obj)
        train(obj)
        test(obj)
    end
end

