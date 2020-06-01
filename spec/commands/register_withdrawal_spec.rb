require 'rails_helper'

describe RegisterWithdrawal do
  def perform(*_args)
    described_class.for(*_args)
  end

  pending "describe what perform does here"
end