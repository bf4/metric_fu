DateRange = Struct.new(:start_date, :end_date) do
  def valid?
    if start_date.to_s != '' && end_date.to_s != ''
      start_date <= end_date
    else
      true
    end
  end
end
