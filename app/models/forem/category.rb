require 'friendly_id'

module Forem
  class Category < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, :use => :slugged

    has_many :forums do
      def actual
        joins(:topics).group("forem_forums.id").order("max(last_post_at) desc")
      end
    end
    validates :name, :presence => true
    attr_accessible :name

    def to_s
      name
    end

  end
end
