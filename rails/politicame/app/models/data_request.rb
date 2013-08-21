class DataRequest < ActiveRecord::Base
  attr_accessible :host, :id, :path, :query_str, :status_code, :when
end
