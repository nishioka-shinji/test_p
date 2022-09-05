class Purchase
  attr_reader :purchase_details
  attr_reader :extra_fees
  attr_reader :grand_total
  attr_reader :number_of_people
  attr_reader :number_of_people_for_extra_fees

  def initialize(ticket_type, price_type, amount)
    @purchase_details = []
    @extra_fees       = []
    @grand_total      = 0
    @number_of_people = 0
    @number_of_people_for_extra_fees = 0.0

    add(ticket_type, price_type, amount)
  end

  def add(ticket_type, price_type, amount)
    target_detail = purchase_details.find do |purchase_detail|
      ticket = purchase_detail.ticket
      ticket.ticket_type == ticket_type && ticket.price_type == price_type
    end

    if target_detail.nil?
      purchase_details << PurchaseDetail.new(ticket_type, price_type, amount)
    else
      target_detail.add_amount!(amount)
    end

    calc_people(amount, price_type)
    calc_grand_total
    set_extra_fees
  end

  def result
    grand_total + extra_fees.map(&:price).sum
  end

  private

  def calc_people(amount, price_type)
    @number_of_people += amount
    if price_type == Ticket::PRICE_TYPE[:child]
      @number_of_people_for_extra_fees += amount * 0.5
    else
      @number_of_people_for_extra_fees += amount
    end
  end

  def calc_grand_total
    total_prices = purchase_details.map do |purchase_detail|
      purchase_detail.total_price
    end

    @grand_total = total_prices.sum
  end

  def set_extra_fees
    @extra_fees = ExtraFee::INFO.keys.map do |type|
      ef = ExtraFee.new(type, grand_total, number_of_people_for_extra_fees)
      next if ef.price.zero?
      ef
    end

    @extra_fees = @extra_fees.compact
  end
end