module PlanetLike
  def spin_on_axis
    "I'm getting dizzy"
  end
end

class TheWorld
  include PlanetLike
  
  def self.bizarro
    "The Bizarro World"
  end
  def earth
    air
    water
    land
  end
  def land(name)
    puts "land"
  end
  def air
    oxygen
    nitrogen
  end
  def river(elevation_loss)
    water
  end
  def water(x, y, z)
    hydrogen + oxygen + hydrogen
  end
  def hydrogen
    atom
  end
  def nitrogen
    atom
  end
  def oxygen
    atom
  end
  def carbon
    atom
  end
  def atom
    puts "atom"
  end
end
