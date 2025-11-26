# config/initializers/csv_encoding.rb
module CsvEncoding
  def self.read(file)
    # バイナリで読み込む
    raw = File.read(file.path, mode: "rb")

    # UTF-8 BOM 付きならそのままUTF-8
    return raw.force_encoding("UTF-8") if raw.start_with?("\xEF\xBB\xBF")

    # UTF-8として妥当ならそのまま
    utf8 = raw.dup.force_encoding("UTF-8")
    return utf8 if utf8.valid_encoding?

    # ダメなら Shift_JIS として解釈して UTF-8 に変換
    sjis = raw.dup.force_encoding("Shift_JIS")
    return sjis.encode("UTF-8") if sjis.valid_encoding?

    # それでもダメなら、置き換え付きで無理やりUTF-8に
    raw.encode("UTF-8", invalid: :replace, undef: :replace)
  end
end
