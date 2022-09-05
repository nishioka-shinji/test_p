require './lib/purchase'
require './lib/purchase_detail'
require './lib/ticket'
require './lib/extra_fee'

purchase = nil
continue = false
loop do
  ticket_type = nil
  price_type  = nil
  amount      = nil

  loop do
    puts 'チケット種別を選択'
    puts Ticket::TICKET_TYPE_NAME.map { |k, v| "#{k}: #{v}" }.join(' ')

    ticket_type_s = gets.chomp
    ticket_type   = ticket_type_s.to_i

    if !Ticket::TICKET_TYPE.values.map(&:to_s).include?(ticket_type_s)
      puts '不正な値'
    else
      break
    end
  end

  loop do
    puts 'チケット種類を選択'
    puts Ticket::PRICE_TYPE_NAME.map { |k, v| "#{k}: #{v}" }.join(' ')

    price_type_s = gets.chomp
    price_type   = price_type_s.to_i

    if !Ticket::PRICE_TYPE.values.map(&:to_s).include?(price_type_s)
      puts '不正な値'
    else
      break
    end
  end

  loop do
    puts '枚数'
    amount_s = gets.chomp
    amount   = amount_s.to_i

    if !(amount_s =~ /\A[1-9]+[0-9]?\z/) || amount.negative?
      puts '不正な値'
    else
      break
    end
  end

  if continue
    purchase.add(ticket_type, price_type, amount)
  else
    purchase = Purchase.new(ticket_type, price_type, amount)
  end

  puts '他にありますか？'
  puts 'それ以外のキー: NO 1: YES'

  if gets.to_i != 1
    break
  else
    continue = true
  end
end

puts "販売合計代金 #{purchase.result}円"
puts "金額変更前合計金額 #{purchase.grand_total}円"
puts "金額変更明細"
purchase.extra_fees.each do |extra_fee|
  puts "#{extra_fee.name} #{extra_fee.price}円"
end