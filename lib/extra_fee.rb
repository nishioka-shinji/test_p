class ExtraFee
  # 加算タイプ
  DISCOUNT = 0
  SURCHARGE = 1

  # 計算方法
  FLOATING = 0
  FIXED    = 1

  # 対象要素
  TARGET_NUMBER_OF_PEOPLE = 0
  TARGET_TIME_ZONE        = 1
  TARGET_HOLIDAY          = 2
  TARGET_WDAY             = 3

  # 種類
  GROUP_DISCOUNT    = 0
  EVENING_DISCOUNT  = 1
  HOLIDAY_SURCHARGE = 2
  MON_DISCOUNT      = 3
  WED_DISCOUNT      = 4
  INFO = {
    GROUP_DISCOUNT    => { name: '団体割引', value: 0.1, add_type: DISCOUNT,  calc_type: FLOATING, target: TARGET_NUMBER_OF_PEOPLE, threshold_min: 10,  threshold_max: nil },
    EVENING_DISCOUNT  => { name: '夕方料金', value: 100, add_type: DISCOUNT,  calc_type: FIXED,    target: TARGET_TIME_ZONE,        threshold_min: 17,  threshold_max: 22  },
    HOLIDAY_SURCHARGE => { name: '休日料金', value: 200, add_type: SURCHARGE, calc_type: FIXED,    target: TARGET_HOLIDAY,          threshold_min: nil, threshold_max: nil },
    MON_DISCOUNT      => { name: '月水割引', value: 100, add_type: DISCOUNT,  calc_type: FIXED,    target: TARGET_WDAY,             threshold_min: 1,   threshold_max: nil },
    WED_DISCOUNT      => { name: '月水割引', value: 100, add_type: DISCOUNT,  calc_type: FIXED,    target: TARGET_WDAY,             threshold_min: 2,   threshold_max: nil },
  }

  attr_reader :info
  attr_reader :payment
  attr_reader :number_of_people

  def initialize(type, payment = 0, number_of_people = 0)
    @info = INFO[type]
    @payment = payment
    @number_of_people = number_of_people
  end

  def price
    return 0 unless can_calc_extra_fee?

    calc_extra_fee
  end

  def name
    info[:name]
  end

  def surcharge?
    info[:add_type] == SURCHARGE
  end

  private

  def can_calc_extra_fee?
    case target
    when TARGET_NUMBER_OF_PEOPLE
      threshold_min <= number_of_people
    when TARGET_TIME_ZONE
      Time.now.hour.between?(threshold_min, threshold_max)
    when TARGET_HOLIDAY
      Time.now.sunday? || Time.now.saturday?
    when TARGET_WDAY
      Time.now.wday == threshold_min
    end
  end

  def calc_extra_fee
    return calc_type_fixed if calc_type_fixed?

    calc_type_floating
  end

  def calc_type_fixed
    discount? ? value * -1 : value
  end

  def calc_type_floating
    discount? ? (payment * 0.1 * -1).to_i : (payment * 0.1).to_i
  end

  def value
    info[:value]
  end

  def discount?
    info[:add_type] == DISCOUNT
  end

  def calc_type_fixed?
    info[:calc_type] == FIXED
  end

  def target
    info[:target]
  end

  def threshold_min
    info[:threshold_min]
  end

  def threshold_max
    info[:threshold_max]
  end
end