require 'test_helper'

class SongTest < ActiveSupport::TestCase
  setup do
    @song = Song.make
  end

  test "belongs to an artist" do
    artist = Artist.make
    assert_equal artist, @song.artist
  end

  test "has an title" do
    assert_equal 'Stress', @song.title
  end

  test "has a path" do
    assert_equal 'Justice/Cross/Stress.mp3', @song.path
  end

  test "has a full_path" do
    assert_equal 'Justice/Cross/Stress.mp3', @song.path
  end

  test "has an album" do
    assert_equal 'Cross', @song.album.name
  end

  test "knows equivalence" do
    assert_equal Song.new(:path => 'Justice/Cross/Stress.mp3'), @song
  end

  test "finds a song by any" do
    songs = Song.find([:any, 'justice'])
    assert_equal 1, songs.size
  end

  test "now_playing" do
    assert Song.now_playing.nil?
  end

  test "finds a song by its title" do
    songs = Song.find([:title, 'stress'])
    assert_equal 1, songs.size
  end

  test "can't find a song if it's not there" do
    songs = Song.find([:title, 'vancouver'])
    assert_equal 0, songs.size
  end

  test "artist name" do
    assert_equal 'Justice', @song.artist_name
  end

  test "album name" do
    assert_equal 'Cross', @song.album_name
  end

  test "knows its duration" do
    assert_equal '0:05', @song.duration
  end

  test "album art_file" do
    assert_equal '80b4dc3de74629cbf80fc85fdac0c89701a50887.png', @song.art_file
  end

  test "queued?" do
    PlayQueue.clear
    assert !@song.queued?

    Play.mpd.add(@song.path)
    assert @song.queued?
  end

  test "likes" do
    assert_empty @song.likes

    Like.create(:user => User.new, :song_path => @song.path)

    assert_not_empty @song.likes
  end

  test "song_plays" do
    assert_empty @song.song_plays

    SongPlay.make! :song_path => @song.path

    assert_not_empty @song.song_plays
  end

  test "to_param" do
    assert_equal 'Stress', @song.to_param
  end

  test "to_hash" do
    song = Song.make
    song_hash = song.to_hash

    hash_keys = song_hash.keys
    assert_equal 11, hash_keys.size
    assert hash_keys.include?(:title)
    assert hash_keys.include?(:album_name)
    assert hash_keys.include?(:album_slug)
    assert hash_keys.include?(:artist_name)
    assert hash_keys.include?(:artist_slug)
    assert hash_keys.include?(:album_art_path)
    assert hash_keys.include?(:seconds)
    assert hash_keys.include?(:liked)
    assert hash_keys.include?(:queued)
    assert hash_keys.include?(:slug)
    assert hash_keys.include?(:path)
  end
end
