class ConvertSatoshisToBitcoins < PowerTypes::Command.new(:satoshis)
  def perform
    @satoshis / 100_000_000
  end
end
