require 'data_mapper'

module PlayWhe

  module Storage

    DataMapper::Property.required(true)

    class Result
      include DataMapper::Resource

      storage_names[:default] = 'results'

      property :draw,   Integer, key: true
      property :date,   Date
      property :period, Integer
      property :mark,   Integer

      validates_with_method :draw, method: :check_draw
      validates_within :period, set: 1..3
      validates_within :mark,   set: PlayWhe::LOWEST_MARK..PlayWhe::HIGHEST_MARK

    private

      def check_draw
        self.draw >= 1 ? true : [false, 'The draw must be a positive integer']
      end
    end

    class Task
      include DataMapper::Resource

      storage_names[:default] = 'tasks'

      property :id,         Serial
      property :year,       Integer,  unique: true
      property :month,      Integer
      property :status,     String
      property :created_at, DateTime, required: false
      property :updated_at, DateTime, required: false

      validates_with_method :year, method: :check_year
      validates_within :month, set: 1..12
      validates_within :status, set: ['pending', 'completed']

      def completed?
        self.status == 'completed'
      end

    private

      def check_year
        if self.year >= PlayWhe::BIRTHDAY.year && self.year <= Date.today.year
          true
        else
          [false, 'The year is out of range']
        end
      end
    end

    class Error
      include DataMapper::Resource

      storage_names[:default] = 'errors'

      property :id,         Serial
      property :message,    Text
      property :created_at, DateTime, required: false
      property :updated_at, DateTime, required: false
    end

    DataMapper.finalize
  end
end
