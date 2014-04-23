shared_examples_for "a record with valid phone number" do
  it "does not allow invalid phone numbers" do
    bad_numbers = ["123", "123 444 1212", "312 454 5765", "(122) 223-2332",
                   "232-2323232","(122) 444 1212", "232-233-293S", "232-232-232",
                   "2223331212", "22212312344", "112-654-5557"]
    bad_numbers.each do |bad_number|
      subject.__send__("phone=", bad_number)
      expect(subject).not_to be_valid
    end
  end
end



