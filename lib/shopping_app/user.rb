require_relative "item_manager"
require_relative "wallet"

class User 
  include ItemManager

  attr_accessor :name
  attr_reader :wallet
  


  def initialize(name)
    @name = name
    @wallet = Wallet.new(self)

    # UserインスタンスまたはUserを継承したクラスのインスタンスは生成されると、自身をオーナーとするウォレットを持ちます。
  end


end
#カスタマーユーザーセラーの関係性が大事