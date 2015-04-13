class ActivityState
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :lrs

  field :state, type: Hash, default: {}

end
