module RequirementsHelper
  def requirement_description(requirement)
    if requirement.action.for_what == 'money'
      "需要#{requirement.total_money}元用于#{requirement.donate_for}。"
    elsif requirement.action.for_what == 'goods'
      "需要#{requirement.total_goods}件#{requirement.goods_is}。"
    elsif requirement.action.for_what == 'time'
      "需要#{requirement.total_people}人#{requirement.do_what}。"
    end
  end
end
