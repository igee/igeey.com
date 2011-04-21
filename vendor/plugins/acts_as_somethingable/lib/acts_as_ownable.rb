module ActiveRecord
  module Acts
    module Ownable
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def acts_as_ownable
          include ActiveRecord::Acts::Ownable::InstanceMethods
        end  
      end
      
      module InstanceMethods
        def owned_by?(user)
          self.user == user
        end
      end
    end
  end
end
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Ownable)