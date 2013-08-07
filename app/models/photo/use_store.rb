module Photo::UseStore
  extend ActiveSupport::Concern

  included do
    attr_accessible :fullsize_url, :thumbnail_url
    store :optional, accessors: [ :fullsize_url, :thumbnail_url ]

    validates :fullsize_url, presence: true
    validates :thumbnail_url, presence: true
  end  

end
