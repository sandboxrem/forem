require 'friendly_id'

module Forem
  class Category < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, use: [:slugged, :history, :finders]

    has_many :forums do
      def actual
        joins(:topics).group("forem_forums.id").order("max(last_post_at) desc")
      end
    end
    validates :name, :presence => true
    validates :position, numericality: { only_integer: true }

    scope :by_position, -> { order(:position) }

    def to_s
      name
    end

  end
end
