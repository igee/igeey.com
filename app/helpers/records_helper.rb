module RecordsHelper
  def record_description(record)
    if record.action.for_what == 'money'
      "#{record.money}元，用于#{record.donate_for}。"
    elsif record.action.for_what == 'goods'
      "#{record.goods}件#{record.goods_is}。"
    elsif record.action.for_what == 'time'
      "#{record.do_what}共#{record.time}小时。"
    end
  end
end
