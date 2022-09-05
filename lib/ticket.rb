class Ticket
  TICKET_TYPE = {
    normal:  0,
    special: 1,
  }

  TICKET_TYPE_NAME = {
    TICKET_TYPE[:normal]  => '通常',
    TICKET_TYPE[:special] => '特別',
  }

  PRICE_TYPE = {
    adult:  0,
    child:  1,
    senior: 2,
  }

  PRICE_TYPE_NAME = {
    PRICE_TYPE[:adult] =>  '大人',
    PRICE_TYPE[:child] =>  '子供',
    PRICE_TYPE[:senior] => 'シニア',
  }

  TICKET_TYPE_PRICES  = {
    PRICE_TYPE[:adult] => {
      TICKET_TYPE[:normal]  => 1_000,
      TICKET_TYPE[:special] => 800
    },
    PRICE_TYPE[:child] => {
      TICKET_TYPE[:normal]  => 500,
      TICKET_TYPE[:special] => 400
    },
    PRICE_TYPE[:senior] => {
      TICKET_TYPE[:normal]  => 800,
      TICKET_TYPE[:special] => 500
    },
  }

  attr_reader :ticket_type
  attr_reader :price_type

  def initialize(ticket_type, price_type)
    @ticket_type = ticket_type
    @price_type  = price_type
  end

  def price
    TICKET_TYPE_PRICES[price_type][ticket_type]
  end

  def child?
    price_type == CHILD
  end
end