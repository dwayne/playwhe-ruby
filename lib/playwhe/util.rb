module PlayWhe::Util
  module_function

  def normalize_year(year)
    "%02d" % (year.to_i % 100)
  end

  def normalize_month(month)
    Date::ABBR_MONTHNAMES[month.to_i]
  end
end
