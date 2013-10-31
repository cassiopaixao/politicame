class Video < ActiveRecord::Base
  attr_accessible :embed_type, :embed_url, :source_name, :source_title, :source_url, :title
end
