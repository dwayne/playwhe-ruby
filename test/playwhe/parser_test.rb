require "test_helper"

describe PlayWhe::Parser do
  describe "::parse" do
    it "returns a list of the results it finds in the order it finds it" do
      html_results = "<h2><strong> Draw #: </strong>1<br><strong> Date: </strong>04-Jul-94<br><strong> Mark Drawn: </strong>15<br><strong> Drawn at: </strong>AM<br></h2><br><h2><strong> Draw #: </strong>2<br><strong> Date: </strong>04-Jul-94<br><strong> Mark Drawn: </strong>11<br><strong> Drawn at: </strong>PM<br></h2><br><h2><strong> Draw #: </strong>3<br><strong> Date: </strong>05-Jul-94<br><strong> Mark Drawn: </strong>36<br><strong> Drawn at: </strong>AM<br></h2><br><h2><strong> Draw #: </strong>4<br><strong> Date: </strong>05-Jul-94<br><strong> Mark Drawn: </strong>31<br><strong> Drawn at: </strong>PM<br></h2><br><h2><strong> Draw #: </strong>5<br><strong> Date: </strong>06-Jul-94<br><strong> Mark Drawn: </strong>12<br><strong> Drawn at: </strong>AM<br></h2><br><h2><strong> Draw #: </strong>6<br><strong> Date: </strong>06-Jul-94<br><strong> Mark Drawn: </strong>36<br><strong> Drawn at: </strong>PM<br></h2><br><h2><strong> Draw #: </strong>7<br><strong> Date: </strong>07-Jul-94<br><strong> Mark Drawn: </strong>6<br><strong> Drawn at: </strong>AM<br></h2>"

      results = PlayWhe::Parser.parse(html_results)

      expect(results.length).must_equal 7
      expect(results[0]).must_equal \
        PlayWhe::Result.new \
          draw: 1, date: "1994-07-04", mark: 15, period: "AM"
      expect(results[1]).must_equal \
        PlayWhe::Result.new \
          draw: 2, date: "1994-07-04", mark: 11, period: "PM"
      expect(results[2]).must_equal \
        PlayWhe::Result.new \
          draw: 3, date: "1994-07-05", mark: 36, period: "AM"
      expect(results[3]).must_equal \
        PlayWhe::Result.new \
          draw: 4, date: "1994-07-05", mark: 31, period: "PM"
      expect(results[4]).must_equal \
        PlayWhe::Result.new \
          draw: 5, date: "1994-07-06", mark: 12, period: "AM"
      expect(results[5]).must_equal \
        PlayWhe::Result.new \
          draw: 6, date: "1994-07-06", mark: 36, period: "PM"
      expect(results[6]).must_equal \
        PlayWhe::Result.new \
          draw: 7, date: "1994-07-07", mark: 6, period: "AM"
    end
  end
end
