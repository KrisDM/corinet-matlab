classdef BlockBased < corinet.net.network.base.Network
    
    %BLOCKBASED Network consisting of blocks of nodes
    
    properties (Access = private, Hidden)
        idToBlock
    end
    properties (SetAccess = private)
        blockIDs = {} %to keep them in the order as added
    end
    properties (Dependent)
        numBlocks
    end
    
    methods
        %
        % CONSTRUCTOR
        %
        function obj = BlockBased(netMaker)
            obj = obj@corinet.net.network.base.Network(netMaker);
            obj.idToBlock = containers.Map;
        end
        %
        % LOAD/SAVE functionality
        %
        function s = saveobj(obj)
            s = saveobj@corinet.net.network.base.Network(obj);
            blocks = values(obj.idToBlock,obj.blockIDs);
            s.blockMakers = cell(1,numel(blocks)); 
            for i=1:numel(blocks)
                s.blockMakers{i} = saveobj(blocks{i});
            end
        end
        function obj = reload(obj,s)
            obj = reload@corinet.net.network.base.Network(obj,s);
            if isfield(s,'blockMakers')
                for i=1:numel(s.blockMakers)
                    fHandle = str2func(sprintf('%s.loadobj',s.blockMakers{i}.className));
                    addBlock(obj,s.blockMakers{i}.ID,fHandle(s.blockMakers{i}));
                end
            end
        end 
    end
    
    methods (Static = true)
        %
        % LOAD/SAVE functionality
        %
        function obj = loadobj(s)
            obj = corinet.net.network.base.BlockBased(s);
            obj = reload(obj,s);
        end    
    end
    
    methods 
        %
        % GET/SET functionality
        %
        function r = get.numBlocks(obj)
            r = length(obj.idToBlock);
        end
    end
    
    methods 
        %
        % BUILD functionality
        %
        function addBlock(obj,block)
            if ~isa(block,'corinet.net.block.base.Block')
                ME = MException('Network:NotABlock','''%s'' is not a valid subtype of ''corinet.net.block.base.Block''.',class(block));
                throw(ME);
            end
            if obj.idToBlock.isKey(block.ID)
                ME = MException('Network:BlockAlreadyIn','A block with ID ''%s'' already exists in this network.',block.ID);
                throw(ME);
            end
            obj.blockIDs{end+1} = block.ID;
            obj.idToBlock(block.ID) = block;
        end  
        function rsult = getBlock(obj,blockID)
            if ~obj.idToBlock.isKey(blockID)
                ME = MException('Network:UnknownBlockID','Unknown block ID ''%s''.',blockID);
                throw(ME);
            end
            rsult = obj.idToBlock(blockID);
        end
    end
    
    methods (Abstract)
        %
        % BUILD functionality
        %
        connect(obj,s)
    end
end

