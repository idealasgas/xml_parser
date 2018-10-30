class CDATA
  attr_accessor :data
  def initialize(line)
    @data = line.match(/(?<=<!\[CDATA\[)([\s\S]*)(?=\]\]>)/)[0]
  end
end