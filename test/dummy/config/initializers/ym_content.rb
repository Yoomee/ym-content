# encoding: utf-8

YmContent.config do |config|
  # Should the permalinks of content packages be nested based on there position in the Content list
    # For example:                                                            
            # Parent Page (/parent)                                                                                                                                                                      
            #   |                                                          
            #   +--+Child Page (/parent/child)                                                                                                   
            #   |                                                          
            #   +--+Another Child page (/parent/another-child)                                   
            #      |                                                     
            #      +-->Grandchild page (/parent/another-child/grandchild                                
    config.nested_permalinks = true
end