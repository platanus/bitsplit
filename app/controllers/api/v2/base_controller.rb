class Api::V2::BaseController < Api::BaseController
  before_action do
    self.namespace_for_serializer = ::Api::V2
  end
end
