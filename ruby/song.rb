class Song
  @@plays = 0

  attr_accessor :name
  attr_accessor :artist
  attr_accessor :duration
  
  def initialize(name, artist, duration)
    @name = name
    @artist = artist
    @duration = duration
	@plays = 0
  end
  
  def duration_in_minutes
    @duration / 60.0
  end
  
  def duration_in_minutes=(new_duration)
    @duration = (new_duration * 60).to_i
  end
  
  def play
    @plays += 1
	@@plays += 1
	puts "The song: #@plays plays. Total #@@plays plays."
  end

  def to_s
    "Song: #@name--#@artist (#@duration)"
  end
end

class MyLogger
  private_class_method :new
  @@logger = nil
  
  def MyLogger.create
    @@logger = new unless @@logger
	@@logger
  end
end

class SongList
  MAX_TIME = 5 * 60
  
  def initialize
    @songs = Array.new
  end
  
  def append(song)
    @songs.push(song)
	self
  end
  
  def delete_first
    @songs.shift
  end
  
  def delete_last
    @songs.pop
  end
  
  def [](index)
    @songs[index]
  end
  
  def with_title_v1(title)
    for i in 0...@songs.length
      return @songs[i] if title == @songs[i].name
    end
    return nil
  end
  
  def with_title_v2(title)
    @songs.find { |song| title == song.name }
  end
  
  def SongList.is_too_long(song)
    song.duration > MAX_TIME
  end
end

require 'test/unit'
class TestSongList < Test::Unit::TestCase
  def test_delete
    list = SongList.new
	s1 = Song.new('title1', 'artist1', 1)
	s2 = Song.new('title2', 'artist2', 2)
	s3 = Song.new('title3', 'artist3', 3)
	s4 = Song.new('title4', 'artist4', 4)

	list.append(s1).append(s2).append(s3).append(s4)
	
	assert_equal(s1, list[0])
	assert_equal(s3, list[2])
	assert_nil(list[9])
	
	assert_equal(s1, list.delete_first)
	assert_equal(s2, list.delete_first)
	assert_equal(s4, list.delete_last)
	assert_equal(s3, list.delete_last)
	assert_nil(list.delete_last)
  end
end