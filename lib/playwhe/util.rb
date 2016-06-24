module PlayWhe::Util
  module_function

  def normalize_year(year)
    "%02d" % (year.to_i % 100)
  end

  def normalize_month(month)
    Date::ABBR_MONTHNAMES[month.to_i]
  end

  def months_alternation
    months = Date::ABBR_MONTHNAMES.dup
    months.shift
    months.join("|")
  end
end
