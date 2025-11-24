class CsvImporter
  require "csv"

  def self.load(file)
    raw = File.read(file.path, encoding: "bom|utf-8")

    CSV.parse(raw, headers: true)
  end
end
