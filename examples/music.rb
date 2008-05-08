class MusicalPerformance
  def initialize
    m = Musician.new
    a = Audience.new
    m.announce_song
    a.gets_quieter
    m.play_instrument
    a.claps
  end
end

class Musician
  def announce_song
    puts "I am going to play a great song for you."
  end
  def play_instrument
    i = Instrument.new
    i.remove_from_case
    i.play
    i.put_in_case
  end
  def bluesy?
    true
  end
  def self.talented?
    "maybe"
  end
end

class Instrument
  def play
    make_sound
  end
  def make_sound
    puts "Honk! Squeak!"
  end
  def remove_from_case
    puts "The instrument is ready."
  end
  def put_in_case
    puts "The instrument is stored."
  end
  def self.prerequisites
    Musician
  end
end

class Audience
  def listens
    # Everything is quiet
  end
  def claps
    puts "Applause!"
  end
  def gets_quieter
    listens
  end
end
