require 'data_mapper'
require 'date'

module PlayWhe

  def self.init_db(log_level = :debug)
    setup_db(log_level)

    DataMapper.auto_migrate!
  end

  def self.update_db(log_level = :debug)
    setup_db(log_level)

    (BIRTHDAY.year..Date.today.year).each do |year|
      task = Task.first_or_create({ year: year }, { month: 1, status: 'pending' })

      unless task.completed?
        DataMapper.logger << "retrieving results for year #{year}..."

        before = Proc.new do |month|
          if month < task.month
            DataMapper.logger << "  - skipping #{Date::MONTHNAMES[month]}"
            true # skip
          else
            DataMapper.logger << "  + at #{Date::MONTHNAMES[month]}"
            false # do not skip
          end
        end

        after = Proc.new do |month, flag, results|
          case flag
          when :ok
            Result.transaction do |t|
              begin
                results.each do |r|
                  result = Result.new

                  result.draw   = r[:draw]
                  result.date   = r[:date]
                  result.period = r[:period]
                  result.mark   = r[:mark]

                  unless result.save
                    DataMapper.logger << "    - invalid data: #{result.draw} #{result.date} #{result.period} #{result.mark}"
                    Error.create(message: r.to_s)
                  end
                end

                today = Date.today
                if Date.new(year, month) < Date.new(today.year, today.month)
                  if month == 12
                    task.status = 'completed'
                  else
                    task.month += 1
                  end

                  if task.save
                    DataMapper.logger << '  + success!'

                    true # continue
                  else
                    DataMapper.logger << '  - failed!'

                    false # do not continue
                  end
                else
                  DataMapper.logger << 'DONE!'

                  false # do not continue
                end
              rescue
                t.rollback

                DataMapper.logger << 'Encountered an error... Stopping!'

                false # do not continue
              end
            end
          when :error
            DataMapper.logger << 'Encountered an error... Stopping!'

            false # do not continue
          end
        end

        results_for_year(year, before: before, after: after)
      end
    end
  end

private

  def self.setup_db(log_level)
    DataMapper::Logger.new($stdout, log_level)
    DataMapper.setup(:default, "sqlite://#{File.expand_path('../../../data/playwhe.db', __FILE__)}")
  end
end
