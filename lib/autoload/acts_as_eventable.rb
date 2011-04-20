module ActsAsEventable #:nodoc:
  module Acts #:nodoc:
    module Eventable #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def acts_as_eventable
          after_create :create_event
          include ActiveRecord::Acts::Event::InstanceMethods
          has_one :event, :as => :eventable, :dependent => :destroy
        end  
      end
      
      module InstanceMethods
        def init_event
          Event.create(:eventable => self,:user => self.user,:venue => self.venue)
        end
      end
    end
  end
end
ActiveRecord::Base.send(:include, ActsAsEventable::Acts::Eventable)