require_relative "item_manager"
require_relative "ownable"
require_relative "item"

class Cart
  include ItemManager
  include Ownable

  def initialize(owner)
    self.owner = owner 
    @items = []
  end

  def items
    @items 
    # Cartにとってのitemsは自身の@itemsとしたいため、ItemManagerのitemsメソッドをオーバーライドします。
    # CartインスタンスがItemインスタンスを持つときは、オーナー権限の移譲をさせることなく、自身の@itemsに格納(Cart#add)するだけだからです。
    #　オーバライドしないとタイミングによってselfがカート自体になる！
  end
   
  #追加：オーナーのウォレットから引くメソッドを追加
  def charge(amount)
    if owner.wallet >= amount
       owner.wallet -= amount
      true
    else
      false
    end
  end


#アイテムを追加する際に、オーナーを設定するメソッドを追加
  def add(item)
    @items << item
  end

  def total_amount
    @items.sum(&:price)
  end

  def check_out
    items.each do |item|
      price = item.price
      owner.wallet.withdraw(price) #cartの中にいるオーナーのウォレットから金額を引く。メソッドwithdrawを呼び出す
      item.owner.wallet.deposit(price) #アイテムを所有者(seller)売る側のwalletにdepositする。

      item.owner = owner #itemの所有者(seller)からカートの所有者(customer)に所有権を移譲す
    end
    @items = []
    #binding.irb

    return if owner.wallet.balance < total_amount
  # ## 要件
  #   - カートの中身（Cart#items）のすべてのアイテムの購入金額が、カートのオーナーのウォレットからアイテムのオーナーのウォレットに移されること。
  #   - カートの中身（Cart#items）のすべてのアイテムのオーナー権限が、カートのオーナーに移されること。
  #   - カートの中身（Cart#items）が空になること。

  # ## ヒント
  #   - カートのオーナーのウォレット ==> self.owner.wallet
  #   - アイテムのオーナーのウォレット ==> item.owner.wallet
  #   - お金が移されるということ ==> (？)のウォレットからその分を引き出して、(？)のウォレットにその分を入金するということ
  #   - アイテムのオーナー権限がカートのオーナーに移されること ==> オーナーの書き換え(item.owner = ?)
  end

end

   #binding.irb
     
#ウォレットの残高が減らないといけない。チェックアウトの中で行う
#DICの残が増えるようにする
#売る人の財布に商品お金を入れる。
#買う人の財布からお金と商品を引く。
#アイテムのオーナーを探su
#アイテムのオーナー見つけたあと、オーナーの財布に金額と商品を入れる。
#depositを使う。
#所有権を変える。