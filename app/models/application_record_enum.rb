class ApplicationRecordEnum
  def self.codes(codes)
    const_set 'CODES', codes.freeze
    const_set 'CODES_MAP', codes.map(&:to_sym).zip(codes).to_h
    codes.each do |code|
      const_set(code.split('_').map(&:capitalize).join, code)
    end
  end
end
