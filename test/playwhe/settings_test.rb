require "test_helper"

describe PlayWhe::Settings do
  subject { PlayWhe::Settings.config }

  it "has the correct defaults" do
    expect(subject.http.read_timeout).must_equal 5
    expect(subject.http.write_timeout).must_equal 5
    expect(subject.http.connect_timeout).must_equal 5
    expect(subject.url).must_equal \
      "http://nlcb.co.tt/app/index.php/pwresults/playwhemonthsum"
  end
end
