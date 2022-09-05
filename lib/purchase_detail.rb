class PurchaseDetail
  attr_reader :ticket
  attr_reader :amount
  attr_reader :total_price

  def initialize(ticket_type, price_type, amount)
    @ticket       = Ticket.new(ticket_type, price_type)
    @amount       = amount
    @total_price  = @ticket.price * amount
  end

  def add_amount!(add_amount)
    self.amount = amount + add_amount
    self.total_price = ticket.price * amount
  end

  private

  def amount=(value)
    @amount = value
  end

  def total_price=(value)
    @total_price = value
  end
end