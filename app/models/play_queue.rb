class PlayQueue
  # Add a song to the end of the Queue.
  #
  # song - The Song instance to add to the Queue.
  # user - The User that requested this song (can be nil if auto-played).
  #
  # Returns the Queue.
  def self.add(song,user)
    Play.mpd.add(song.path)

    if user
      user.play!(song)
    else
      SongPlay.create(:song_path => song.path, :user => nil)
    end
    songs
  end

  # Finds all the songs in the queue that we're looking for and removes
  # them.
  #
  # song - The Song instance to remove from the Queue.
  #
  # Returns the Queue.
  def self.remove(song,user)
    positions = []
    songs.each_with_index do |queued_song, i|
      positions << (i) if song.path == queued_song.path
    end

    positions.each { |position| Play.mpd.delete(position) }

    songs
  end

  # Get the current playing song
  #
  # Returns the current Song.
  def self.now_playing
    if record = Play.mpd.queue.first
      Song.new(:path => record.file)
    end
  end

  # Clears the queue.
  #
  # Returns nothing.
  def self.clear
    Play.mpd.clear
  end

  # List all of the songs in the Queue.
  #
  # Returns an Array of Songs.
  def self.songs
    results = ActiveSupport::Notifications.instrument("queue.mpd") do
      Play.mpd.queue
    end

    results.map do |result|
      Song.new(:path => result.file)
    end
  end
end
