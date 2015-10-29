require 'awesome_print'
require 'mechanize'

station_list = [
  {
    "station" => "Hamburg, Jenfelder Allee",
    "name" => "JenfelderAllee",
    "distance" => 10 * 60
  },
  {
    "station" => "Hamburg, Schweidnitzer Straße",
    "name" => "SchweidnitzerStr",
    "distance" => 15 * 60
  }
]

SCHEDULER.every '1m', first_in: '1s' do
  station_list.each do |station|

    connections = []

    today = DateTime.now.strftime("%d.%m.%Y")
    now = (Time.now + station["distance"]).strftime("%H:%M")

    # ap "now = #{now}"

    # http://docs.seattlerb.org/mechanize/GUIDE_rdoc.html
    # einen neuen Agent initialisieren
    agent = Mechanize.new

    # einen Request für die Seite schicken. Das Page Objekt hält alle Elemente der Seite
    page = agent.get('http://www.hvv.de/fahrplaene/abfahrtsmonitor/index.php')
    # über page.form('xxx') kann man ein benanntes Formular von der Seite fischen.
    # ap page
    form = page.form('departure-listing-form')
    # die Felder des Formulars sind Attribute des form-Objekts
    form.station = station["station"]
    form.on = today
    form.at = now
    # das Formular wird über den Button abgeschickt
    page = agent.submit(form, form.buttons.first)

    # in diesem Hash speichern wir alle Abfahrten für eine Linie (S31, R71, etc)
    connections = []

    # die Abfahrten stehen in der Tabelle .departures-listing, die erste Zeile kann weg
    # da stehen nur die Überschriften
    page.search('.departures-listing tr').drop(1).each do |row|
      # die Füchse haben die Linie nur als Bild hinterlegt
      img = row.at_css('img')
      # dafür aber die Bilder-Url konsequent bennant.
      line = img["src"].match('lineKey=[A-Z_-]+:([\w]+)_')[1]
      # die zweite Spalte ist die Richtung
      direction = row.search('td')[1].content
      # in der dritten steht die Zeit, muss ein wenig bereinigt werden
      departure = row.search('td')[2].content.gsub(/\s/, "").sub("(", " (")

      # ap line
      # ap direction
      # ap departure

      # die IC/Es interessieren uns nicht
      #if line[0] == "S" or line[0] == "R" or line[0] == "U" or line[0] == "A"
        connections << {
          label: "#{line} #{direction}",
          value: departure.sub(/\(\+0\)/, '')
        }
      #end

    end

    # ap connections
    send_event('hvv_' + station["name"].downcase, { items: connections[0..8] })
  end
end
