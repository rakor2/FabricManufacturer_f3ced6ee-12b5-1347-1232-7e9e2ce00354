function getClothParameters(entity)
   return assert(false, 'Function not implemented') 
end

function findAttachmentWithClothParamat(entity)
    return assert(false, 'Function not implemented') 
end

function getClothParameters(entity)
   return assert(false, 'Function not implemented') 
end

function findAttachmentsWithClothParameters(entity)
    if entity and entity.Visual then
        for attachment, v in pairs(entity.Visual.Visual.Attachments) do
            for x,z in pairs(attachment) do
                DPrint(x)
                DPrint(z)
            end
        end    
    end
end

