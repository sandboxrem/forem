module Forem
  class Subscription < ActiveRecord::Base
    belongs_to :topic
    belongs_to :subscriber, :class_name => Forem.user_class.to_s

    validates :subscriber_id, :presence => true

    def send_notification(post_id)
      SubscriptionMailer.topic_reply(post_id, subscriber.id).deliver
    end
  end
end
